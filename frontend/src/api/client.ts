import { getIdToken } from '../auth'

const API_BASE = import.meta.env.VITE_API_URL ?? ''

interface RequestOptions {
  method?: string
  body?: unknown
  params?: Record<string, string>
}

async function request<T>(path: string, opts: RequestOptions = {}): Promise<T> {
  const url = new URL(`${API_BASE}${path}`, window.location.href)
  if (opts.params) {
    Object.entries(opts.params).forEach(([k, v]) => url.searchParams.set(k, v))
  }

  const headers: Record<string, string> = { 'Content-Type': 'application/json' }
  const token = await getIdToken()
  if (token) headers['Authorization'] = `Bearer ${token}`

  const res = await fetch(url.toString(), {
    method: opts.method ?? 'GET',
    headers,
    body: opts.body !== undefined ? JSON.stringify(opts.body) : undefined,
  })

  if (!res.ok) {
    const text = await res.text()
    throw new Error(`API ${res.status}: ${text}`)
  }

  return res.json() as Promise<T>
}

// ── Types ────────────────────────────────────────────────────────────────────

export interface FeedHighlight {
  item_id: string
  category: string
  relevance_score: number
  key_insight: string
}

export interface Opportunity {
  id: string
  title: string
  company: string
  score: number
  fit_reason: string
  action: 'APPLY' | 'TRACK' | 'IGNORE'
  linkedin_url?: string
  run_date?: string
}

export interface Insight {
  type: string
  data: unknown
  run_date: string
}

export interface Interest {
  name: string
  confidence: string
}

export interface TrendPoint {
  date: string
  value: number
}

export interface DigestData {
  date: string
  feed_highlights: FeedHighlight[]
  top_opportunities: Opportunity[]
  insights: Insight[]
  top_interests: Interest[]
  trends?: Record<string, TrendPoint[]>
}

export interface WeeklyDigestData {
  run_date: string
  narrative: string
  actions: Array<{ action: string; priority: 'HIGH' | 'MED' | 'LOW' }>
  error?: string
}

export interface ChatResponse {
  sessionId: string
  response: string
}

export interface Source {
  source_id: string
  url: string
  label: string
  category: string
  frequency: string
  active: boolean
}

export interface Skill {
  slug: string
  name: string
  maturity: number   // 0–100
  active: boolean
  source: string     // 'manual' | 'api' | 'export'
}

export interface ProfileTargets {
  target_roles: string[]
  target_sectors: string[]
  company_size: string[]
  location_preference: string
  open_to_relocation: boolean
  freetext: string
}

export interface UserProfile {
  skills: Skill[]
  targets: ProfileTargets
  context: { notes: string }
}

// ── API calls ────────────────────────────────────────────────────────────────

const USER_ID = 'default-user'

export const api = {
  getDigest: (date?: string) =>
    request<DigestData>('/digest', { params: { userId: USER_ID, ...(date ? { date } : {}) } }),

  getWeeklyDigest: () =>
    request<WeeklyDigestData>('/weekly-digest', { params: { userId: USER_ID } }),

  chat: (message: string, sessionId?: string) =>
    request<ChatResponse>('/chat', {
      method: 'POST',
      body: { message, userId: USER_ID, ...(sessionId ? { sessionId } : {}) },
    }),

  patchInsight: (insightId: string) =>
    request<unknown>(`/insights/${insightId}`, { method: 'PATCH', params: { userId: USER_ID } }),

  patchOpportunity: (id: string, action = 'DISMISSED') =>
    request<unknown>(`/opportunities/${id}`, {
      method: 'PATCH',
      body: { action },
      params: { userId: USER_ID },
    }),

  getSources: () =>
    request<{ sources: Source[] }>('/sources', { params: { userId: USER_ID } }),

  addSource: (data: { url: string; label: string; category: string; frequency: string }) =>
    request<unknown>('/sources', { method: 'POST', body: { ...data, userId: USER_ID } }),

  deleteSource: (sourceId: string) =>
    request<unknown>(`/sources/${sourceId}`, { method: 'DELETE', params: { userId: USER_ID } }),

  // ── Profile endpoints ──────────────────────────────────────────────────
  getProfile: () =>
    request<UserProfile>('/profile', { params: { userId: USER_ID } }),

  putSkill: (skill: Pick<Skill, 'name' | 'maturity' | 'active'>) =>
    request<{ slug: string; name: string; maturity: number; active: boolean }>('/skills', {
      method: 'PUT',
      body: { ...skill, userId: USER_ID },
    }),

  deleteSkill: (slug: string) =>
    request<unknown>(`/skills/${slug}`, { method: 'DELETE', params: { userId: USER_ID } }),

  putTargets: (targets: ProfileTargets) =>
    request<{ saved: boolean }>('/profile/targets', {
      method: 'PUT',
      body: { ...targets, userId: USER_ID },
    }),

  putContext: (notes: string) =>
    request<{ saved: boolean }>('/profile/context', {
      method: 'PUT',
      body: { notes, userId: USER_ID },
    }),
}
