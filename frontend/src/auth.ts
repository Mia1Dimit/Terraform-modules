/**
 * Lightweight Cognito OAuth2 PKCE auth — zero dependencies.
 */

const COGNITO_DOMAIN = import.meta.env.VITE_COGNITO_DOMAIN ?? 'linkedin-agent-dev-auth.auth.eu-west-1.amazoncognito.com'
const CLIENT_ID      = import.meta.env.VITE_COGNITO_CLIENT_ID ?? '1ftgi27afh18s35cksrkssa5a6'
const REDIRECT_URI   = `${window.location.origin}/callback`
const SCOPES         = 'openid email profile'

// ── Token state ──────────────────────────────────────────────────

interface Tokens {
  id_token: string
  access_token: string
  refresh_token?: string
  expires_at: number
}

let _tokens: Tokens | null = null

function loadTokens(): Tokens | null {
  if (_tokens) return _tokens
  const raw = sessionStorage.getItem('auth_tokens')
  if (!raw) return null
  try {
    _tokens = JSON.parse(raw)
    return _tokens
  } catch { return null }
}

function saveTokens(t: Tokens) {
  _tokens = t
  sessionStorage.setItem('auth_tokens', JSON.stringify(t))
}

export function clearTokens() {
  _tokens = null
  sessionStorage.removeItem('auth_tokens')
  sessionStorage.removeItem('pkce_verifier')
}

// ── PKCE helpers ─────────────────────────────────────────────────

function randomString(len: number): string {
  const arr = new Uint8Array(len)
  crypto.getRandomValues(arr)
  return Array.from(arr, b => b.toString(16).padStart(2, '0')).join('').slice(0, len)
}

async function sha256(plain: string): Promise<ArrayBuffer> {
  return crypto.subtle.digest('SHA-256', new TextEncoder().encode(plain))
}

function base64url(buf: ArrayBuffer): string {
  return btoa(String.fromCharCode(...new Uint8Array(buf)))
    .replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '')
}

// ── Public API ───────────────────────────────────────────────────

/** Get a valid ID token, refreshing if needed. Returns null if not logged in. */
export async function getIdToken(): Promise<string | null> {
  const t = loadTokens()
  if (!t) return null

  // If token expires in <60s, try refresh
  if (Date.now() > t.expires_at - 60_000) {
    if (t.refresh_token) {
      const ok = await refreshTokens(t.refresh_token)
      if (!ok) { clearTokens(); return null }
      return loadTokens()!.id_token
    }
    clearTokens()
    return null
  }

  return t.id_token
}

/** True if we have tokens in session. */
export function isAuthenticated(): boolean {
  return loadTokens() !== null
}

/** Redirect to Cognito Hosted UI login. */
export async function login() {
  const verifier = randomString(64)
  sessionStorage.setItem('pkce_verifier', verifier)
  const challenge = base64url(await sha256(verifier))

  const params = new URLSearchParams({
    response_type: 'code',
    client_id: CLIENT_ID,
    redirect_uri: REDIRECT_URI,
    scope: SCOPES,
    code_challenge: challenge,
    code_challenge_method: 'S256',
  })
  window.location.href = `https://${COGNITO_DOMAIN}/login?${params}`
}

/** Exchange auth code for tokens (called on /callback). */
export async function handleCallback(): Promise<boolean> {
  const url = new URL(window.location.href)
  const code = url.searchParams.get('code')
  const verifier = sessionStorage.getItem('pkce_verifier')
  if (!code || !verifier) return false

  const res = await fetch(`https://${COGNITO_DOMAIN}/oauth2/token`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'authorization_code',
      client_id: CLIENT_ID,
      redirect_uri: REDIRECT_URI,
      code,
      code_verifier: verifier,
    }),
  })

  if (!res.ok) return false

  const data = await res.json()
  saveTokens({
    id_token: data.id_token,
    access_token: data.access_token,
    refresh_token: data.refresh_token,
    expires_at: Date.now() + data.expires_in * 1000,
  })
  sessionStorage.removeItem('pkce_verifier')

  // Clean the URL
  window.history.replaceState({}, '', '/')
  return true
}

/** Refresh tokens using refresh_token grant. */
async function refreshTokens(refreshToken: string): Promise<boolean> {
  try {
    const res = await fetch(`https://${COGNITO_DOMAIN}/oauth2/token`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        grant_type: 'refresh_token',
        client_id: CLIENT_ID,
        refresh_token: refreshToken,
      }),
    })
    if (!res.ok) return false
    const data = await res.json()
    saveTokens({
      id_token: data.id_token,
      access_token: data.access_token,
      refresh_token: refreshToken,  // Cognito doesn't return a new one
      expires_at: Date.now() + data.expires_in * 1000,
    })
    return true
  } catch { return false }
}

/** Logout: clear tokens and redirect to Cognito logout. */
export function logout() {
  clearTokens()
  const params = new URLSearchParams({
    client_id: CLIENT_ID,
    logout_uri: `${window.location.origin}/logout`,
  })
  window.location.href = `https://${COGNITO_DOMAIN}/logout?${params}`
}
