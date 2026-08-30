const API_BASE = import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328'

export type StatId = 'experience' | 'projects' | 'area' | 'satisfaction'

export interface StatResponse {
  id: StatId
  value: number
}

/**
 * Giá trị mặc định (dummy) dùng khi DB chưa có bảng stats / endpoint chưa sẵn sàng.
 * Component homepage chỉ nhận giá trị thật khi real >= fallback
 * (số hiển thị không bao giờ thấp hơn cam kết đã công bố).
 */
export const FALLBACK_STATS: StatResponse[] = [
  { id: 'experience', value: 15 },
  { id: 'projects', value: 320 },
  { id: 'area', value: 12000 },
  { id: 'satisfaction', value: 98 }
]

const VALID_IDS: StatId[] = ['experience', 'projects', 'area', 'satisfaction']

function isStatResponse(item: unknown): item is StatResponse {
  if (typeof item !== 'object' || item === null) return false
  const candidate = item as { id?: unknown; value?: unknown }
  return (
    typeof candidate.id === 'string' &&
    VALID_IDS.includes(candidate.id as StatId) &&
    typeof candidate.value === 'number' &&
    Number.isFinite(candidate.value) &&
    candidate.value >= 0
  )
}

export async function fetchStats(): Promise<StatResponse[]> {
  try {
    const res = await fetch(`${API_BASE}/api/stats`)
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    const data: unknown = await res.json()
    if (!Array.isArray(data)) throw new Error('Invalid stats payload')
    return data.filter(isStatResponse)
  } catch {
    return FALLBACK_STATS
  }
}
