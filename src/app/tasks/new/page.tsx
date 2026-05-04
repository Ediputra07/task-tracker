import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { createTask } from './actions'

export default async function NewTaskPage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string }>
}) {
  const supabase = await createClient()
  
  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    redirect('/login')
  }

  // Fetch categories for dropdown
  const { data: categories } = await supabase
    .from('categories')
    .select('id, name')
    .eq('user_id', user.id)
    .order('name')

  // Read error from query params
  const params = await searchParams
  const error = params.error

  return (
    <div style={{ padding: '20px', maxWidth: '500px', margin: '0 auto' }}>
      <h1>New Task</h1>
      
      {error === 'title_required' && (
        <div style={{ color: 'red', marginBottom: '12px' }}>
          ⚠️ Title is required
        </div>
      )}
      
      {error === 'insert_failed' && (
        <div style={{ color: 'red', marginBottom: '12px' }}>
          ⚠️ Failed to create task. Try again.
        </div>
      )}

      <form action={createTask}>
        <div style={{ marginBottom: '12px' }}>
          <label htmlFor="title">Title *</label>
          <input
            id="title"
            name="title"
            type="text"
            required
            style={{ display: 'block', width: '100%', padding: '8px' }}
          />
        </div>

        <div style={{ marginBottom: '12px' }}>
          <label htmlFor="description">Description</label>
          <textarea
            id="description"
            name="description"
            rows={3}
            style={{ display: 'block', width: '100%', padding: '8px' }}
          />
        </div>

        <div style={{ marginBottom: '12px' }}>
          <label htmlFor="due_date">Due Date</label>
          <input
            id="due_date"
            name="due_date"
            type="datetime-local"
            style={{ display: 'block', width: '100%', padding: '8px' }}
          />
        </div>

        <div style={{ marginBottom: '12px' }}>
          <label htmlFor="priority">Priority</label>
          <select
            id="priority"
            name="priority"
            defaultValue="medium"
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
            defaultValue=""
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
          <button type="submit">Create Task</button>
          <a href="/today">Cancel</a>
        </div>
      </form>
    </div>
  )
}