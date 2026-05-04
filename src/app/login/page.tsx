import { login, signup } from './actions'

export default function LoginPage() {
  return (
    <div style={{ padding: '20px', maxWidth: '400px', margin: '0 auto' }}>
      <h1>Login / Signup</h1>
      
      <form>
        <div style={{ marginBottom: '12px' }}>
          <label htmlFor="email">Email:</label>
          <input 
            id="email" 
            name="email" 
            type="email" 
            required 
            style={{ display: 'block', width: '100%', padding: '8px' }}
          />
        </div>
        
        <div style={{ marginBottom: '12px' }}>
          <label htmlFor="password">Password:</label>
          <input 
            id="password" 
            name="password" 
            type="password" 
            required 
            style={{ display: 'block', width: '100%', padding: '8px' }}
          />
        </div>
        
        <div style={{ display: 'flex', gap: '8px' }}>
          <button formAction={login}>Log in</button>
          <button formAction={signup}>Sign up</button>
        </div>
      </form>
    </div>
  )
}