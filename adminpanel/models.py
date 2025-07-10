from django.db import models


class User(models.Model):
    username = models.CharField(max_length=100, unique=True)
    password = models.CharField(max_length=100)
    firstname = models.CharField(max_length=100)
    middlename = models.CharField(max_length=100, blank=True, null=True)
    lastname = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.firstname} {self.lastname}"


class Announcement(models.Model):
    title = models.CharField(max_length=255)
    content = models.TextField()
    date_posted = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title


class Request(models.Model):
    REQUEST_TYPES = [
        ("Barangay Clearance", "Barangay Clearance"),
        ("Certificate of Residency", "Certificate of Residency"),
        ("Certificate of Indigency", "Certificate of Indigency"),
        ("Barangay ID Application", "Barangay ID Application"),
        ("Business Clearance / Endorsement", "Business Clearance / Endorsement"),
        ("Solo Parent Certificate", "Solo Parent Certificate"),
        ("No Derogatory Record", "No Derogatory Record"),
        ("Incident Report Copy", "Incident Report Copy"),
    ]

    STATUS_CHOICES = [
        ("Pending", "Pending"),
        ("Approved", "Approved"),
        ("Delivered", "Delivered"),
        ("Declined", "Declined"),
    ]

    PICKUP_CHOICES = [
        ("Walk-in", "Walk-in"),
        ("Online", "Online"),
    ]

    first_name = models.CharField(max_length=100, null=True)
    middle_name = models.CharField(max_length=100, blank=True)
    last_name = models.CharField(max_length=100, null=True)

    req_type = models.CharField(max_length=100, choices=REQUEST_TYPES)
    purpose = models.TextField(null=True)
    description = models.TextField()
    status = models.CharField(max_length=50, choices=STATUS_CHOICES, default='Pending')
    date_submitted = models.DateTimeField(auto_now_add=True)
    date_released = models.DateTimeField(null=True, blank=True)
    pickup_method = models.CharField(max_length=50, choices=PICKUP_CHOICES, null=True)
    contact_number = models.CharField(max_length=20, blank=True)

    def __str__(self):
        return f"{self.last_name}, {self.first_name} - {self.req_type} ({self.status})"


class Event(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField()
    event_date = models.DateTimeField()
    location = models.CharField(max_length=255)
    date_posted = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title
