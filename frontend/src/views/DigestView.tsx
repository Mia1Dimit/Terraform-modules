import { useState, useEffect, useCallback } from 'react'
import { api, type DigestData, type WeeklyDigestData, type Opportunity, type TrendPoint } from '../api/client'
import { AreaChart, Area, ResponsiveContainer, Tooltip, XAxis } from 'recharts'

// ── Trend Sparkline ───────────────────────────────────────────────────────
function Sparkline({ data, color = 'var(--gold)' }: { data: TrendPoint[]; color?: string }) {
  if (!data || data.length < 2) return null
  const id = `grad-${color.replace(/[^a-z0-9]/gi, '')}`
  return (
    <div style={{ width: '100%', height: 48 }}>
      <ResponsiveContainer>
        <AreaChart data={data} margin={{ top: 4, right: 0, left: 0, bottom: 0 }}>
          <defs>
            <linearGradient id={id} x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor={color} stopOpacity={0.3} />
              <stop offset="100%" stopColor={color} stopOpacity={0} />
            </linearGradient>
          </defs>
          <XAxis dataKey="date" hide />
          <Tooltip
            contentStyle={{ background: 'var(--ink)', border: '1px solid var(--border)', borderRadius: 6, fontSize: '0.75rem' }}
            labelStyle={{ color: 'var(--text-muted)' }}
            formatter={(v) => [String(Number(v).toFixed(1)), '']}
          />
          <Area type="monotone" dataKey="value" stroke={color} strokeWidth={1.5} fill={`url(#${id})`} dot={false} animationDuration={800} />
        </AreaChart>
      </ResponsiveContainer>
    </div>
  )
}

// ── Score meter ───────────────────────────────────────────────────────────
function ScoreMeter({ score, max = 10 }: { score: number; max?: number }) {
  const pct = Math.round((score / max) * 100)
  const color = pct >= 70 ? 'var(--green)' : pct >= 40 ? 'var(--gold)' : 'var(--text-muted)'
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 'var(--sp-2)' }}>
      <span style={{ fontFamily: 'var(--font-mono)', fontSize: '1.4rem', fontWeight: 500, color, lineHeight: 1 }}>{score}</span>
      <div style={{ flex: 1, height: 3, background: 'var(--surface)', borderRadius: 2, overflow: 'hidden' }}>
        <div style={{ height: '100%', width: `${pct}%`, background: color, borderRadius: 2, transition: 'width 0.8s var(--ease)' }} />
      </div>
    </div>
  )
}

// ── Opportunity detail modal ──────────────────────────────────────────────
function OpportunityDetail({ opp, onClose }: { opp: Opportunity; onClose: () => void }) {
  const scoreColor = (opp.score ?? 0) >= 7 ? 'var(--green)' : (opp.score ?? 0) >= 4 ? 'var(--gold)' : 'var(--text-muted)'
  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div className="modal-content" onClick={e => e.stopPropagation()} style={{ maxWidth: 480 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 'var(--sp-4)' }}>
          <span className={`action-chip ${(opp.action ?? '').toLowerCase()}`}>{opp.action}</span>
          <button className="btn btn-ghost" onClick={onClose} style={{ padding: 'var(--sp-1)', lineHeight: 1 }}>✕</button>
        </div>
        <h3 style={{ fontSize: '1.1rem', color: 'var(--text-primary)', marginBottom: 'var(--sp-2)' }}>{opp.title}</h3>
        <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', marginBottom: 'var(--sp-4)' }}>{opp.company}</p>
        <div style={{ display: 'grid', gap: 'var(--sp-3)', marginBottom: 'var(--sp-4)' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', padding: 'var(--sp-3)', background: 'var(--surface)', borderRadius: 'var(--radius)', border: '1px solid var(--border)' }}>
            <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Match Score</span>
            <span style={{ fontFamily: 'var(--font-mono)', fontSize: '1.2rem', color: scoreColor, fontWeight: 600 }}>{opp.score}/10</span>
          </div>
          <div style={{ padding: 'var(--sp-3)', background: 'var(--surface)', borderRadius: 'var(--radius)', border: '1px solid var(--border)' }}>
            <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '0.08em', display: 'block', marginBottom: 'var(--sp-2)' }}>Why it fits</span>
            <span style={{ fontSize: '0.85rem', color: 'var(--text-primary)' }}>{opp.fit_reason}</span>
          </div>
          {opp.run_date && (
            <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Detected: {opp.run_date}</div>
          )}
        </div>
        <div style={{ display: 'flex', gap: 'var(--sp-3)' }}>
          {opp.linkedin_url && (
            <a href={opp.linkedin_url} target="_blank" rel="noopener noreferrer" className="btn btn-primary" style={{ flex: 1, textAlign: 'center', textDecoration: 'none' }}>
              View on LinkedIn ↗
            </a>
          )}
          <button className="btn btn-ghost" onClick={() => { api.patchOpportunity(opp.id, 'DISMISSED'); onClose() }} style={{ flex: opp.linkedin_url ? undefined : 1 }}>
            Dismiss
          </button>
        </div>
      </div>
    </div>
  )
}

// ── Trend card ────────────────────────────────────────────────────────────
function TrendCard({ title, data, color }: { title: string; data: TrendPoint[]; color: string }) {
  const latest = data.length > 0 ? data[data.length - 1].value : 0
  const prev = data.length > 1 ? data[data.length - 2].value : latest
  const delta = latest - prev
  const deltaText = delta > 0 ? `+${delta.toFixed(1)}` : delta.toFixed(1)
  return (
    <div className="card" style={{ padding: 'var(--sp-4)' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 'var(--sp-2)' }}>
        <span style={{ fontSize: '0.7rem', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '0.1em' }}>{title}</span>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 'var(--sp-2)' }}>
          <span style={{ fontFamily: 'var(--font-mono)', fontSize: '1.2rem', color: 'var(--text-primary)', fontWeight: 500 }}>{latest.toFixed(1)}</span>
          {data.length > 1 && (
            <span style={{ fontFamily: 'var(--font-mono)', fontSize: '0.7rem', color: delta >= 0 ? 'var(--green)' : 'var(--red)' }}>{deltaText}</span>
          )}
        </div>
      </div>
      <Sparkline data={data} color={color} />
    </div>
  )
}

// ── Weekly digest section ─────────────────────────────────────────────────
function WeeklyDigestSection() {
  const [data, setData] = useState<WeeklyDigestData | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => { api.getWeeklyDigest().then(setData).catch(() => setData(null)).finally(() => setLoading(false)) }, [])

  if (loading) return <div style={{ display: 'grid', gap: 'var(--sp-3)' }}>{[80, 60, 90].map((w, i) => <div key={i} className="skeleton" style={{ height: 16, width: `${w}%` }} />)}</div>
  if (!data || data.error) return <div className="empty-state" style={{ padding: 'var(--sp-8)' }}><div className="empty-state-icon">📆</div><div className="empty-state-title">Weekly digest pending</div><div className="empty-state-sub">Run the scraper in WEEKLY mode to generate your digest.</div></div>

  const priorityColor = (p: string) => p === 'HIGH' ? 'var(--red)' : p === 'MED' ? 'var(--gold)' : 'var(--text-muted)'
  return (
    <div style={{ display: 'grid', gap: 'var(--sp-5)' }}>
      <div style={{ background: 'var(--ink-soft)', border: '1px solid var(--border)', borderLeft: '3px solid var(--gold)', borderRadius: 'var(--radius-lg)', padding: 'var(--sp-5)', fontSize: '0.88rem', lineHeight: 1.7, color: 'var(--text-secondary)', fontStyle: 'italic' }}>{data.narrative}</div>
      {data.actions.length > 0 && (
        <div style={{ display: 'grid', gap: 'var(--sp-3)' }}>
          {data.actions.map((a, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 'var(--sp-4)', padding: 'var(--sp-3) var(--sp-4)', background: 'var(--surface)', borderRadius: 'var(--radius)', border: '1px solid var(--border)' }}>
              <span style={{ fontFamily: 'var(--font-mono)', fontSize: '0.6rem', letterSpacing: '0.1em', color: priorityColor(a.priority), textTransform: 'uppercase', minWidth: 30 }}>{a.priority}</span>
              <span style={{ fontSize: '0.82rem', color: 'var(--text-primary)' }}>{a.action}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

// ── Main DigestView ───────────────────────────────────────────────────────
export default function DigestView() {
  const [data, setData] = useState<DigestData | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [selectedOpp, setSelectedOpp] = useState<Opportunity | null>(null)

  const load = useCallback(() => { setLoading(true); setError(null); api.getDigest().then(setData).catch((e: Error) => setError(e.message)).finally(() => setLoading(false)) }, [])
  useEffect(() => { load() }, [load])

  const today = new Date().toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })
  const trends = data?.trends ?? {}

  return (
    <>
      {selectedOpp && <OpportunityDetail opp={selectedOpp} onClose={() => setSelectedOpp(null)} />}

      <div className="page-header">
        <div className="page-date">{today}</div>
        <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between' }}>
          <div>
            <h1 className="page-title">Daily Intelligence</h1>
            <p className="page-subtitle">Your LinkedIn career signals, classified and ranked by Claude Sonnet 4.5.</p>
          </div>
          <button className="btn btn-ghost" onClick={load} disabled={loading}>↺ Refresh</button>
        </div>
      </div>

      <div className="digest-view">
        {error && <div className="error-banner">⚠ {error}</div>}

        {/* ── Trends row ── */}
        {Object.keys(trends).length > 0 && (
          <section>
            <h2 className="digest-section-title">Trends</h2>
            <div className="cards-grid" style={{ gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))' }}>
              {trends.avg_relevance && <TrendCard title="Avg Relevance" data={trends.avg_relevance} color="#d4a017" />}
              {trends.feed_count && <TrendCard title="Feed Items" data={trends.feed_count} color="#5b8def" />}
              {trends.opportunity_count && <TrendCard title="Opportunities" data={trends.opportunity_count} color="#4caf88" />}
            </div>
          </section>
        )}

        {/* ── Feed Highlights ── */}
        <section>
          <h2 className="digest-section-title">Feed Highlights</h2>
          {loading ? (
            <div className="cards-grid">{[1, 2, 3].map(i => <div key={i} className="card" style={{ display: 'grid', gap: 'var(--sp-3)' }}><div className="skeleton" style={{ height: 12, width: '40%' }} /><div className="skeleton" style={{ height: 18 }} /><div className="skeleton" style={{ height: 14, width: '80%' }} /></div>)}</div>
          ) : !data?.feed_highlights?.length ? (
            <div className="empty-state"><div className="empty-state-icon">📰</div><div className="empty-state-title">No feed data yet</div><div className="empty-state-sub">Run the daily scraper to populate your feed intelligence.</div></div>
          ) : (
            <div className="cards-grid">
              {data.feed_highlights.map((item, i) => (
                <div key={item.item_id || i} className="card" style={{ animationDelay: `${i * 40}ms` }}>
                  <div className="card-badge">{item.category?.replace(/_/g, ' ')}</div>
                  <ScoreMeter score={item.relevance_score ?? 0} />
                  <p className="card-body" style={{ marginTop: 'var(--sp-3)' }}>{item.key_insight}</p>
                </div>
              ))}
            </div>
          )}
        </section>

        {/* ── Opportunities ── */}
        <section>
          <h2 className="digest-section-title">Opportunity Radar</h2>
          {loading ? (
            <div className="cards-grid">{[1, 2].map(i => <div key={i} className="card" style={{ display: 'grid', gap: 'var(--sp-3)' }}><div className="skeleton" style={{ height: 14, width: '60%' }} /><div className="skeleton" style={{ height: 12, width: '40%' }} /><div className="skeleton" style={{ height: 14, width: '90%' }} /></div>)}</div>
          ) : !data?.top_opportunities?.length ? (
            <div className="empty-state"><div className="empty-state-icon">🎯</div><div className="empty-state-title">No active opportunities</div><div className="empty-state-sub">Job signals will appear here after the next daily scrape.</div></div>
          ) : (
            <div className="cards-grid">
              {data.top_opportunities.map((opp, i) => (
                <div key={opp.id || i} className="card card-interactive" style={{ animationDelay: `${i * 50}ms`, cursor: 'pointer' }} onClick={() => setSelectedOpp(opp)}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 'var(--sp-3)' }}>
                    <span className={`action-chip ${(opp.action ?? '').toLowerCase()}`}>{opp.action}</span>
                    <span style={{ fontFamily: 'var(--font-mono)', fontSize: '1.4rem', color: 'var(--gold)', lineHeight: 1 }}>{opp.score}</span>
                  </div>
                  <div className="card-title">{opp.title}</div>
                  <div className="card-body">{opp.company}</div>
                  <div className="card-meta"><span className="card-author">{opp.fit_reason}</span></div>
                  {opp.linkedin_url && (
                    <a href={opp.linkedin_url} target="_blank" rel="noopener noreferrer" onClick={e => e.stopPropagation()} style={{ fontSize: '0.72rem', color: 'var(--gold)', textDecoration: 'none', marginTop: 'var(--sp-2)', display: 'inline-block' }}>
                      View on LinkedIn ↗
                    </a>
                  )}
                </div>
              ))}
            </div>
          )}
        </section>

        {/* ── Interests ── */}
        {(data?.top_interests?.length ?? 0) > 0 && (
          <section>
            <h2 className="digest-section-title">Inferred Interests</h2>
            <div className="interest-grid">
              {data!.top_interests.map((interest, i) => (
                <div key={i} className="interest-pill">
                  <span>{interest.name}</span>
                  <span className="interest-confidence">{Math.round(parseFloat(interest.confidence || '0') * 100)}%</span>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* ── Weekly Digest ── */}
        <section>
          <h2 className="digest-section-title">Weekly Intelligence</h2>
          <WeeklyDigestSection />
        </section>
      </div>
    </>
  )
}
