'use client'

import { useTransition } from 'react'
import { deleteTask } from '../actions'

export default function DeleteButton({ taskId }: { taskId: string }) {
  const [isPending, startTransition] = useTransition()

  const handleClick = () => {
    const confirmed = confirm('Yakin mau hapus task ini? Aksi ini tidak bisa dibatalkan.')
    if (!confirmed) return

    startTransition(async () => {
      await deleteTask(taskId)
    })
  }

  return (
    <button 
      type="button"
      onClick={handleClick}
      disabled={isPending}
      style={{ 
        background: '#ef4444', 
        color: 'white', 
        border: 'none',
        padding: '4px 8px',
        borderRadius: '4px',
        cursor: isPending ? 'not-allowed' : 'pointer',
      }}
    >
      {isPending ? 'Deleting...' : 'Delete'}
    </button>
  )
}