-- ============================================================
-- Task Tracker — Database Schema
-- Run di Supabase SQL Editor (Project baru, terpisah dari finance-tracker)
-- ============================================================

-- ============================================================
-- 1. CATEGORIES TABLE
-- ============================================================
create table categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  color text not null default '#6366f1',
  created_at timestamptz default now() not null,
  
  -- User gak boleh punya 2 kategori dengan nama sama
  unique (user_id, name)
);

-- ============================================================
-- 2. TASKS TABLE
-- ============================================================
create table tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  
  -- Core fields
  title text not null,
  description text,
  
  -- Scheduling
  due_date timestamptz,
  
  -- Status & priority
  status text not null default 'todo' 
    check (status in ('todo', 'in_progress', 'done')),
  priority text not null default 'medium' 
    check (priority in ('low', 'medium', 'high')),
  
  -- Relation
  category_id uuid references categories(id) on delete set null,
  
  -- Tracking
  completed_at timestamptz,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null
);

-- ============================================================
-- 3. INDEXES (untuk query yang sering dipakai)
-- ============================================================

-- Today view & Upcoming view: filter by user_id + due_date
create index idx_tasks_user_due on tasks(user_id, due_date);

-- All view & filter by status (Done view, dll)
create index idx_tasks_user_status on tasks(user_id, status);

-- Filter by category
create index idx_tasks_user_category on tasks(user_id, category_id);

-- ============================================================
-- 4. AUTO-UPDATE updated_at TRIGGER
-- ============================================================
create or replace function update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger tasks_updated_at
  before update on tasks
  for each row
  execute function update_updated_at_column();

-- ============================================================
-- 5. ROW LEVEL SECURITY (RLS)
-- ============================================================

-- Enable RLS
alter table categories enable row level security;
alter table tasks enable row level security;

-- Categories: user cuma bisa akses kategori miliknya
create policy "Users manage own categories"
  on categories
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Tasks: user cuma bisa akses task miliknya
create policy "Users manage own tasks"
  on tasks
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- ============================================================
-- DONE
-- ============================================================