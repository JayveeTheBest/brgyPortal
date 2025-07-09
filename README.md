<p align="center">
  <img src="https://img.icons8.com/ios-filled/100/000000/city.png" width="80" />
  <h1 align="center">Barangay Information Portal</h1>
  <p align="center">
    🏡 A Django + MySQL web system for barangay admins to manage requests, events, and announcements.
  </p>
</p>

<p align="center">
  <a href="https://www.djangoproject.com/"><img src="https://img.shields.io/badge/Built%20with-Django-092E20?logo=django&logoColor=white" /></a>
  <a href="https://www.mysql.com/"><img src="https://img.shields.io/badge/Database-MySQL-00758F?logo=mysql&logoColor=white" /></a>
  <img src="https://img.shields.io/github/languages/top/yourusername/brgyPortal" />
  <img src="https://img.shields.io/badge/Status-Active-brightgreen" />
  <img src="https://img.shields.io/badge/License-MIT-blue" />
</p>

---

## 🧭 Overview

The **Barangay Information Portal** is a streamlined admin dashboard for barangay staff in Bonbon, Cebu City. It centralizes key services like:

- 📢 Posting **announcements**
- 🧾 Handling **resident document requests**
- 🗓 Scheduling **events on a calendar**
- 📍 Displaying the barangay location on an interactive **map**

---

## 📁 Project Structure

brgyPortal/

├── adminpanel/ # Core Django app

├── templates/ # HTML templates

├── static/ # CSS, JS, images

├── media/ # Uploaded files

├── requirements.txt # Dependencies

├── manage.py # Django manager

└── README.md

---

## 🚀 Features

| Feature | Description |
|--------|-------------|
| 📋 Dashboard | Quick access to modules |
| 📢 Announcements | Post community updates |
| 🧾 Resident Requests | Manage and filter request history |
| 🗓 Event Calendar | Plan and visualize barangay events |
| 📄 Export to PDF | Download filtered request history |
| 🗺 Map Integration | Leaflet map pinned to Bonbon, Cebu City |

---

## 🛠️ Setup Guide

### 1. 🔁 Clone this repo
```bash
git clone https://github.com/JayveeTheBest/brgyPortal.git
cd brgyPortal

### 2. 🐍 Create and activate a virtual environment
python -m venv venv
venv\Scripts\activate   # Windows
# or
source venv/bin/activate  # Mac/Linux

### 3. 📦 Install requirements
pip install -r requirements.txt

### 4. 🗃️ Setup MySQL Database
CREATE DATABASE brgyportal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

### 5. 🧱 Apply Migrations
python manage.py makemigrations
python manage.py migrate

### 6. 👤 Create Admin User
python manage.py createsuperuser


### ▶️ Run the App
python manage.py runserver
