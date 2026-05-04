export default function ErrorPage() {
  return (
    <div style={{ padding: '20px', fontFamily: 'monospace' }}>
      <h1>Sorry, something went wrong</h1>
      <p>Please try again or contact support if the problem persists.</p>
      <a href="/login">Back to login</a>
    </div>
  )
}