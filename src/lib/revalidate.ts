import { revalidatePath } from 'next/cache'

export function revalidateAllTaskViews() {
  revalidatePath('/today')
  revalidatePath('/upcoming')
  revalidatePath('/all')
  revalidatePath('/done')
}

export function revalidateActiveTaskViews() {
  revalidatePath('/today')
  revalidatePath('/upcoming')
  revalidatePath('/all')
}
