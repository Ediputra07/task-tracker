'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

export async function updateTask(formData: FormData) {
  const supabase = await createClient()

  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    redirect('/login')
  }

  const id = formData.get('id') as string
  const title = formData.get('title') as string
  const description = formData.get('description') as string
  const dueDate = formData.get('due_date') as string
  const priority = formData.get('priority') as string
  const categoryId = formData.get('category_id') as string

  if (!title || title.trim() === '') {
    redirect(`/tasks/${id}/edit?error=title_required`)
  }

  const { error } = await supabase
    .from('tasks')
    .update({
      title: title.trim(),
      description: description?.trim() || null,
      due_date: dueDate ? new Date(dueDate).toISOString() : null,
      priority: priority || 'medium',
      category_id: categoryId || null,
    })
    .eq('id', id)
    .eq('user_id', user.id)

  if (error) {
    console.log('Update task error:', error)
    redirect(`/tasks/${id}/edit?error=update_failed`)
  }

  revalidatePath('/today')
  redirect('/today')
}
