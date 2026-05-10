import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { updateTaskStatus, logout } from '@/app/today/actions'
import DeleteButton from '@/app/today/_components/delete-button'

function pad(n: number): string {
  return String(n).padStart(2, '0')
}

function dayKey(d: Date): string {
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`
}

function formatDayLabel(key: string, tomorrowKey: string): string {
  if (key === tomorrowKey) return 'Tomorrow'
  const [y, m, d] = key.split('-').map(Number)
  const date = new Date(y, m - 1, d)
  return new Intl.DateTimeFormat('id-ID', {
    weekday: 'short',
    day: 'numeric',
    month: 'short',
  }).format(date)
}

export default async function UpcomingPage() {
  const supabase = await createClient()

  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    redirect('/login')
  }

  // Range: start of tomorrow → end of (today+7), local time. 7 days, exclusive of today.
  const now = new Date()
  const startOfTomorrow = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1)
  const endOfRange = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 7, 23, 59, 59, 999)

  const { data: tasks, error } = await supabase
    .from('tasks')
    .select('id, title, description, due_date, status, priority')
    .eq('user_id', user.id)
    .neq('status', 'done')
    .gte('due_date', startOfTomorrow.toISOString())
    .lte('due_date', endOfRange.toISOString())
    .order('due_date', { ascending: true })

  if (error) {
    return <div>Error loading tasks: {error.message}</div>
  }

  const tomorrowKey = dayKey(startOfTomorrow)
  const tasksByDay = new Map<string, typeof tasks>()
  for (const task of tasks ?? []) {
    if (!task.due_date) continue
    const key = dayKey(new Date(task.due_date))
    if (!tasksByDay.has(key)) tasksByDay.set(key, [])
    tasksByDay.get(key)!.push(task)
  }

  return (
    <div style={{ padding: '20px', maxWidth: '600px', margin: '0 auto' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h1>Upcoming</h1>
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

      {tasksByDay.size === 0 ? (
        <p>No upcoming tasks in the next 7 days. 🎉</p>
      ) : (
        Array.from(tasksByDay.entries()).map(([key, dayTasks]) => (
          <div key={key} style={{ marginTop: '16px' }}>
            <h2 style={{ fontSize: '1.1em', borderBottom: '1px solid #ddd', paddingBottom: '4px' }}>
              {formatDayLabel(key, tomorrowKey)}
            </h2>
            <ul style={{ listStyle: 'none', padding: 0 }}>
              {dayTasks.map((task) => (
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
                    Status: <code>{task.status}</code>
                    {' · '}
                    Priority: <code>{task.priority}</code>
                    {' · '}
                    Due: {task.due_date
                      ? new Date(task.due_date).toLocaleString('id-ID')
                      : 'No due date'}
                  </div>

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
          </div>
        ))
      )}
    </div>
  )
}
