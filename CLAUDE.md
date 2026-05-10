# Task Tracker — Personal Productivity App

A task tracking web app for managing daily tasks, deadlines, and reminders. Used for university assignments, daily targets, and personal task management. Built mobile-first with reminder capability.

## Status
🚧 **MVP Deployed — Dogfooding Phase**

Core CRUD shipped to production. Pakai sehari-hari, catat pain points, lalu polish + extend.

## Live References
- **Production:** https://task-tracker-zeta-navy-12.vercel.app
- **Repo:** https://github.com/Ediputra07/task-tracker
- Previous project (finance-tracker): https://finance-tracker-wine-gamma.vercel.app
- Finance-tracker repo: https://github.com/Ediputra07/finance-tracker

## Tech Stack
- **Frontend:** Next.js 16 (App Router) + TypeScript + React 19
- **Styling:** Tailwind CSS v4 (currently using inline styles — Tailwind setup pending polish phase)
- **Backend:** Supabase (PostgreSQL + Auth + RLS)
- **Hosting:** Vercel
- **Region:** Singapore (Supabase) — low latency from Indonesia

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
- **MVP:** In-app badge (overdue/today indicator on nav) — not yet built
- **Phase 2:** Browser push notifications (PWA)
- **Skipped:** WhatsApp/SMS (too expensive for personal)
- **Future option:** Telegram bot (free alternative)

### Views (MVP)
1. **Today** ✅ — due today + overdue (status != done), filter strict by due_date
2. **Upcoming** ⏳ — next 7 days, grouped by day (not yet built)
3. **All** ⏳ — full list, filterable (not yet built)
4. **Done** ⏳ — completed tasks (not yet built)

### Skipped from MVP
- Calendar view
- Kanban board
- Subtasks
- Recurring tasks

### Multi-device Sync
- Via Supabase (same as finance-tracker)

## What's Already Built

### Schema
- `categories`: id, user_id, name, color (unique per user)
- `tasks`: id, user_id, title, description, due_date, status, priority, category_id, completed_at, created_at, updated_at
- RLS policies: user only access own data
- Indexes: (user_id, due_date), (user_id, status), (user_id, category_id)
- File: `schema.sql` at repo root

### Auth Flow
- `/login` — login + signup form (Server Component, plain HTML form + Server Actions). Granular error via `?error=` query param: `invalid_credentials`, `email_taken`, `weak_password`, `signup_failed`.
- `/auth/callback` — not yet built (email confirmation disabled in production for now)
- Server Actions: `login()`, `signup()`, `logout()` in respective `actions.ts` files
- Email confirmation: **disabled** in Supabase. MUST re-enable + build callback handler before public release.
- **Known limitation:** `email_taken` error detection matches Supabase `error.message` substring (`'already registered'` / `'already exists'`). Fragile if Supabase changes wording. Acceptable for MVP; revisit if signup error UX matters more.

### Protected Routes
- `src/proxy.ts` — Next.js 16 convention (replaces deprecated middleware)
- `src/lib/supabase/proxy.ts` — helper with `updateSession()` function
- Logic: redirect non-auth users to /login except for /login, /signup, /auth, /error

### Pages Implemented
- `/today` — list of tasks due today + overdue, with action buttons per task
- `/tasks/new` — form to create new task

### Task CRUD
- **Create:** form at `/tasks/new` with title (required), description, due_date (datetime-local), priority dropdown, category dropdown
- **Read:** `/today` view fetches tasks via Supabase, filtered & ordered
- **Update Status:** contextual buttons per task — Start/Done (todo), Done (in_progress), Reopen (done). Plain form + Server Action.
- **Delete:** Client Component (`_components/delete-button.tsx`) with native `confirm()` + `useTransition`. Hard delete.

### Supabase Clients
- `src/lib/supabase/client.ts` — for Client Components (browser context)
- `src/lib/supabase/server.ts` — for Server Components (server-side context)
- `src/lib/supabase/proxy.ts` — for proxy/middleware (request/response object handling)
- Pattern: callback-based cookies access for cross-environment compatibility

### Seed Data
- File: `seed.sql` at repo root
- 10 sample tasks with mix of statuses, priorities, categories
- Run manually in Supabase SQL Editor with user UUID replaced

## Developer Context

### Background
- Information Systems student, 4th semester
- Previous project: finance-tracker (React + Vite + Supabase) — successfully deployed
- Familiar with: React, Tailwind v3, Supabase, Git workflow
- **First time building with:** Next.js App Router, TypeScript, Tailwind v4, React 19

### Learning Goals
- TypeScript proficiency (currently: solid foundation in type assertion, optional chaining, narrowing, typed props)
- Next.js paradigms (currently: solid in Server/Client Components, Server Actions, proxy)
- Tailwind v4 paradigm (CSS-based config) — not yet practiced
- PWA setup for push notifications — Phase 2

### Workflow Preferences
- **"Pelan tapi runtut"** — step by step with clear explanations
- **Intellectual sparring partner mode** — push back on weak assumptions, prioritize truth over agreement
- **Conventional Commits** for git messages (feat/fix/chore/docs)
- **Logical commit chunking** — one commit = one self-contained logical change
- **Test production build before deploy** (`npm run build` + `npm run start`)
- **Understand "why" before "how"** — avoid cargo cult coding

## Tools Used
- **Claude.ai chat** — initial scaffolding, concept teaching, decision sparring (this is the chat tool)
- **Claude Code (VS Code)** — active coding, refactoring, file edits (next phase)
- **AGENTS.md** — instructs AI agents to read local Next.js docs in `node_modules/next/dist/docs/` (because training data may be outdated for Next.js 16)

## Patterns from Finance-Tracker (Reuse Targets)
- Custom hooks for all data logic (`useTasks`, `useCategories`) — not yet implemented in task-tracker
- Three-state rendering (loading → empty → data) — partial; current `/today` shows empty state
- Toast notifications (react-hot-toast) instead of `alert()` — pending polish phase
- Custom ConfirmDialog instead of `window.confirm()` — pending polish phase
- Adaptive navigation (bottom nav mobile + sidebar desktop) — pending polish phase

## Patterns Already Established in Task-Tracker
- Shared TypeScript types in `src/lib/types.ts` (manual, schema-aligned)
- Server Action pattern: `formData: FormData` parameter, parse with `formData.get()`, validate, mutate, revalidatePath, redirect
- Client Component for interactive UI (e.g. DeleteButton with `useTransition`)
- Defense in depth: auth check + ownership filter (`.eq('user_id', user.id)`) on every Server Action
- Error handling via redirect with query param (e.g. `/tasks/new?error=title_required`)
- Convention: page-level `actions.ts` next to `page.tsx`, private components in `_components/`

## Open Decisions (Resolved)
1. ✅ Server Components vs Client Components — decide per-component as we build
2. ✅ State management — useState only; no library yet
3. ✅ Form library — manual `formData` handling; no react-hook-form yet
4. ✅ Date library — native Intl + JavaScript Date; no date-fns yet

## Outstanding TODO

### Immediate (post-dogfood)
- [ ] Update CLAUDE.md "Dogfood Notes" with pain points discovered
- [ ] Prioritize next features based on real usage feedback

### MVP Continuation
- [ ] /upcoming view (next 7 days, grouped by day)
- [ ] /all view (full list, includes tasks with no due_date)
- [ ] /done view (completed tasks, with Reopen button)
- [ ] Category management UI (add/edit/delete categories)
- [ ] In-app notification badge (overdue count on nav)

### Polish Phase
- [ ] Tailwind v4 setup (replace inline styles)
- [ ] Bottom nav (mobile) + sidebar (desktop) — adaptive navigation
- [ ] react-hot-toast for success/error notifications
- [ ] Custom ConfirmDialog (replace native `confirm()`)
- [ ] Loading states (Suspense / skeleton screens)
- [ ] Three-state rendering pattern (loading → empty → data)
- [ ] Review `<html lang="...">` di `layout.tsx` — saat ini "en", konten campur ID/EN. Decide saat polish.
- [ ] Language consistency audit (ID vs EN) — `confirm()` dialogs pakai ID, error banner pakai EN. Decide and sweep.

### Pre-Public Release
- [ ] Build `/auth/confirm` route handler for email confirmation
- [ ] Re-enable email confirmation in Supabase
- [ ] Update Supabase Auth → URL Configuration (already done)
- [ ] Custom domain (optional)

### Post-MVP
- [ ] Recurring tasks
- [ ] Browser push notifications (PWA)
- [ ] Calendar view
- [ ] Search/filter
- [ ] Telegram bot integration

## Dogfood Notes

> Diisi selama pakai app sehari-hari. Catat pain point + missing feature di sini supaya prioritas Claude Code session berikutnya jelas.

### Pain Points
- [TBD setelah pakai 1-3 hari]

### Missing Features (yang kerasa pas dipake)
- [TBD]

### UX Issues
- [TBD]

### Bug yang Ditemukan
- [TBD]

## Decision Log

| Date | Decision | Reasoning |
|------|----------|-----------|
| 2026-04-30 | Next.js 16 + React 19 + Tailwind v4 | Bleeding edge accepted; AGENTS.md guides AI to read local docs |
| 2026-04-30 | Single category (not multi) | YAGNI; migrate to many-to-many if pain emerges after use |
| 2026-04-30 | Hard delete + confirm dialog | Simpler MVP; soft delete deferred |
| 2026-04-30 | Skip Claude Design upfront | Sketch as we build; iteration faster than upfront mockups |
| 2026-04-30 | Defer state mgmt / form / date library decisions | YAGNI until pain emerges |
| 2026-05-04 | Disable email confirmation di dev | Faster dev experience; MUST RE-ENABLE before public release |
| 2026-05-04 | Today view filter strict by due_date | Task tanpa due_date akan muncul di /all view (next step). Konsisten dengan spec view-views. |
| 2026-05-04 | Today view filter strict (gak include done) | Sesuai spec — task done akan muncul di /done view nanti |
| 2026-05-04 | Update status pakai plain form (Pendekatan 1) | Konsisten sama Server Action pattern; refactor ke Client Component nanti kalau perlu UX smoother |
| 2026-05-04 | Status UX: hybrid kontekstual (Start/Done/Reopen) | UX intuitive, button label jelas berdasarkan status saat ini |
| 2026-05-04 | Delete: Client Component + native confirm() | First Client Component in app; useTransition for loading state. Custom modal nanti pas polish. |
| 2026-05-04 | Rename middleware → proxy | Next.js 16 deprecated middleware convention. proxy is the new convention. Function name + file name + import paths updated. |
| 2026-05-05 | Deployed to Vercel for mobile-first dogfooding | Production URL set as Supabase Site URL; localhost + production both whitelisted |
| 2026-05-05 | Keep email confirmation disabled until polish phase | Personal app, low risk of spam signup. Re-enable when /auth/confirm handler built. |
| 2026-05-06 | Granular login errors via `?error=` query param | Replaces generic `/error` redirect. 4 codes: `invalid_credentials`, `email_taken`, `weak_password`, `signup_failed`. `email_taken` matches Supabase `error.message` substring (fragile, acceptable for MVP). `/error` route + proxy whitelist removed. |

## Notes for AI Assistant

### Context
- User is learning Next.js 16 + TypeScript + Tailwind v4 for the first time
- Has solid foundation in: React, Supabase, Git, Conventional Commits
- Successfully shipped finance-tracker (React + Vite) before this project
- Currently in "dogfooding" phase — using app daily to find pain points

### Behavior Guidelines
- **Don't assume same comfort level as finance-tracker** — Next.js paradigm is new
- **Explain TypeScript concepts inline** when introducing new patterns
- **Push back on weak assumptions** — user explicitly requests sparring partner mode
- **Default to teaching mode** — "why" before "how"
- **Always ask clarifying questions** before assuming scope
- **Verify before action** — check `git status`, `npm run build`, etc.
- **Maintain commit hygiene** — Conventional Commits, logical chunking
- **Update Decision Log** for any non-trivial decision made during the session

### Anti-patterns to Avoid
- Cargo cult coding — generating code user doesn't understand
- Scope creep — doing more than what was asked in one prompt
- Skipping verification — assuming things work without testing
- Vague status updates — be specific about what's done vs not