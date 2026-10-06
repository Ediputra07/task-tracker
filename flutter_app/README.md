# 📱 Task Tracker — Flutter App

Mobile client untuk Task Tracker, dibangun dengan Flutter dan Supabase.

## ✨ Fitur

- 🔐 Login & Register (Supabase Auth)
- ✅ Create, Edit, Delete tugas
- 🔄 Status: Todo → In Progress → Done
- 🏷️ Prioritas: Low / Medium / High
- 📁 Kategori dengan color indicator
- 📅 Due date picker + deteksi overdue
- 🔍 Filter: Today, Upcoming, All, Done
- 📱 Responsive: Mobile & Tablet/Desktop layout

## 📲 Download

> **[⬇️ Download APK Terbaru](https://github.com/Ediputra07/task-tracker/releases/)**

## 🚀 Menjalankan Locally

```bash
# Install dependencies
flutter pub get

# Jalankan (debug)
flutter run \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGci...

# Build release APK
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGci...
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`

## 🗂️ Struktur

```
lib/
├── core/
│   ├── constants/    # Supabase config
│   ├── theme/        # App theme (light & dark)
│   └── utils/        # Date formatter
├── data/
│   ├── models/       # TaskModel, CategoryModel
│   └── repositories/ # AuthRepository, TaskRepository
├── providers/        # AuthNotifier, TaskNotifier
└── presentation/
    ├── screens/      # Auth, Home, TaskForm
    └── widgets/      # TaskCard, DeleteDialog
```

## 🔧 Tech Stack

- **Flutter** + Dart
- **Supabase** (Auth + PostgreSQL)
- **Provider** (state management)
- **Google Fonts** (Inter)
- **intl** (date formatting, locale id_ID)
