import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { updateTask } from './actions'

function toLocalDatetimeInput(iso: string): string {
  const d = new Date(iso)
  const pad = (n: number) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`
}

export default async function EditTaskPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>
  searchParams: Promise<{ error?: string }>
}) {
  const supabase = await createClient()

  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    redirect('/login')
  }

  const { id } = await params

  const { data: task, error: fetchError } = await supabase
    .from('tasks')
    .select('id, title, description, due_date, priority, category_id')
    .eq('id', id)
    .eq('user_id', user.id)
    .single()

  if (fetchError || !task) {
    redirect('/today?error=not_found')
  }

  const { data: categories } = await supabase
    .from('categories')
    .select('id, name')
    .eq('user_id', user.id)
    .order('name')

  const queryParams = await searchParams
  const errorParam = queryParams.error

  return (
    <div style={{ padding: '20px', maxWidth: '500px', margin: '0 auto' }}>
      <h1>Edit Task</h1>

      {errorParam === 'title_required' && (
        <div style={{ color: 'red', marginBottom: '12px' }}>
          ⚠️ Title is required
        </div>
      )}

      {errorParam === 'update_failed' && (
        <div style={{ color: 'red', marginBottom: '12px' }}>
          ⚠️ Failed to update task. Try again.
        </div>
      )}

      <form action={updateTask}>
        <input type="hidden" name="id" value={task.id} />

        <div style={{ marginBottom: '12px' }}>
          <label htmlFor="title">Title *</label>
          <input
            id="title"
            name="title"
            type="text"
            required
            defaultValue={task.title}
            style={{ display: 'block', width: '100%', padding: '8px' }}
          />
        </div>

        <div style={{ marginBottom: '12px' }}>
          <label htmlFor="description">Description</label>
          <textarea
            id="description"
            name="description"
            rows={3}
            defaultValue={task.description ?? ''}
            style={{ display: 'block', width: '100%', padding: '8px' }}
          />
        </div>

        <div style={{ marginBottom: '12px' }}>
          <label htmlFor="due_date">Due Date</label>
          <input
            id="due_date"
            name="due_date"
            type="datetime-local"
            defaultValue={task.due_date ? toLocalDatetimeInput(task.due_date) : ''}
            style={{ display: 'block', width: '100%', padding: '8px' }}
          />
        </div>

        <div style={{ marginBottom: '12px' }}>
          <label htmlFor="priority">Priority</label>
          <select
            id="priority"
            name="priority"
            defaultValue={task.priority}
            style={{ display: 'block', width: '100%', padding: '8px' }}
          >
            <option value="low">Low</option>
            <option value="medium">Medium</option>
            <option value="high">High</option>
          </select>
        </div>

        <div style={{ marginBottom: '12px' }}>
          <label htmlFor="category_id">Category</label>
          <select
            id="category_id"
            name="category_id"
            defaultValue={task.category_id ?? ''}
            style={{ display: 'block', width: '100%', padding: '8px' }}
          >
            <option value="">-- No category --</option>
            {categories?.map((cat) => (
              <option key={cat.id} value={cat.id}>
                {cat.name}
              </option>
            ))}
          </select>
        </div>

        <div style={{ display: 'flex', gap: '8px' }}>
          <button type="submit">Save</button>
          <a href="/today">Cancel</a>
        </div>
      </form>
    </div>
  )
}
