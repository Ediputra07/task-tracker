import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { updateTaskStatus, logout } from './actions'
import DeleteButton from './_components/delete-button'
import BottomNav from '@/app/_components/bottom-nav'

export default async function TodayPage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string }>
}) {
  const supabase = await createClient()

  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    redirect('/login')
  }

  const params = await searchParams
  const errorParam = params.error

  const errorMessages: Record<string, string> = {
    update_failed: '⚠️ Failed to update task. Try again.',
    delete_failed: '⚠️ Failed to delete task. Try again.',
    not_found: '⚠️ Task not found or already deleted.',
  }
  const errorMessage = errorParam ? errorMessages[errorParam] : null

  // Fetch tasks: due today OR overdue (and not done)
  const today = new Date()
  today.setHours(23, 59, 59, 999)  // end of today
  
  const { data: tasks, error } = await supabase
    .from('tasks')
    // TODO: Re-add `categories (name, color)` join saat kategori UI dibikin
    .select(`
      id,
      title,
      description,
      due_date,
      status,
      priority
    `)
    .eq('user_id', user.id)
    .neq('status', 'done')
    .lte('due_date', today.toISOString())
    .order('due_date', { ascending: true })

  if (error) {
    return <div>Error loading tasks: {error.message}</div>
  }

  return (
    <>
      <div style={{ padding: '20px', maxWidth: '600px', margin: '0 auto' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h1>Today</h1>
        <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
          <a
            href="/tasks/new"
            style={{
              padding: '8px 16px',
              background: '#3b82f6',
              color: 'white',
              textDecoration: 'none',
              borderRadius: '4px'
            }}
          >
            + New Task
          </a>
          <form>
            <button formAction={logout}>Log out</button>
          </form>
        </div>
      </div>

      {errorMessage && (
        <div style={{ color: 'red', marginBottom: '12px' }}>
          {errorMessage}
        </div>
      )}

      <p>{tasks?.length ?? 0} task(s) due today or overdue</p>
      
      {tasks && tasks.length > 0 ? (
        <ul style={{ listStyle: 'none', padding: 0 }}>
          {tasks.map((task) => (
            <li 
              key={task.id} 
              style={{ 
                padding: '12px', 
                marginBottom: '8px', 
                border: '1px solid #ccc',
                borderRadius: '4px'
              }}
            >
              <div style={{ fontWeight: 'bold' }}>{task.title}</div>
              {task.description && (
                <div style={{ fontSize: '0.9em', color: '#666' }}>
                  {task.description}
                </div>
              )}
              <div style={{ fontSize: '0.85em', marginTop: '4px' }}>
                Status: <code>{task.status}</code>
                {' · '}
                Priority: <code>{task.priority}</code>
                {' · '}
                Due: {task.due_date 
                  ? new Date(task.due_date).toLocaleString('id-ID') 
                  : 'No due date'}
              </div>
              
              {/* ===== Action buttons (kontekstual berdasarkan status) ===== */}
              <div style={{ marginTop: '8px', display: 'flex', gap: '4px' }}>
                {task.status === 'todo' && (
                  <>
                    <form>
                      <input type="hidden" name="task_id" value={task.id} />
                      <input type="hidden" name="new_status" value="in_progress" />
                      <button formAction={updateTaskStatus}>Start</button>
                    </form>
                    <form>
                      <input type="hidden" name="task_id" value={task.id} />
                      <input type="hidden" name="new_status" value="done" />
                      <button formAction={updateTaskStatus}>Done</button>
                    </form>
                  </>
                )}
                
                {task.status === 'in_progress' && (
                  <form>
                    <input type="hidden" name="task_id" value={task.id} />
                    <input type="hidden" name="new_status" value="done" />
                    <button formAction={updateTaskStatus}>Done</button>
                  </form>
                )}  
                
                {task.status === 'done' && (
                  <form>
                    <input type="hidden" name="task_id" value={task.id} />
                    <input type="hidden" name="new_status" value="todo" />
                    <button formAction={updateTaskStatus}>Reopen</button>
                  </form>
                )}

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
        <p>No tasks due today. 🎉</p>
      )}
      </div>
      <BottomNav />
    </>
  )
}