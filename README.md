# 📋 Task Tracker

Aplikasi manajemen tugas fullstack dengan **Next.js web app** dan **Flutter mobile app**, menggunakan Supabase sebagai backend.

## 🗂️ Struktur Proyek

```
task-tracker/
├── src/                    # Next.js Web App
│   ├── app/                # App Router pages
│   └── components/         # React components
├── flutter_app/            # Flutter Mobile App
│   └── lib/
│       ├── core/           # Theme, utils, constants
│       ├── data/           # Models & repositories
│       ├── providers/      # State management (Provider)
│       └── presentation/   # Screens & widgets
├── schema.sql              # Database schema
└── seed.sql                # Sample data
```

## 📱 Download APK

> **[⬇️ Download app-release.apk](https://github.com/Ediputra07/task-tracker/releases/latest)**

## ✨ Fitur

- 🔐 **Autentikasi** — Login & Register dengan Supabase Auth
- ✅ **Manajemen Tugas** — Create, Read, Update, Delete
- 🔄 **Status Flow** — Todo → In Progress → Done
- 🏷️ **Prioritas** — Low / Medium / High
- 📁 **Kategori** — Kelompokkan tugas berdasarkan kategori
- 📅 **Due Date** — Batas waktu dengan deteksi overdue
- 🔍 **Filter View** — Today, Upcoming (7 hari), All, Done
- 📱 **Responsive** — Tampilan adaptif mobile & tablet/desktop

## 🚀 Tech Stack

| Layer | Teknologi |
|-------|-----------|
| Web Frontend | Next.js 15 (App Router) |
| Mobile | Flutter (Dart) |
| Backend & DB | Supabase (PostgreSQL + Auth) |
| State Management | Provider |
| Fonts | Google Fonts (Inter) |

## ⚙️ Setup Web (Next.js)

```bash
# Install dependencies
npm install

# Buat file .env.local
cp .env.example .env.local
# Isi NEXT_PUBLIC_SUPABASE_URL dan NEXT_PUBLIC_SUPABASE_ANON_KEY

# Jalankan dev server
npm run dev
```

Buka [http://localhost:3000](http://localhost:3000)

## 📲 Setup Mobile (Flutter)

```bash
cd flutter_app

# Install dependencies
flutter pub get

# Jalankan di device/emulator
flutter run --dart-define=SUPABASE_URL=<url> --dart-define=SUPABASE_ANON_KEY=<key>

# Build release APK
flutter build apk --release \
  --dart-define=SUPABASE_URL=<url> \
  --dart-define=SUPABASE_ANON_KEY=<key>
```

## 🗄️ Database Setup

Jalankan SQL berikut di **Supabase SQL Editor**:

```bash
# 1. Buat schema
# Jalankan isi file schema.sql

# 2. (Opsional) Insert sample data
# Jalankan isi file seed.sql
```

## 🔒 Environment Variables

```env
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGci...
```
