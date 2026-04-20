import { useState, useEffect, useRef } from 'react'
import { api, Skill, ProfileTargets, UserProfile } from '../api/client'

// ── Constants ─────────────────────────────────────────────────────────────

const SECTOR_OPTIONS = [
  'Technology', 'Energy & Utilities', 'Finance & Banking', 'Healthcare',
  'Telecommunications', 'Manufacturing', 'Consulting', 'Public Sector',
  'Startups & VC', 'Media & Entertainment',
]

const COMPANY_SIZE_OPTIONS = [
  '1–50', '51–200', '201–1000', '1K–5K', '5K–20K', '20K+',
]

// ── Tabs ──────────────────────────────────────────────────────────────────

type Tab = 'skills' | 'targets' | 'context'

// ── Skills tab ────────────────────────────────────────────────────────────

function MaturityBar({ value, onChange }: { value: number; onChange: (v: number) => void }) {
  const pct = value + '%'
  const color =
    value >= 75 ? 'var(--green)' : value >= 40 ? 'var(--gold)' : 'var(--text-muted)'
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 'var(--sp-3)', flex: 1 }}>
      <div style={{ flex: 1, height: 4, background: 'var(--border)', borderRadius: 2, position: 'relative' }}>
        <div
          style={{
            position: 'absolute', left: 0, top: 0, height: '100%',
            width: pct, background: color,
            borderRadius: 2, transition: 'width 0.2s var(--ease)',
          }}
        />
        <input
          type="range" min={0} max={100} value={value}
          onChange={e => onChange(Number(e.target.value))}
          style={{
            position: 'absolute', inset: '-6px 0',
            width: '100%', height: '16px',
            opacity: 0, cursor: 'pointer',
          }}
        />
      </div>
      <span style={{ fontFamily: 'var(--font-mono)', fontSize: '0.65rem', color, minWidth: 32, textAlign: 'right' }}>
        {value}%
      </span>
    </div>
  )
}

function SkillsTab({ skills, onSave }: { skills: Skill[]; onSave: (skills: Skill[]) => void }) {
  const [rows, setRows] = useState<Skill[]>(skills)
  const [newName, setNewName] = useState('')
  const [saving, setSaving] = useState<string | null>(null)
  const [dirty, setDirty] = useState<Set<string>>(new Set())
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => { setRows(skills) }, [skills])

  const markDirty = (slug: string) =>
    setDirty(prev => new Set([...prev, slug]))

  const updateRow = (slug: string, patch: Partial<Skill>) => {
    setRows(prev => prev.map(r => r.slug === slug ? { ...r, ...patch } : r))
    markDirty(slug)
  }

  const saveRow = async (skill: Skill) => {
    setSaving(skill.slug)
    try {
      await api.putSkill({ name: skill.name, maturity: skill.maturity, active: skill.active })
      setDirty(prev => { const n = new Set(prev); n.delete(skill.slug); return n })
    } catch (e) {
      console.error('Failed to save skill', e)
    } finally {
      setSaving(null)
    }
  }

  const deleteRow = async (slug: string) => {
    setRows(prev => prev.filter(r => r.slug !== slug))
    try { await api.deleteSkill(slug) } catch { /* best effort */ }
  }

  const addRow = async () => {
    const name = newName.trim()
    if (!name) return
    const slug = name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
    const skill: Skill = { slug, name, maturity: 50, active: true, source: 'manual' }
    setRows(prev => [...prev, skill])
    setNewName('')
    inputRef.current?.focus()
    try {
      await api.putSkill({ name, maturity: 50, active: true })
    } catch (e) {
      console.error('Failed to add skill', e)
    }
    onSave([...rows, skill])
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-6)' }}>
      <p style={{ fontSize: '0.8rem', color: 'var(--text-muted)' }}>
        Rate your proficiency for each skill (0 = learning, 100 = expert). The AI uses this to
        personalise opportunity scoring and career advice.
      </p>

      <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-2)' }}>
        {/* Header */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 2fr 80px 40px', gap: 'var(--sp-3)', padding: '0 var(--sp-2)', alignItems: 'center' }}>
          <span style={{ fontFamily: 'var(--font-mono)', fontSize: '0.6rem', color: 'var(--text-muted)', letterSpacing: '0.1em', textTransform: 'uppercase' }}>Skill</span>
          <span style={{ fontFamily: 'var(--font-mono)', fontSize: '0.6rem', color: 'var(--text-muted)', letterSpacing: '0.1em', textTransform: 'uppercase' }}>Proficiency</span>
          <span style={{ fontFamily: 'var(--font-mono)', fontSize: '0.6rem', color: 'var(--text-muted)', letterSpacing: '0.1em', textTransform: 'uppercase' }}>Active</span>
          <span />
        </div>

        {rows.map(skill => (
          <div
            key={skill.slug}
            style={{
              display: 'grid', gridTemplateColumns: '1fr 2fr 80px 40px',
              gap: 'var(--sp-3)', padding: 'var(--sp-3) var(--sp-2)',
              background: 'var(--ink-soft)', border: '1px solid var(--border)',
              borderRadius: 'var(--radius-md)', alignItems: 'center',
              opacity: skill.active ? 1 : 0.45,
            }}
          >
            <span style={{ fontSize: '0.82rem', color: 'var(--text-primary)', fontWeight: 500 }}>
              {skill.name}
              {dirty.has(skill.slug) && (
                <button
                  onClick={() => saveRow(skill)}
                  disabled={saving === skill.slug}
                  style={{
                    marginLeft: 8, fontSize: '0.6rem', fontFamily: 'var(--font-mono)',
                    color: 'var(--gold)', background: 'none', border: 'none', cursor: 'pointer',
                    letterSpacing: '0.1em', textTransform: 'uppercase',
                  }}
                >
                  {saving === skill.slug ? '…' : 'Save'}
                </button>
              )}
            </span>
            <MaturityBar
              value={skill.maturity}
              onChange={v => updateRow(skill.slug, { maturity: v })}
            />
            <label style={{ display: 'flex', alignItems: 'center', gap: 'var(--sp-2)', cursor: 'pointer', justifyContent: 'center' }}>
              <input
                type="checkbox"
                checked={skill.active}
                onChange={e => updateRow(skill.slug, { active: e.target.checked })}
                style={{ accentColor: 'var(--gold)', width: 14, height: 14 }}
              />
            </label>
            <button
              onClick={() => deleteRow(skill.slug)}
              style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--text-muted)', fontSize: '0.9rem', lineHeight: 1 }}
              title="Remove skill"
            >×</button>
          </div>
        ))}
      </div>

      {/* Add new skill */}
      <div style={{ display: 'flex', gap: 'var(--sp-3)' }}>
        <input
          ref={inputRef}
          type="text"
          placeholder="Add skill…"
          value={newName}
          onChange={e => setNewName(e.target.value)}
          onKeyDown={e => { if (e.key === 'Enter') addRow() }}
          style={{
            flex: 1, background: 'var(--surface)', border: '1px solid var(--border)',
            borderRadius: 'var(--radius-md)', padding: 'var(--sp-2) var(--sp-3)',
            color: 'var(--text-primary)', fontSize: '0.85rem',
            outline: 'none',
          }}
        />
        <button className="btn btn-primary" onClick={addRow} disabled={!newName.trim()}>
          Add
        </button>
      </div>
    </div>
  )
}

// ── Targets tab ───────────────────────────────────────────────────────────

function TargetsTab({ targets: initial }: { targets: ProfileTargets }) {
  const [targets, setTargets] = useState<ProfileTargets>(initial)
  const [roleInput, setRoleInput] = useState('')
  const [saving, setSaving] = useState(false)
  const [saved, setSaved] = useState(false)

  useEffect(() => { setTargets(initial) }, [initial])

  const toggleSector = (s: string) =>
    setTargets(prev => ({
      ...prev,
      target_sectors: prev.target_sectors.includes(s)
        ? prev.target_sectors.filter(x => x !== s)
        : [...prev.target_sectors, s],
    }))

  const toggleSize = (s: string) =>
    setTargets(prev => ({
      ...prev,
      company_size: prev.company_size.includes(s)
        ? prev.company_size.filter(x => x !== s)
        : [...prev.company_size, s],
    }))

  const addRole = () => {
    const r = roleInput.trim()
    if (!r || targets.target_roles.includes(r)) return
    setTargets(prev => ({ ...prev, target_roles: [...prev.target_roles, r] }))
    setRoleInput('')
  }

  const removeRole = (r: string) =>
    setTargets(prev => ({ ...prev, target_roles: prev.target_roles.filter(x => x !== r) }))

  const save = async () => {
    setSaving(true)
    try {
      await api.putTargets(targets)
      setSaved(true)
      setTimeout(() => setSaved(false), 2000)
    } catch (e) {
      console.error('Failed to save targets', e)
    } finally {
      setSaving(false)
    }
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-6)' }}>
      <p style={{ fontSize: '0.8rem', color: 'var(--text-muted)' }}>
        Define your career targets. The AI uses these to filter opportunities and focus advice.
      </p>

      {/* Target roles */}
      <div>
        <label style={{ fontFamily: 'var(--font-mono)', fontSize: '0.6rem', color: 'var(--text-muted)', letterSpacing: '0.1em', textTransform: 'uppercase', display: 'block', marginBottom: 'var(--sp-3)' }}>
          Target Roles
        </label>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 'var(--sp-2)', marginBottom: 'var(--sp-3)' }}>
          {targets.target_roles.map(r => (
            <span
              key={r}
              className="interest-pill"
              style={{ cursor: 'pointer' }}
              onClick={() => removeRole(r)}
              title="Click to remove"
            >
              {r} <span style={{ color: 'var(--text-muted)', marginLeft: 4 }}>×</span>
            </span>
          ))}
        </div>
        <div style={{ display: 'flex', gap: 'var(--sp-3)' }}>
          <input
            type="text"
            placeholder="e.g. Senior Cloud Engineer…"
            value={roleInput}
            onChange={e => setRoleInput(e.target.value)}
            onKeyDown={e => { if (e.key === 'Enter') addRole() }}
            style={{
              flex: 1, background: 'var(--surface)', border: '1px solid var(--border)',
              borderRadius: 'var(--radius-md)', padding: 'var(--sp-2) var(--sp-3)',
              color: 'var(--text-primary)', fontSize: '0.85rem', outline: 'none',
            }}
          />
          <button className="btn btn-ghost" onClick={addRole} disabled={!roleInput.trim()}>Add</button>
        </div>
      </div>

      {/* Target sectors */}
      <div>
        <label style={{ fontFamily: 'var(--font-mono)', fontSize: '0.6rem', color: 'var(--text-muted)', letterSpacing: '0.1em', textTransform: 'uppercase', display: 'block', marginBottom: 'var(--sp-3)' }}>
          Target Sectors
        </label>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 'var(--sp-2)' }}>
          {SECTOR_OPTIONS.map(s => {
            const selected = targets.target_sectors.includes(s)
            return (
              <button
                key={s}
                onClick={() => toggleSector(s)}
                className="action-chip"
                style={{
                  cursor: 'pointer', border: selected ? '1px solid var(--gold)' : '1px solid var(--border)',
                  background: selected ? 'var(--gold-soft)' : 'var(--surface)',
                  color: selected ? 'var(--gold)' : 'var(--text-secondary)',
                }}
              >
                {s}
              </button>
            )
          })}
        </div>
      </div>

      {/* Company size */}
      <div>
        <label style={{ fontFamily: 'var(--font-mono)', fontSize: '0.6rem', color: 'var(--text-muted)', letterSpacing: '0.1em', textTransform: 'uppercase', display: 'block', marginBottom: 'var(--sp-3)' }}>
          Company Size
        </label>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 'var(--sp-2)' }}>
          {COMPANY_SIZE_OPTIONS.map(s => {
            const selected = targets.company_size.includes(s)
            return (
              <button
                key={s}
                onClick={() => toggleSize(s)}
                className="action-chip"
                style={{
                  cursor: 'pointer', border: selected ? '1px solid var(--gold)' : '1px solid var(--border)',
                  background: selected ? 'var(--gold-soft)' : 'var(--surface)',
                  color: selected ? 'var(--gold)' : 'var(--text-secondary)',
                }}
              >
                {s}
              </button>
            )
          })}
        </div>
      </div>

      {/* Location + relocation */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr auto', gap: 'var(--sp-4)', alignItems: 'end' }}>
        <div>
          <label style={{ fontFamily: 'var(--font-mono)', fontSize: '0.6rem', color: 'var(--text-muted)', letterSpacing: '0.1em', textTransform: 'uppercase', display: 'block', marginBottom: 'var(--sp-2)' }}>
            Location Preference
          </label>
          <input
            type="text"
            placeholder="e.g. Milan, Italy or Remote EU"
            value={targets.location_preference}
            onChange={e => setTargets(prev => ({ ...prev, location_preference: e.target.value }))}
            style={{
              width: '100%', background: 'var(--surface)', border: '1px solid var(--border)',
              borderRadius: 'var(--radius-md)', padding: 'var(--sp-2) var(--sp-3)',
              color: 'var(--text-primary)', fontSize: '0.85rem', outline: 'none', boxSizing: 'border-box',
            }}
          />
        </div>
        <label style={{ display: 'flex', alignItems: 'center', gap: 'var(--sp-2)', cursor: 'pointer', paddingBottom: 2 }}>
          <input
            type="checkbox"
            checked={targets.open_to_relocation}
            onChange={e => setTargets(prev => ({ ...prev, open_to_relocation: e.target.checked }))}
            style={{ accentColor: 'var(--gold)', width: 14, height: 14 }}
          />
          <span style={{ fontSize: '0.8rem', color: 'var(--text-secondary)' }}>Open to relocation</span>
        </label>
      </div>

      {/* Freetext career goals */}
      <div>
        <label style={{ fontFamily: 'var(--font-mono)', fontSize: '0.6rem', color: 'var(--text-muted)', letterSpacing: '0.1em', textTransform: 'uppercase', display: 'block', marginBottom: 'var(--sp-2)' }}>
          Career Goals (optional)
        </label>
        <textarea
          placeholder="Describe your career goals in plain language…"
          value={targets.freetext}
          onChange={e => setTargets(prev => ({ ...prev, freetext: e.target.value.slice(0, 1000) }))}
          rows={3}
          style={{
            width: '100%', background: 'var(--surface)', border: '1px solid var(--border)',
            borderRadius: 'var(--radius-md)', padding: 'var(--sp-3)',
            color: 'var(--text-primary)', fontSize: '0.85rem', outline: 'none',
            resize: 'vertical', lineHeight: 1.55, boxSizing: 'border-box', fontFamily: 'inherit',
          }}
        />
        <div style={{ textAlign: 'right', fontSize: '0.65rem', color: 'var(--text-muted)', marginTop: 2 }}>
          {targets.freetext.length}/1000
        </div>
      </div>

      <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
        <button className="btn btn-primary" onClick={save} disabled={saving}>
          {saving ? 'Saving…' : saved ? '✓ Saved' : 'Save Targets'}
        </button>
      </div>
    </div>
  )
}

// ── Context tab ───────────────────────────────────────────────────────────

function ContextTab({ notes: initial }: { notes: string }) {
  const [notes, setNotes] = useState(initial)
  const [saving, setSaving] = useState(false)
  const [saved, setSaved] = useState(false)

  useEffect(() => { setNotes(initial) }, [initial])

  const save = async () => {
    setSaving(true)
    try {
      await api.putContext(notes)
      setSaved(true)
      setTimeout(() => setSaved(false), 2000)
    } catch (e) {
      console.error('Failed to save context', e)
    } finally {
      setSaving(false)
    }
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-6)' }}>
      <p style={{ fontSize: '0.8rem', color: 'var(--text-muted)' }}>
        Add any context the AI should know about you — current situation, constraints, priorities,
        or anything that doesn't fit the structured fields. Max 2000 characters.
      </p>
      <textarea
        placeholder="e.g. I'm currently employed at Terna and not actively searching, but want to track opportunities in cloud/IoT. I have a technical background and prefer IC roles over management. I'm based in Rome and prefer remote-friendly companies…"
        value={notes}
        onChange={e => setNotes(e.target.value.slice(0, 2000))}
        rows={12}
        style={{
          width: '100%', background: 'var(--surface)', border: '1px solid var(--border)',
          borderRadius: 'var(--radius-md)', padding: 'var(--sp-4)',
          color: 'var(--text-primary)', fontSize: '0.85rem', outline: 'none',
          resize: 'vertical', lineHeight: 1.65, boxSizing: 'border-box',
          fontFamily: 'inherit',
        }}
      />
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <span style={{ fontSize: '0.65rem', color: 'var(--text-muted)', fontFamily: 'var(--font-mono)' }}>
          {notes.length}/2000 chars
        </span>
        <button className="btn btn-primary" onClick={save} disabled={saving}>
          {saving ? 'Saving…' : saved ? '✓ Saved' : 'Save Context'}
        </button>
      </div>
    </div>
  )
}

// ── ProfileView ───────────────────────────────────────────────────────────

export default function ProfileView() {
  const [tab, setTab] = useState<Tab>('skills')
  const [profile, setProfile] = useState<UserProfile | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    api.getProfile()
      .then(p => setProfile(p))
      .catch(e => setError(e.message ?? 'Failed to load profile'))
      .finally(() => setLoading(false))
  }, [])

  const tabs: Array<{ id: Tab; label: string }> = [
    { id: 'skills',  label: 'Skills & Proficiency' },
    { id: 'targets', label: 'Career Targets' },
    { id: 'context', label: 'Context Notes' },
  ]

  return (
    <div
      className="digest-view"
      style={{ maxWidth: 760, margin: '0 auto' }}
    >
      {/* Page header */}
      <div className="page-header">
        <div className="page-date">Profile</div>
        <h1 className="page-title">Your Context Layer</h1>
        <p className="page-subtitle">
          Tell the AI who you are — it uses this to personalise every insight, opportunity score, and recommendation.
        </p>
      </div>

      {/* Tab bar */}
      <div style={{ display: 'flex', gap: 0, borderBottom: '1px solid var(--border)', marginBottom: 'var(--sp-8)' }}>
        {tabs.map(t => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            style={{
              background: 'none', border: 'none', cursor: 'pointer',
              padding: 'var(--sp-3) var(--sp-5)',
              color: tab === t.id ? 'var(--gold)' : 'var(--text-muted)',
              fontFamily: 'var(--font-mono)', fontSize: '0.7rem',
              letterSpacing: '0.1em', textTransform: 'uppercase',
              borderBottom: tab === t.id ? '2px solid var(--gold)' : '2px solid transparent',
              marginBottom: -1, transition: 'color var(--t-fast)',
            }}
          >
            {t.label}
          </button>
        ))}
      </div>

      {/* Content */}
      {loading && (
        <div style={{ textAlign: 'center', color: 'var(--text-muted)', padding: 'var(--sp-10)', fontFamily: 'var(--font-mono)', fontSize: '0.75rem' }}>
          Loading profile…
        </div>
      )}

      {error && (
        <div style={{ color: '#ff6b6b', fontSize: '0.82rem', background: 'rgba(255,107,107,0.08)', border: '1px solid rgba(255,107,107,0.2)', borderRadius: 'var(--radius-md)', padding: 'var(--sp-4)' }}>
          {error}
        </div>
      )}

      {!loading && !error && profile && (
        <>
          {tab === 'skills' && (
            <SkillsTab
              skills={profile.skills}
              onSave={skills => setProfile(p => p ? { ...p, skills } : p)}
            />
          )}
          {tab === 'targets' && <TargetsTab targets={profile.targets} />}
          {tab === 'context' && <ContextTab notes={profile.context.notes} />}
        </>
      )}
    </div>
  )
}
