from django.urls import path
from . import views

urlpatterns = [
    path('', views.login_view, name='login'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('dashboard/', views.dashboard_view, name='dashboard'),
    path('announcements/', views.announcement_list, name='announcement_list'),
    path('announcements/add/', views.announcement_create, name='announcement_add'),
    path('announcements/edit/<int:pk>/', views.announcement_update, name='announcement_edit'),
    path('announcements/delete/<int:pk>/', views.announcement_delete, name='announcement_delete'),
    path('requests/create/', views.request_create, name='request_create'),
    path('requests/', views.request_list, name='request_list'),
    path('requests/status/<int:pk>/<str:new_status>/', views.request_update_status, name='request_update_status'),
    path('requests/decline/<int:pk>/', views.request_decline_with_comment, name='request_decline_with_comment'),
    path('requests/history/', views.request_history, name='request_history'),
    path('requests/history/pdf/', views.export_request_history_pdf, name='export_request_history_pdf'),
    path('events/', views.event_list, name='event_list'),
    path('events/add/', views.event_create, name='event_add'),
    path('events/edit/<int:pk>/', views.event_update, name='event_edit'),
    path('events/delete/<int:pk>/', views.event_delete, name='event_delete'),
    path('api/events/', views.calendar_events_api, name='calendar_events_api'),
]