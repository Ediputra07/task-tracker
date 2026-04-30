# Task Tracker — Personal Productivity App

A task tracking web app for managing daily tasks, deadlines, and reminders. Used for university assignments, daily targets, and personal task management. Built mobile-first with reminder capability.

## Status
🚧 In Development — Pre-coding phase.

## Live References
- Previous project (finance-tracker): https://finance-tracker-wine-gamma.vercel.app
- Finance-tracker repo: https://github.com/Ediputra07/finance-tracker

## Tech Stack
- **Frontend:** Next.js 14+ (App Router) + TypeScript
- **Styling:** Tailwind CSS
- **Backend:** Supabase (PostgreSQL + Auth + RLS)
- **Hosting:** Vercel (planned)

## Spec Decisions

### Task Display
- Main view: title + due date (compact)
- Description and category: accessible via hover/expand (avoid UI clutter)

### Status System
3 states: `todo` → `in_progress` → `done`

### Priority
- Priority levels: high / medium / low
- Default sort: by deadline

### Recurring Tasks
- **Not in MVP** — revisit if pain point appears after use

### Notifications
- **MVP:** In-app badge (overdue/today indicator on nav)
- **Phase 2:** Browser push notifications (PWA)
- **Skipped:** WhatsApp/SMS (too expensive for personal)
- **Future option:** Telegram bot (free alternative)

### Views (MVP)
1. **Today** — due today + overdue (highlighted)
2. **Upcoming** — next 7 days, grouped by day
3. **All** — full list, filterable
4. **Done** — completed tasks

### Skipped from MVP
- Calendar view
- Kanban board
- Subtasks
- Recurring tasks

### Multi-device Sync
- Via Supabase (same as finance-tracker)

## Developer Context

### Background
- Information Systems student, 4th semester
- Previous project: finance-tracker (React + Vite + Supabase) — successfully deployed
- Familiar with: React, Tailwind, Supabase, Git workflow
- **New to:** Next.js App Router, TypeScript

### Learning Goals
- TypeScript proficiency
- Next.js paradigms (Server Components, Client Components, App Router, Server Actions)
- PWA setup for push notifications

### Workflow Preferences
- "Pelan tapi runtut" — step by step with clear explanations
- Intellectual sparring partner mode — push back on weak assumptions
- Conventional Commits for git messages
- Test production build before deploy
- Understand "why" before "how"

## Tools Used
- **Claude.ai chat** — planning, architecture, concept discussion
- **Claude Code (VS Code)** — active coding, refactoring, file edits
- **Claude Design** — UI/UX exploration (planned, pre-coding phase)

## Patterns from Finance-Tracker (Reuse)
- Custom hooks for all data logic (`useTasks`, `useCategories`)
- Three-state rendering (loading → empty → data)
- Toast notifications (react-hot-toast) instead of `alert()`
- Custom ConfirmDialog instead of `window.confirm()`
- Adaptive navigation (bottom nav mobile + sidebar desktop)
- Conventional Commits

## New Patterns to Learn
- TypeScript types for all data models
- Next.js App Router routing
- Server Components vs Client Components distinction
- Server Actions

## Open Decisions (Pre-Coding)
1. Server Components vs Client Components strategy
2. State management: pure useState/useReducer or library (Zustand)?
3. Form library: react-hook-form or manual?
4. Date library: date-fns or native Intl?

## Outstanding TODO

### Pre-Coding
- [ ] Design UI in Claude Design (mobile-first)
- [ ] Database schema for tasks + categories
- [ ] Decide bottom nav pattern

### MVP Roadmap
- [ ] Supabase project setup (separate from finance-tracker)
- [ ] Auth flow with Next.js
- [ ] Task CRUD
- [ ] Category management
- [ ] Today / Upcoming / All views
- [ ] In-app notification badge
- [ ] Deploy to Vercel

### Post-MVP
- [ ] Recurring tasks
- [ ] Browser push notifications (PWA)
- [ ] Calendar view
- [ ] Search/filter
- [ ] Telegram bot integration

## Notes for AI Assistant
- User is learning Next.js + TypeScript for the first time
- Don't assume same comfort level as finance-tracker
- Explain TypeScript concepts inline when introducing new patterns
- Push back on weak assumptions
- Default to teaching mode — "why" before "how"
- Always ask clarifying questions before assuming scope