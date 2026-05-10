// Manual types untuk data models di Supabase.
// Sesuai schema.sql. Update kalau schema berubah.
//
// Kalau migrasi ke generated types nanti:
//   npx supabase gen types typescript --project-id <id> > src/lib/database.types.ts

export type TaskStatus = 'todo' | 'in_progress' | 'done'
export type TaskPriority = 'low' | 'medium' | 'high'

export type Category = {
  id: string
  user_id: string
  name: string
  color: string
}

export type Task = {
  id: string
  user_id: string
  title: string
  description: string | null
  due_date: string | null      // ISO timestamp string dari Supabase
  status: TaskStatus
  priority: TaskPriority
  category_id: string | null
  completed_at: string | null  // ISO timestamp string
  created_at: string
  updated_at: string
}
