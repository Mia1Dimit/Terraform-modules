import { useState, useEffect, useMemo } from 'react';

interface Profile {
  first_name: string;
  last_name: string;
  headline: string;
  summary: string;
  industry: string;
  location: string;
}

interface Position {
  title: string;
  location: string;
  started: string;
  finished: string;
}

interface Company {
  name: string;
  type: 'employer' | 'followed';
  positions: Position[];
  follow_count: number;
}

interface Statistics {
  total_companies_followed: number;
  total_connections: number;
  total_messages: number;
  total_job_applications: number;
  total_skills: number;
  top_skills: string[];
}

interface AnalysisData {
  profile: Profile;
  statistics: Statistics;
  companies: Company[];
}

export default function CompanyView() {
  const [data, setData] = useState<AnalysisData | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState<'all' | 'employer' | 'followed'>('all');
  const [selectedCompany, setSelectedCompany] = useState<number | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch('/analysis_results.json')
      .then(res => res.json())
      .then(data => {
        setData(data);
        setLoading(false);
      })
      .catch(err => {
        console.error('Failed to load analysis data:', err);
        setLoading(false);
      });
  }, []);

  const filteredCompanies = useMemo(() => {
    if (!data) return [];
    return data.companies.filter(company => {
      const matchesSearch = company.name.toLowerCase().includes(searchTerm.toLowerCase());
      const matchesType = filterType === 'all' || company.type === filterType;
      return matchesSearch && matchesType;
    });
  }, [data, searchTerm, filterType]);

  if (loading) {
    return (
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100vh', color: 'var(--text-muted)' }}>
        Loading company data…
      </div>
    );
  }

  if (!data) {
    return (
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100vh', color: 'var(--text-muted)' }}>
        Failed to load analysis data
      </div>
    );
  }

  return (
    <div style={{ padding: 'var(--sp-6)', overflow: 'auto' }}>
      {/* Header */}
      <div style={{ marginBottom: 'var(--sp-6)' }}>
        <div style={{ display: 'flex', gap: 'var(--sp-4)', marginBottom: 'var(--sp-4)', alignItems: 'flex-start' }}>
          <div
            style={{
              width: '4rem',
              height: '4rem',
              borderRadius: '50%',
              background: 'linear-gradient(135deg, #3b82f6, #1d4ed8)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '1.5rem',
              fontWeight: 'bold',
              color: 'white',
              flexShrink: 0
            }}
          >
            {data.profile.first_name.charAt(0)}
          </div>
          <div>
            <h1 style={{ fontSize: '1.875rem', fontWeight: 'bold', marginBottom: 'var(--sp-2)' }}>
              {data.profile.first_name} {data.profile.last_name}
            </h1>
            <p style={{ color: 'var(--text-muted)', fontSize: '0.9rem' }}>
              {data.profile.headline}
            </p>
            <p style={{ color: 'var(--text-muted)', fontSize: '0.85rem' }}>
              📍 {data.profile.location}
            </p>
          </div>
        </div>

        {data.profile.summary && (
          <p style={{ color: 'var(--text-muted)', fontSize: '0.9rem', lineHeight: '1.5', marginTop: 'var(--sp-3)' }}>
            {data.profile.summary.substring(0, 300)}...
          </p>
        )}
      </div>

      {/* Stats Grid */}
      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))',
        gap: 'var(--sp-4)',
        marginBottom: 'var(--sp-6)'
      }}>
        <div style={{ padding: 'var(--sp-4)', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)', background: 'var(--bg-secondary)' }}>
          <div style={{ color: 'var(--text-muted)', fontSize: '0.85rem', marginBottom: 'var(--sp-1)' }}>Companies Followed</div>
          <div style={{ fontSize: '1.875rem', fontWeight: 'bold', color: 'var(--gold)' }}>
            {data.statistics.total_companies_followed}
          </div>
        </div>

        <div style={{ padding: 'var(--sp-4)', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)', background: 'var(--bg-secondary)' }}>
          <div style={{ color: 'var(--text-muted)', fontSize: '0.85rem', marginBottom: 'var(--sp-1)' }}>Connections</div>
          <div style={{ fontSize: '1.875rem', fontWeight: 'bold', color: 'var(--gold)' }}>
            {data.statistics.total_connections}
          </div>
        </div>

        <div style={{ padding: 'var(--sp-4)', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)', background: 'var(--bg-secondary)' }}>
          <div style={{ color: 'var(--text-muted)', fontSize: '0.85rem', marginBottom: 'var(--sp-1)' }}>Messages</div>
          <div style={{ fontSize: '1.875rem', fontWeight: 'bold', color: 'var(--gold)' }}>
            {data.statistics.total_messages}
          </div>
        </div>

        <div style={{ padding: 'var(--sp-4)', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)', background: 'var(--bg-secondary)' }}>
          <div style={{ color: 'var(--text-muted)', fontSize: '0.85rem', marginBottom: 'var(--sp-1)' }}>Skills</div>
          <div style={{ fontSize: '1.875rem', fontWeight: 'bold', color: 'var(--gold)' }}>
            {data.statistics.total_skills}
          </div>
        </div>
      </div>

      {/* Top Skills */}
      <div style={{ marginBottom: 'var(--sp-6)', padding: 'var(--sp-4)', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)', background: 'var(--bg-secondary)' }}>
        <h2 style={{ fontSize: '1.125rem', fontWeight: 'bold', marginBottom: 'var(--sp-3)' }}>Top Skills</h2>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 'var(--sp-2)' }}>
          {data.statistics.top_skills.map((skill, idx) => (
            <span
              key={idx}
              style={{
                padding: '0.25rem 0.75rem',
                background: 'rgba(59, 130, 246, 0.15)',
                border: '1px solid rgba(59, 130, 246, 0.3)',
                borderRadius: '9999px',
                fontSize: '0.85rem',
                color: '#3b82f6'
              }}
            >
              {skill}
            </span>
          ))}
        </div>
      </div>

      {/* Companies Section */}
      <div style={{ padding: 'var(--sp-4)', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)', background: 'var(--bg-secondary)' }}>
        <h2 style={{ fontSize: '1.125rem', fontWeight: 'bold', marginBottom: 'var(--sp-4)' }}>Companies</h2>

        {/* Search */}
        <div style={{ marginBottom: 'var(--sp-4)' }}>
          <input
            type="text"
            placeholder="Search companies..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            style={{
              width: '100%',
              padding: 'var(--sp-2) var(--sp-3)',
              background: 'var(--bg-primary)',
              border: '1px solid var(--border)',
              borderRadius: 'var(--radius-sm)',
              color: 'var(--text-primary)',
              fontSize: '0.9rem'
            }}
          />
        </div>

        {/* Filters */}
        <div style={{ display: 'flex', gap: 'var(--sp-2)', marginBottom: 'var(--sp-4)' }}>
          {(['all', 'employer', 'followed'] as const).map(type => (
            <button
              key={type}
              onClick={() => setFilterType(type)}
              className={`btn ${filterType === type ? 'btn-primary' : 'btn-ghost'}`}
              style={{
                padding: 'var(--sp-1) var(--sp-3)',
                fontSize: '0.85rem'
              }}
            >
              {type === 'all' ? 'All' : type === 'employer' ? 'Employers' : 'Followed'}
            </button>
          ))}
        </div>

        {/* Companies List */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-2)', maxHeight: '24rem', overflowY: 'auto' }}>
          {filteredCompanies.length > 0 ? (
            filteredCompanies.map((company, idx) => (
              <div
                key={idx}
                onClick={() => setSelectedCompany(selectedCompany === idx ? null : idx)}
                style={{
                  padding: 'var(--sp-3)',
                  background: 'var(--bg-primary)',
                  border: '1px solid var(--border)',
                  borderRadius: 'var(--radius-sm)',
                  cursor: 'pointer',
                  transition: 'all 0.2s'
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'start', marginBottom: 'var(--sp-2)' }}>
                  <div style={{ flex: 1 }}>
                    <h3 style={{ fontWeight: '600', marginBottom: 'var(--sp-1)' }}>
                      {company.name}
                    </h3>
                    <span style={{
                      display: 'inline-block',
                      padding: '0.25rem 0.75rem',
                      fontSize: '0.75rem',
                      background: 'rgba(59, 130, 246, 0.15)',
                      border: '1px solid rgba(59, 130, 246, 0.3)',
                      borderRadius: '0.25rem',
                      color: '#3b82f6'
                    }}>
                      {company.type === 'employer' ? '💼 Employer' : '⭐ Followed'}
                    </span>
                  </div>
                  <span style={{ color: 'var(--text-muted)', fontSize: '0.85rem' }}>
                    {company.follow_count} follow(s)
                  </span>
                </div>

                {/* Expanded view */}
                {selectedCompany === idx && company.positions.length > 0 && (
                  <div style={{ marginTop: 'var(--sp-3)', paddingTop: 'var(--sp-3)', borderTop: '1px solid var(--border)' }}>
                    <p style={{ fontSize: '0.85rem', fontWeight: '600', color: 'var(--text-muted)', marginBottom: 'var(--sp-2)' }}>
                      Positions:
                    </p>
                    {company.positions.map((pos, pidx) => (
                      <div key={pidx} style={{ fontSize: '0.85rem', color: 'var(--text-muted)', marginLeft: 'var(--sp-2)', marginBottom: 'var(--sp-2)' }}>
                        <p style={{ fontWeight: '500', color: 'var(--text-primary)' }}>
                          {pos.title}
                        </p>
                        {pos.location && <p style={{ fontSize: '0.8rem' }}>📍 {pos.location}</p>}
                        {pos.started && (
                          <p style={{ fontSize: '0.8rem' }}>
                            📅 {pos.started}
                            {pos.finished ? ` - ${pos.finished}` : ' - Present'}
                          </p>
                        )}
                      </div>
                    ))}
                  </div>
                )}
              </div>
            ))
          ) : (
            <div style={{ textAlign: 'center', padding: 'var(--sp-4)', color: 'var(--text-muted)' }}>
              No companies found matching your search
            </div>
          )}
        </div>

        <div style={{ marginTop: 'var(--sp-4)', paddingTop: 'var(--sp-4)', borderTop: '1px solid var(--border)', fontSize: '0.85rem', color: 'var(--text-muted)' }}>
          Showing {filteredCompanies.length} of {data.companies.length} companies
        </div>
      </div>
    </div>
  );
}
