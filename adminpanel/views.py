from django.shortcuts import render, redirect, get_object_or_404
from django.db import connection
from django.http import JsonResponse
from django.db.models import Q
from django.utils.dateparse import parse_date
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.template.loader import get_template
from xhtml2pdf import pisa
from django.http import HttpResponse
from django.utils.dateparse import parse_date
from django.utils.timezone import now
from django.views.decorators.csrf import csrf_protect, csrf_exempt
from .models import User, Announcement, Request, Event
from .forms import AnnouncementForm, RequestForm
from datetime import datetime, date


def login_view(request):
    if request.method == 'POST':
        uname = request.POST.get('username')
        pword = request.POST.get('password')

        with connection.cursor() as cursor:
            cursor.callproc('checkCredentials', [uname, pword])
            result = cursor.fetchall()

        if result and result[0][0] == 1:
            # Login successful
            request.session['admin_username'] = uname
            return redirect('dashboard')
        else:
            return render(request, 'adminpanel/login.html', {'error': 'Invalid credentials'})

    return render(request, 'adminpanel/login.html')


def logout_view(request):
    request.session.flush()
    return redirect('login')


def dashboard_view(request):
    if 'admin_username' not in request.session:
        return redirect('login')

    recent_requests = []
    with connection.cursor() as cursor:
        cursor.callproc('displayRequests')
        rows = cursor.fetchall()

        # Sort by date_submitted descending and slice top 5
        sorted_rows = sorted(
            rows,
            key=lambda x: x[4] if isinstance(x[4], datetime) else datetime.min,
            reverse=True
        )[:5]

        for row in sorted_rows:
            recent_requests.append({
                'id': row[0],
                'req_type': row[1],
                'description': row[2],
                'status': row[3],
                'date_submitted': row[4],
                'contact_number': row[5],
                'date_released': row[6],
                'first_name': row[7],
                'last_name': row[8],
                'middle_name': row[9],
                'pickup_method': row[10],
                'purpose': row[11],
            })

    context = {
        'user': request.session['admin_username'],
        'recent_requests': recent_requests,
    }

    return render(request, 'adminpanel/dashboard.html', context)


def announcement_list(request):
    with connection.cursor() as cursor:
        cursor.callproc('displayAnnouncements')
        results = cursor.fetchall()

    announcements = [
        {
            'id': row[0],
            'title': row[1],
            'content': row[2],
            'date_posted': row[3],
        }
        for row in results
    ]

    return render(request, 'adminpanel/announcements/list.html', {'announcements': announcements, 'id': id})


def announcement_create(request):
    form = AnnouncementForm(request.POST or None)
    if form.is_valid():
        title = form.cleaned_data['title']
        content = form.cleaned_data['content']

        with connection.cursor() as cursor:
            cursor.callproc('insertAnnouncement', [title, content])

        return redirect('announcement_list')

    return render(request, 'adminpanel/announcements/form.html', {
        'form': form,
        'title': 'Add Announcement'
    })


def announcement_update(request, pk):
    ann = Announcement.objects.get(pk=pk)
    if request.method == 'POST':
        form = AnnouncementForm(request.POST, instance=ann)
        if form.is_valid():
            title = form.cleaned_data['title']
            content = form.cleaned_data['content']
            with connection.cursor() as cursor:
                cursor.callproc('updateAnnouncement', [pk, title, content])
            return redirect('announcement_list')
    else:
        form = AnnouncementForm(instance=ann)
    return render(request, 'adminpanel/announcements/form.html', {'form': form, 'title': 'Edit Announcement'})


def announcement_delete(request, pk):
    with connection.cursor() as cursor:
        cursor.callproc('deleteAnnouncement', [pk])
    return redirect('announcement_list')


def request_create(request):
    if request.method == 'POST':
        form = RequestForm(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            with connection.cursor() as cursor:
                cursor.callproc('insertRequest', [
                    data['first_name'],
                    data['middle_name'],
                    data['last_name'],
                    data['req_type'],
                    data['purpose'],
                    data['description'],
                    data['pickup_method'],
                    data['contact_number']
                ])
            messages.success(request, "Your request has been submitted successfully.")
            return redirect('request_list')
    else:
        form = RequestForm()
    return render(request, 'adminpanel/requests/form.html', {'form': form})


def request_list(request):
    pending_requests = []
    approved_requests = []

    with connection.cursor() as cursor:
        cursor.callproc('displayRequests')
        results = cursor.fetchall()
        for row in results:
            request_data = {
                'id': row[0],
                'req_type': row[1],
                'description': row[2],
                'status': row[3],
                'date_submitted': row[4],
                'contact_number': row[5],
                'date_released': row[6],
                'first_name': row[7],
                'last_name': row[8],
                'middle_name': row[9],
                'pickup_method': row[10],
                'purpose': row[11],
            }

            if row[3] == "Pending":
                pending_requests.append(request_data)
            elif row[3] == "Approved":
                approved_requests.append(request_data)

    return render(request, 'adminpanel/requests/list.html', {
        'pending_requests': pending_requests,
        'approved_requests': approved_requests,
    })


def request_update_status(request, pk, new_status):
    # Include 'Delivered' in allowed statuses
    allowed_statuses = ['Approved', 'Declined', 'Delivered']

    if new_status not in allowed_statuses:
        messages.error(request, 'Invalid status update.')
        return redirect('request_list')

    with connection.cursor() as cursor:
        cursor.callproc('updateRequestStatus', [pk, new_status, now()])

    messages.success(request, f"Request #{pk} marked as {new_status}.")
    return redirect('request_list')


def request_history(request):
    query = request.GET.get('q', '').strip().lower()
    start_str = request.GET.get('start', '').strip()
    end_str = request.GET.get('end', '').strip()
    sort_field = request.GET.get('sort', 'date_submitted')
    sort_order = request.GET.get('order', 'desc')

    header_columns = [
        ('id', '#'),
        ('last_name', 'Resident'),
        ('req_type', 'Type'),
        ('status', 'Status'),
        ('date_submitted', 'Submitted'),
        ('date_released', 'Released'),
        ('contact_number', 'Contact'),
    ]

    # Parse dates with error handling
    try:
        start_date = datetime.strptime(start_str, "%Y-%m-%d").date() if start_str else None
        end_date = datetime.strptime(end_str, "%Y-%m-%d").date() if end_str else None
    except ValueError:
        start_date = end_date = None

    archived_requests = []

    with connection.cursor() as cursor:
        cursor.callproc('displayRequests')
        rows = cursor.fetchall()

        for row in rows:
            status = row[3]
            if status not in ['Delivered', 'Declined']:
                continue

            submitted = row[4]
            if isinstance(submitted, str):
                try:
                    submitted = datetime.strptime(submitted, "%Y-%m-%d %H:%M:%S")
                except:
                    submitted = None

            full_name = f"{row[8]} {row[7]} {row[9]}".lower()
            req_type = row[1].lower()

            if query and query not in full_name and query not in req_type:
                continue

            if start_date and not end_date:
                if not submitted or submitted.date() < start_date:
                    continue
            elif end_date and not start_date:
                if not submitted or submitted.date() > end_date:
                    continue
            elif start_date and end_date:
                if not submitted or not (start_date <= submitted.date() <= end_date):
                    continue

            archived_requests.append({
                'id': row[0],
                'req_type': row[1],
                'description': row[2],
                'status': status,
                'date_submitted': submitted,
                'date_released': row[6],
                'contact_number': row[5],
                'first_name': row[7],
                'last_name': row[8],
                'middle_name': row[9],
                'pickup_method': row[10],
                'purpose': row[11],
            })

    reverse = sort_order == 'desc'
    try:
        archived_requests.sort(
            key=lambda x: (x.get(sort_field) or '') if sort_field not in ['date_submitted', 'date_released']
                         else (x.get(sort_field) or datetime.min),
            reverse=reverse
        )
    except KeyError:
        pass  # Invalid sort_field fallback

    return render(request, 'adminpanel/requests/history.html', {
        'archived_requests': archived_requests,
        'query': query,
        'start_date': start_str,
        'end_date': end_str,
        'sort_field': sort_field,
        'sort_order': sort_order,
        'header_columns': header_columns,
    })


@csrf_protect
def request_decline_with_comment(request, pk):
    if request.method == "POST":
        comment = request.POST.get("comment", "").strip()
        if not comment:
            messages.error(request, "Decline reason is required.")
            return redirect('request_list')

        with connection.cursor() as cursor:
            cursor.execute("UPDATE adminpanel_request SET status = %s, description = %s, date_released = %s WHERE id = %s",
                ['Declined', comment, now(), pk])
        messages.success(request, f"Request #{pk} has been declined.")
    return redirect('request_list')


def export_request_history_pdf(request):
    query = request.GET.get('q', '').lower()
    start_date = parse_date(request.GET.get('start', ''))
    end_date = parse_date(request.GET.get('end', ''))

    archived_requests = []

    with connection.cursor() as cursor:
        cursor.callproc('displayRequests')
        results = cursor.fetchall()
        for row in results:
            status = row[3]
            if status not in ['Delivered', 'Declined']:
                continue

            full_name = f"{row[8]} {row[7]} {row[9]}".lower()
            req_type = row[1].lower()
            date_submitted = row[4]

            if query and query not in full_name and query not in req_type:
                continue

            if start_date and end_date and not (start_date <= date_submitted.date() <= end_date):
                continue

            archived_requests.append({
                'id': row[0],
                'req_type': row[1],
                'description': row[2],
                'status': status,
                'date_submitted': date_submitted,
                'contact_number': row[5],
                'date_released': row[6],
                'first_name': row[7],
                'last_name': row[8],
                'middle_name': row[9],
                'pickup_method': row[10],
                'purpose': row[11],
            })

    template = get_template('adminpanel/requests/history_pdf.html')
    html = template.render({
        'requests': archived_requests,
        'printed_at': datetime.now(),
        'filters': {
            'query': query,
            'start': request.GET.get('start', ''),
            'end': request.GET.get('end', '')
        }
    })

    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'inline; filename="request_history.pdf"'
    pisa.CreatePDF(html, dest=response)
    return response


def event_list(request):
    with connection.cursor() as cursor:
        cursor.callproc('displayEvents')
        events = cursor.fetchall()
    context = {'events': events}
    return render(request, 'adminpanel/events/list.html', context)


def event_create(request):
    if request.method == 'POST':
        title = request.POST['title']
        description = request.POST['description']
        event_date = request.POST['event_date']
        location = request.POST['location']

        with connection.cursor() as cursor:
            cursor.callproc('insertEvent', [title, description, event_date, location])
        messages.success(request, 'Event created successfully.')
        return redirect('event_list')

    return render(request, 'adminpanel/events/form.html', {'action': 'Add'})


def event_update(request, pk):
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM adminpanel_event WHERE id = %s", [pk])
        event = cursor.fetchone()

    if not event:
        messages.error(request, 'Event not found.')
        return redirect('event_list')

    if request.method == 'POST':
        title = request.POST['title']
        description = request.POST['description']
        event_date_raw = request.POST['event_date']
        location = request.POST['location']

        try:
            event_date = datetime.strptime(event_date_raw, "%Y-%m-%dT%H:%M")
        except ValueError:
            messages.error(request, 'Invalid event date format.')
            return redirect('event_update', pk=pk)

        with connection.cursor() as cursor:
            cursor.callproc('updateEvent', [pk, title, description, event_date, location])

        messages.success(request, 'Event updated successfully.')
        return redirect('event_list')

    context = {
        'action': 'Edit',
        'event': {
            'id': event[0],
            'title': event[1],
            'description': event[2],
            'event_date': event[3].strftime('%Y-%m-%dT%H:%M'),
            'location': event[5],
        }
    }
    return render(request, 'adminpanel/events/form.html', context)


def event_delete(request, pk):
    with connection.cursor() as cursor:
        cursor.callproc('deleteEvent', [pk])
    messages.success(request, 'Event deleted successfully.')
    return redirect('event_list')


@csrf_exempt
def calendar_events_api(request):
    events = []

    with connection.cursor() as cursor:
        cursor.execute("SELECT id, title, event_date FROM adminpanel_event")
        rows = cursor.fetchall()

        for row in rows:
            events.append({
                "id": row[0],
                "title": row[1],
                "start": row[2].isoformat(),  # must be ISO format
            })

    return JsonResponse(events, safe=False)