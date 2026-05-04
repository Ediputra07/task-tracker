'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

export async function updateTaskStatus(formData: FormData) {
  const supabase = await createClient()

  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    redirect('/login')
  }

  const taskId = formData.get('task_id') as string
  const newStatus = formData.get('new_status') as string

  // Validate status (defense)
  const validStatuses = ['todo', 'in_progress', 'done']
  if (!validStatuses.includes(newStatus)) {
    console.log('Invalid status:', newStatus)
    return
  }

  const { error } = await supabase
    .from('tasks')
    .update({
      status: newStatus,
      completed_at: newStatus === 'done' ? new Date().toISOString() : null,
    })
    .eq('id', taskId)
    .eq('user_id', user.id)

  if (error) {
    console.log('Update task error:', error)
    return
  }

  revalidatePath('/today')
}