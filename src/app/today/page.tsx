import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

export default async function TodayPage() {
  const supabase = await createClient()
  
  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    redirect('/login')
  }
  
  // Fetch tasks: due today OR overdue (and not done)
  const today = new Date()
  today.setHours(23, 59, 59, 999)  // end of today
  
  const { data: tasks, error } = await supabase
    .from('tasks')
    .select(`
      id,
      title,
      description,
      due_date,
      status,
      priority,
      categories (
        name,
        color
      )
    `)
    .eq('user_id', user.id)
    .neq('status', 'done')
    .lte('due_date', today.toISOString())
    .order('due_date', { ascending: true })

  if (error) {
    return <div>Error loading tasks: {error.message}</div>
  }

  return (
    <div style={{ padding: '20px', maxWidth: '600px', margin: '0 auto' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h1>Today</h1>
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
      </div>

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
            </li>
          ))}
        </ul>
      ) : (
        <p>No tasks due today. 🎉</p>
      )}
    </div>
  )
}