import { useState, useRef, useEffect, useCallback } from 'react'
import { api } from '../api/client'

interface Message {
  role: 'user' | 'assistant'
  content: string
  id: string
}

const SUGGESTIONS = [
  "What are my top career opportunities this week?",
  "Which connections should I re-engage with?",
  "Summarise my profile strengths and gaps.",
  "What skills are trending in my network?",
]

function SendIcon() {
  return (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
      <path
        d="M2 8L14 2L10 8L14 14L2 8Z"
        fill="var(--ink)"
        stroke="var(--ink)"
        strokeWidth="0.5"
        strokeLinejoin="round"
      />
    </svg>
  )
}

export default function ChatView() {
  const [messages, setMessages] = useState<Message[]>([])
  const [input, setInput] = useState('')
  const [loading, setLoading] = useState(false)
  const [sessionId] = useState(() => `session-${Date.now()}`)
  const messagesEndRef = useRef<HTMLDivElement>(null)
  const textareaRef = useRef<HTMLTextAreaElement>(null)

  const scrollToBottom = useCallback(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [])

  useEffect(() => { scrollToBottom() }, [messages, scrollToBottom])

  const resizeTextarea = useCallback(() => {
    const ta = textareaRef.current
    if (!ta) return
    ta.style.height = 'auto'
    ta.style.height = `${Math.min(ta.scrollHeight, 160)}px`
  }, [])

  const sendMessage = useCallback(async (text: string) => {
    const trimmed = text.trim()
    if (!trimmed || loading) return

    const userMsg: Message = { role: 'user', content: trimmed, id: `u-${Date.now()}` }
    setMessages(prev => [...prev, userMsg])
    setInput('')
    if (textareaRef.current) textareaRef.current.style.height = 'auto'
    setLoading(true)

    try {
      const resp = await api.chat(trimmed, sessionId)
      const aiMsg: Message = {
        role: 'assistant',
        content: resp.response,
        id: `a-${Date.now()}`,
      }
      setMessages(prev => [...prev, aiMsg])
    } catch (e: unknown) {
      const errorMsg: Message = {
        role: 'assistant',
        content: `⚠ Unable to reach the intelligence engine. ${e instanceof Error ? e.message : 'Unknown error.'}`,
        id: `err-${Date.now()}`,
      }
      setMessages(prev => [...prev, errorMsg])
    } finally {
      setLoading(false)
    }
  }, [loading, sessionId])

  const handleKeyDown = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault()
      sendMessage(input)
    }
  }

  return (
    <div className="chat-view">
      {/* Header */}
      <div className="page-header">
        <div className="page-date">Intelligence Chat</div>
        <h1 className="page-title">Ask your data anything.</h1>
        <p className="page-subtitle">
          Powered by Claude Sonnet 4.5 · Context from your LinkedIn intelligence
        </p>
      </div>

      {/* Messages */}
      <div className="chat-messages">
        {messages.length === 0 && !loading && (
          <div className="chat-welcome">
            <h2 className="chat-welcome-title">
              Good {getTimeOfDay()},<br />
              <em>what's on your mind?</em>
            </h2>
            <p className="chat-welcome-sub">
              Ask about your career trajectory, network, opportunities, or any
              insight from your LinkedIn intelligence.
            </p>
            <div className="chat-suggestions">
              {SUGGESTIONS.map((s, i) => (
                <button
                  key={i}
                  className="suggestion-chip"
                  onClick={() => sendMessage(s)}
                >
                  {s}
                </button>
              ))}
            </div>
          </div>
        )}

        {messages.map(msg => (
          <div key={msg.id} className={`msg-row ${msg.role}`}>
            <div className={`msg-avatar ${msg.role === 'user' ? 'user-avatar' : 'ai-avatar'}`}>
              {msg.role === 'user' ? 'YOU' : 'AI'}
            </div>
            <div
              className={`msg-bubble ${msg.role === 'user' ? 'user-bubble' : 'ai-bubble'}`}
              style={{ whiteSpace: 'pre-wrap' }}
            >
              {msg.content}
            </div>
          </div>
        ))}

        {loading && (
          <div className="msg-row">
            <div className="msg-avatar ai-avatar">AI</div>
            <div className="msg-bubble ai-bubble">
              <div className="typing-indicator">
                <div className="typing-dot" />
                <div className="typing-dot" />
                <div className="typing-dot" />
              </div>
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* Input */}
      <div className="chat-input-area">
        <div className="chat-input-box">
          <textarea
            ref={textareaRef}
            className="chat-textarea"
            value={input}
            onChange={e => { setInput(e.target.value); resizeTextarea() }}
            onKeyDown={handleKeyDown}
            placeholder="Ask about your career, network, opportunities…"
            rows={1}
            disabled={loading}
          />
          <button
            className="chat-send-btn"
            onClick={() => sendMessage(input)}
            disabled={loading || !input.trim()}
            title="Send (Enter)"
          >
            <SendIcon />
          </button>
        </div>
        <p className="chat-hint">Enter to send · Shift+Enter for new line</p>
      </div>
    </div>
  )
}

function getTimeOfDay(): string {
  const h = new Date().getHours()
  if (h < 12) return 'morning'
  if (h < 18) return 'afternoon'
  return 'evening'
}
