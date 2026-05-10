import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { updateTaskStatus, logout } from '@/app/today/actions'
import DeleteButton from '@/app/today/_components/delete-button'
import BottomNav from '@/app/_components/bottom-nav'

export default async function DonePage() {
  const supabase = await createClient()

  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    redirect('/login')
  }

  const { data: tasks, error } = await supabase
    .from('tasks')
    .select('id, title, description, due_date, priority, completed_at')
    .eq('user_id', user.id)
    .eq('status', 'done')
    .order('completed_at', { ascending: false })

  if (error) {
    return <div>Error loading tasks: {error.message}</div>
  }

  return (
    <>
      <div style={{ padding: '20px', maxWidth: '600px', margin: '0 auto' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <h1>Done</h1>
          <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
            <a
              href="/tasks/new"
              style={{
                padding: '8px 16px',
                background: '#3b82f6',
                color: 'white',
                textDecoration: 'none',
                borderRadius: '4px',
              }}
            >
              + New Task
            </a>
            <form>
              <button formAction={logout}>Log out</button>
            </form>
          </div>
        </div>

        <p>{tasks?.length ?? 0} completed task(s)</p>

        {tasks && tasks.length > 0 ? (
          <ul style={{ listStyle: 'none', padding: 0 }}>
            {tasks.map((task) => (
              <li
                key={task.id}
                style={{
                  padding: '12px',
                  marginBottom: '8px',
                  border: '1px solid #ccc',
                  borderRadius: '4px',
                }}
              >
                <div style={{ fontWeight: 'bold' }}>{task.title}</div>
                {task.description && (
                  <div style={{ fontSize: '0.9em', color: '#666' }}>
                    {task.description}
                  </div>
                )}
                <div style={{ fontSize: '0.85em', marginTop: '4px' }}>
                  Priority: <code>{task.priority}</code>
                  {' · '}
                  Due: {task.due_date
                    ? new Date(task.due_date).toLocaleString('id-ID')
                    : 'No due date'}
                  {' · '}
                  Completed: {task.completed_at
                    ? new Date(task.completed_at).toLocaleString('id-ID')
                    : '—'}
                </div>

                <div style={{ marginTop: '8px', display: 'flex', gap: '4px' }}>
                  <form>
                    <input type="hidden" name="task_id" value={task.id} />
                    <input type="hidden" name="new_status" value="todo" />
                    <button formAction={updateTaskStatus}>Reopen</button>
                  </form>
                  <a
                    href={`/tasks/${task.id}/edit`}
                    style={{ padding: '4px 8px' }}
                  >
                    Edit
                  </a>
                  <DeleteButton taskId={task.id} />
                </div>
              </li>
            ))}
          </ul>
        ) : (
          <p>No completed tasks yet.</p>
        )}
      </div>
      <BottomNav />
    </>
  )
}
