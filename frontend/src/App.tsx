import { useState, useEffect } from 'react'
import DigestView from './views/DigestView'
import ChatView from './views/ChatView'
import ProfileView from './views/ProfileView'
import CompanyView from './views/CompanyView'
import { isAuthenticated, login, logout, handleCallback } from './auth'

// ── SVG icons ─────────────────────────────────────────────────────────────
function DigestIcon({ active }: { active: boolean }) {
  return (
    <svg className="nav-icon" viewBox="0 0 16 16" fill="none" stroke={active ? 'var(--gold)' : 'currentColor'} strokeWidth="1.3">
      <rect x="2" y="2" width="5" height="5" rx="1" />
      <rect x="9" y="2" width="5" height="5" rx="1" />
      <rect x="2" y="9" width="5" height="5" rx="1" />
      <rect x="9" y="9" width="5" height="5" rx="1" />
    </svg>
  )
}

function ChatIcon({ active }: { active: boolean }) {
  return (
    <svg className="nav-icon" viewBox="0 0 16 16" fill="none" stroke={active ? 'var(--gold)' : 'currentColor'} strokeWidth="1.3">
      <path d="M2 3h12a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1H5l-3 2V4a1 1 0 0 1 1-1z" />
    </svg>
  )
}

function ProfileIcon({ active }: { active: boolean }) {
  return (
    <svg className="nav-icon" viewBox="0 0 16 16" fill="none" stroke={active ? 'var(--gold)' : 'currentColor'} strokeWidth="1.3">
      <circle cx="8" cy="5" r="2.5" />
      <path d="M2 14c0-3.3 2.7-6 6-6s6 2.7 6 6" />
    </svg>
  )
}

function CompanyIcon({ active }: { active: boolean }) {
  return (
    <svg className="nav-icon" viewBox="0 0 16 16" fill="none" stroke={active ? 'var(--gold)' : 'currentColor'} strokeWidth="1.3">
      <rect x="2" y="4" width="12" height="9" rx="1" />
      <path d="M5 4v-1a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v1" />
      <line x1="8" y1="8" x2="8" y2="11" />
    </svg>
  )
}

type View = 'digest' | 'chat' | 'profile' | 'companies'

// ── Decorative background grid ────────────────────────────────────────────
function BackgroundGrid() {
  return (
    <div
      aria-hidden
      style={{
        position: 'fixed',
        inset: 0,
        pointerEvents: 'none',
        zIndex: 0,
        backgroundImage:
          'linear-gradient(var(--border) 1px, transparent 1px),' +
          'linear-gradient(90deg, var(--border) 1px, transparent 1px)',
        backgroundSize: '60px 60px',
        opacity: 0.35,
      }}
    />
  )
}

export default function App() {
  const [view, setView] = useState<View>('digest')
  const [authed, setAuthed] = useState(isAuthenticated())
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const path = window.location.pathname
    if (path === '/callback') {
      handleCallback().then(ok => {
        setAuthed(ok)
        setLoading(false)
        if (!ok) login()
      })
    } else if (path === '/logout') {
      setAuthed(false)
      setLoading(false)
    } else {
      setLoading(false)
    }
  }, [])

  if (loading) return <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100vh', color: 'var(--text-muted)' }}>Authenticating…</div>

  if (!authed) {
    return (
      <>
        <BackgroundGrid />
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', height: '100vh', gap: 'var(--sp-4)', position: 'relative', zIndex: 1 }}>
          <div style={{ fontSize: '2rem', fontWeight: 600, color: 'var(--text-primary)' }}>Agent</div>
          <div style={{ fontSize: '0.85rem', color: 'var(--text-muted)', marginBottom: 'var(--sp-4)' }}>Career Intelligence</div>
          <button className="btn btn-primary" onClick={() => login()} style={{ padding: 'var(--sp-3) var(--sp-6)', fontSize: '0.9rem' }}>Sign in</button>
        </div>
      </>
    )
  }

  const navItems: Array<{ id: View; label: string; icon: (active: boolean) => JSX.Element }> = [
    { id: 'digest',    label: 'Daily Digest',     icon: (a) => <DigestIcon active={a} /> },
    { id: 'companies', label: 'Companies',        icon: (a) => <CompanyIcon active={a} /> },
    { id: 'chat',      label: 'Intelligence',     icon: (a) => <ChatIcon active={a} /> },
    { id: 'profile',   label: 'My Profile',       icon: (a) => <ProfileIcon active={a} /> },
  ]

  return (
    <>
      <BackgroundGrid />
      <div className="app-shell" style={{ position: 'relative', zIndex: 1 }}>
        {/* Sidebar */}
        <nav className="nav-sidebar" aria-label="Main navigation">
          <div className="nav-logo">
            <div className="nav-logo-wordmark">Agent</div>
            <div className="nav-logo-sub">Career Intelligence</div>
          </div>

          <ul className="nav-items" role="list">
            {navItems.map(item => (
              <li key={item.id} className="nav-item">
                <button
                  className={`nav-link ${view === item.id ? 'active' : ''}`}
                  onClick={() => setView(item.id)}
                  aria-current={view === item.id ? 'page' : undefined}
                >
                  {item.icon(view === item.id)}
                  <span>{item.label}</span>
                </button>
              </li>
            ))}
          </ul>

          <div className="nav-footer">
            <div className="nav-status">
              <div className="status-dot" />
              <span>Connected</span>
            </div>
            <button className="btn btn-ghost" onClick={() => logout()} style={{ fontSize: '0.75rem', padding: 'var(--sp-1) var(--sp-2)', marginTop: 'var(--sp-2)' }}>Sign out</button>
          </div>
        </nav>

        {/* Content */}
        <main className="main-content" role="main">
          {view === 'digest'    && <DigestView />}
          {view === 'companies' && <CompanyView />}
          {view === 'chat'      && <ChatView />}
          {view === 'profile'   && <ProfileView />}
        </main>
      </div>
    </>
  )
}
