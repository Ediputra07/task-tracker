-- ============================================================
-- Task Tracker — Seed Data (FIXED)
-- 
-- BEFORE RUNNING:
-- 1. Replace 'YOUR_USER_ID_HERE' below with actual user UUID
--    (ada 2 tempat: di variable + di query verify di akhir)
-- 2. Get UUID from Supabase Dashboard → Authentication → Users
-- ============================================================

do $$
declare
  target_user_id uuid := 'YOUR_USER_ID_HERE';
  cat_kuliah_id uuid;
  cat_pribadi_id uuid;
  cat_kerja_id uuid;
begin

-- ============================================================
-- CATEGORIES — insert dulu tanpa returning
-- ============================================================
insert into categories (user_id, name, color) values
  (target_user_id, 'Kuliah', '#3b82f6'),
  (target_user_id, 'Pribadi', '#10b981'),
  (target_user_id, 'Kerja', '#f59e0b');

-- Ambil category IDs setelah insert (ini yang harus 1 row per query)
select id into cat_kuliah_id from categories 
  where user_id = target_user_id and name = 'Kuliah';
select id into cat_pribadi_id from categories 
  where user_id = target_user_id and name = 'Pribadi';
select id into cat_kerja_id from categories 
  where user_id = target_user_id and name = 'Kerja';

-- ============================================================
-- TASKS — Mix of statuses, priorities, due dates
-- ============================================================
insert into tasks (user_id, title, description, due_date, status, priority, category_id) values
  -- OVERDUE (Today view: highlighted)
  (target_user_id, 'Submit tugas Basis Data', 'Bab Normalisasi 3NF', 
   now() - interval '2 days', 'todo', 'high', cat_kuliah_id),
  
  -- DUE TODAY (Today view)
  (target_user_id, 'Beli kebutuhan dapur', 'Beras, telur, sayur', 
   now() + interval '6 hours', 'todo', 'medium', cat_pribadi_id),
  (target_user_id, 'Review code teman kelompok', null, 
   now() + interval '3 hours', 'in_progress', 'high', cat_kuliah_id),
  
  -- DUE TOMORROW
  (target_user_id, 'Olahraga pagi', 'Lari 5km', 
   now() + interval '1 day', 'todo', 'low', cat_pribadi_id),
  
  -- DUE THIS WEEK (Upcoming view)
  (target_user_id, 'Presentasi proposal magang', 'Slide + demo project', 
   now() + interval '3 days', 'todo', 'high', cat_kerja_id),
  (target_user_id, 'Belajar TypeScript advanced', 'Generics, utility types', 
   now() + interval '5 days', 'todo', 'medium', cat_kuliah_id),
  
  -- DUE NEXT WEEK (Upcoming view)
  (target_user_id, 'Backup data laptop', null, 
   now() + interval '8 days', 'todo', 'low', cat_pribadi_id),
  
  -- NO DUE DATE (All view)
  (target_user_id, 'Eksplorasi library shadcn/ui', null, 
   null, 'todo', 'low', cat_kerja_id),
  
  -- COMPLETED (Done view)
  (target_user_id, 'Setup project task-tracker', 'Next.js 16 + Supabase', 
   now() - interval '3 days', 'done', 'high', cat_kerja_id),
  (target_user_id, 'Bikin schema database', null, 
   now() - interval '2 days', 'done', 'high', cat_kerja_id);

-- Update completed_at untuk task done
update tasks 
set completed_at = now() - interval '1 day'
where user_id = target_user_id and status = 'done';

end $$;

-- ============================================================
-- VERIFY (replace YOUR_USER_ID_HERE here too!)
-- ============================================================
select 
  t.title, 
  t.status, 
  t.priority,
  t.due_date,
  c.name as category
from tasks t
left join categories c on c.id = t.category_id
where t.user_id = 'YOUR_USER_ID_HERE'
order by t.due_date nulls last;