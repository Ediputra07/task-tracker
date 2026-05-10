import { login, signup } from './actions'

export default async function LoginPage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string }>
}) {
  const params = await searchParams
  const errorParam = params.error

  const errorMessages: Record<string, string> = {
    invalid_credentials: '⚠️ Wrong email or password.',
    email_taken: '⚠️ Email already registered. Try logging in.',
    weak_password: '⚠️ Password must be at least 6 characters.',
    signup_failed: '⚠️ Signup failed. Try again.',
  }
  const errorMessage = errorParam ? errorMessages[errorParam] : null

  return (
    <div style={{ padding: '20px', maxWidth: '400px', margin: '0 auto' }}>
      <h1>Login / Signup</h1>

      {errorMessage && (
        <div style={{ color: 'red', marginBottom: '12px' }}>
          {errorMessage}
        </div>
      )}

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
