'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import type { TaskStatus } from '@/lib/types'
import { revalidateAllTaskViews } from '@/lib/revalidate'

export async function updateTaskStatus(formData: FormData) {
  const supabase = await createClient()

  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    redirect('/login')
  }

  const taskId = formData.get('task_id') as string
  const newStatus = formData.get('new_status') as string

  // Validate status (defense)
  const validStatuses = ['todo', 'in_progress', 'done'] satisfies TaskStatus[]
  if (!validStatuses.includes(newStatus as TaskStatus)) {
    console.log('Invalid status:', newStatus)
    redirect('/today?error=update_failed')
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
    redirect('/today?error=update_failed')
  }

  revalidateAllTaskViews()
}

export async function deleteTask(taskId: string) {
  const supabase = await createClient()

  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    redirect('/login')
  }

  const { error } = await supabase
    .from('tasks')
    .delete()
    .eq('id', taskId)
    .eq('user_id', user.id)

  if (error) {
    console.log('Delete task error:', error)
    redirect('/today?error=delete_failed')
  }

  revalidateAllTaskViews()
}

export async function logout() {
  const supabase = await createClient()
  await supabase.auth.signOut()
  revalidatePath('/', 'layout')
  redirect('/login')
}