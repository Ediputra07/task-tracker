'use server'

import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { revalidateActiveTaskViews } from '@/lib/revalidate'

export async function createTask(formData: FormData) {
  const supabase = await createClient()

  // Auth check
  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    redirect('/login')
  }

  // Parse form data
  const title = formData.get('title') as string
  const description = formData.get('description') as string
  const dueDate = formData.get('due_date') as string
  const priority = formData.get('priority') as string
  const categoryId = formData.get('category_id') as string

  // Validate required field
  if (!title || title.trim() === '') {
    redirect('/tasks/new?error=title_required')
  }

  // Insert task
  const { error } = await supabase.from('tasks').insert({
    user_id: user.id,
    title: title.trim(),
    description: description?.trim() || null,
    due_date: dueDate ? new Date(dueDate).toISOString() : null,
    priority: priority || 'medium',
    category_id: categoryId || null,
    status: 'todo',
  })

  if (error) {
    console.log('Create task error:', error)
    redirect('/tasks/new?error=insert_failed')
  }

  revalidateActiveTaskViews()
  redirect('/today')
}