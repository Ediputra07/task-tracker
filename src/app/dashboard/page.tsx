import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { logout } from './actions'

export default async function DashboardPage() {
  const supabase = await createClient()
  
  const { data, error } = await supabase.auth.getUser()
  
  if (error || !data?.user) {
    redirect('/login')
  }

  return (
    <div style={{ padding: '20px', maxWidth: '600px', margin: '0 auto' }}>
      <h1>Dashboard</h1>
      <p>Welcome, {data.user.email}!</p>
      <p>User ID: <code>{data.user.id}</code></p>
      
      <form>
        <button formAction={logout}>Log out</button>
      </form>
    </div>
  )
}