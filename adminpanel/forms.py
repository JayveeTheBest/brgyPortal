from django import forms
from .models import Announcement, Request, Event


class AnnouncementForm(forms.ModelForm):
    class Meta:
        model = Announcement
        fields = ['title', 'content']
        widgets = {
            'title': forms.TextInput(attrs={'class': 'form-control'}),
            'content': forms.Textarea(attrs={'class': 'form-control', 'rows': 5}),
        }


class RequestForm(forms.Form):
    first_name = forms.CharField(label="First Name", max_length=100,
                                 widget=forms.TextInput(attrs={'class': 'form-control'}))
    middle_name = forms.CharField(label="Middle Name", max_length=100, required=False,
                                  widget=forms.TextInput(attrs={'class': 'form-control'}))
    last_name = forms.CharField(label="Last Name", max_length=100,
                                widget=forms.TextInput(attrs={'class': 'form-control'}))

    req_type = forms.ChoiceField(label="Request Type", choices=Request.REQUEST_TYPES,
                                 widget=forms.Select(attrs={'class': 'form-select'}))
    purpose = forms.CharField(label="Purpose", widget=forms.Textarea(attrs={'class': 'form-control', 'rows': 2}))
    description = forms.CharField(label="Additional Details",
                                  widget=forms.Textarea(attrs={'class': 'form-control', 'rows': 2}))
    pickup_method = forms.ChoiceField(label="Pickup Method", choices=Request.PICKUP_CHOICES,
                                      widget=forms.Select(attrs={'class': 'form-select'}))
    contact_number = forms.CharField(label="Contact Number", max_length=20, required=False,
                                     widget=forms.TextInput(attrs={'class': 'form-control'}))


class EventForm(forms.ModelForm):
    event_date = forms.DateTimeField(
        widget=forms.DateTimeInput(attrs={'type': 'datetime-local'}),
        label='Event Date & Time'
    )

    class Meta:
        model = Event
        fields = ['title', 'description', 'event_date', 'location']
        widgets = {
            'title': forms.TextInput(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={'class': 'form-control', 'rows': 4}),
            'location': forms.TextInput(attrs={'class': 'form-control'}),
        }

