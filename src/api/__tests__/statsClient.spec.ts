import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'

import { FALLBACK_STATS, fetchStats, type StatResponse, type StatId } from '../statsClient'

describe('statsClient', () => {
  describe('types and constants', () => {
    describe('FALLBACK_STATS', () => {
      it('contains exactly 4 stat items', () => {
        expect(FALLBACK_STATS).toHaveLength(4)
      })

      it('contains the experience stat with value 15', () => {
        const stat = FALLBACK_STATS.find((s) => s.id === 'experience')
        expect(stat).toBeDefined()
        expect(stat).toEqual({ id: 'experience', value: 15 })
      })

      it('contains the projects stat with value 320', () => {
        const stat = FALLBACK_STATS.find((s) => s.id === 'projects')
        expect(stat).toBeDefined()
        expect(stat).toEqual({ id: 'projects', value: 320 })
      })

      it('contains the area stat with value 12000', () => {
        const stat = FALLBACK_STATS.find((s) => s.id === 'area')
        expect(stat).toBeDefined()
        expect(stat).toEqual({ id: 'area', value: 12000 })
      })

      it('contains the satisfaction stat with value 98', () => {
        const stat = FALLBACK_STATS.find((s) => s.id === 'satisfaction')
        expect(stat).toBeDefined()
        expect(stat).toEqual({ id: 'satisfaction', value: 98 })
      })

      it('has stat IDs that match the StatId type values', () => {
        const expectedIds: StatId[] = ['experience', 'projects', 'area', 'satisfaction']
        const actualIds = FALLBACK_STATS.map((s) => s.id)
        expect(actualIds.sort()).toEqual([...expectedIds].sort())
      })

      it('has all values as finite non-negative numbers', () => {
        FALLBACK_STATS.forEach((stat) => {
          expect(typeof stat.value).toBe('number')
          expect(Number.isFinite(stat.value)).toBe(true)
                    expect(stat.value).toBeGreaterThanOrEqual(0)
        })
      })

      it('has all IDs as non-empty strings', () => {
        FALLBACK_STATS.forEach((stat) => {
          expect(typeof stat.id).toBe('string')
          expect(stat.id).toBeTruthy()
        })
      })
    })
  })

  describe('fetchStats', () => {
    let mockFetch: ReturnType<typeof vi.fn>
    const originalFetch = globalThis.fetch

    beforeEach(() => {
      mockFetch = vi.fn()
      vi.stubGlobal('fetch', mockFetch)
    })

    afterEach(() => {
      vi.unstubAllGlobals()
      if (originalFetch !== undefined) {
        vi.stubGlobal('fetch', originalFetch)
      }
    })

    it('fetches from the correct API endpoint', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => []
      } as unknown as Response)

      await fetchStats()

      expect(mockFetch).toHaveBeenCalledTimes(1)
      expect(mockFetch).toHaveBeenCalledWith('https://localhost:44328/api/stats')
    })

    it('returns real stats from API on successful response', async () => {
      const apiStats: StatResponse[] = [
        { id: 'experience', value: 20 },
        { id: 'projects', value: 500 },
        { id: 'area', value: 15000 },
        { id: 'satisfaction', value: 99 }
      ]
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => apiStats
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual(apiStats)
    })

    it('returns a partial set of stats when API returns only some', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => [{ id: 'experience', value: 25 }]
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual([{ id: 'experience', value: 25 }])
    })

    it('falls back to FALLBACK_STATS on HTTP 500 error', async () => {
      mockFetch.mockResolvedValue({
        ok: false,
        status: 500
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual(FALLBACK_STATS)
    })

    it('falls back to FALLBACK_STATS on HTTP 404 error', async () => {
      mockFetch.mockResolvedValue({
        ok: false,
        status: 404
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual(FALLBACK_STATS)
    })

    it('falls back to FALLBACK_STATS on HTTP 503 error', async () => {
      mockFetch.mockResolvedValue({
        ok: false,
        status: 503
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual(FALLBACK_STATS)
    })

    it('falls back to FALLBACK_STATS on network error', async () => {
      mockFetch.mockRejectedValue(new Error('NetworkError: Failed to fetch'))

      const result = await fetchStats()
      expect(result).toEqual(FALLBACK_STATS)
    })

    it('falls back to FALLBACK_STATS when fetch throws TypeError', async () => {
      mockFetch.mockRejectedValue(new TypeError('Failed to fetch'))

      const result = await fetchStats()
      expect(result).toEqual(FALLBACK_STATS)
    })

    it('falls back to FALLBACK_STATS on non-array JSON response (object)', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => ({ message: 'not an array' })
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual(FALLBACK_STATS)
    })

    it('falls back to FALLBACK_STATS on non-array JSON response (string)', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => 'just a string'
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual(FALLBACK_STATS)
    })

    it('falls back to FALLBACK_STATS on non-array JSON response (number)', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => 42
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual(FALLBACK_STATS)
    })

    it('falls back to FALLBACK_STATS on null JSON response', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => null
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual(FALLBACK_STATS)
    })

    it('filters out invalid items from a valid response array', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => [
          { id: 'experience', value: 20 },
          { id: 'invalid_id', value: 100 },
          { id: 'projects', value: 'not-a-number' },
          { id: 'area', value: NaN },
          { id: 'area', value: 15000 },
          { id: 'satisfaction' },
          { id: 'satisfaction', value: null },
          { id: 'satisfaction', value: 99 },
          null,
          undefined,
          'string-item',
          42,
          { not: 'a stat' }
        ]
      } as unknown as Response)

      const result = await fetchStats()

      expect(result).toHaveLength(3)
      expect(result).toContainEqual({ id: 'experience', value: 20 })
      expect(result).toContainEqual({ id: 'area', value: 15000 })
      expect(result).toContainEqual({ id: 'satisfaction', value: 99 })
    })

    it('returns an empty array when API returns valid but empty array', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => []
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual([])
    })

    it('validates that stat.id must be a string', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => [
          { id: 123, value: 20 },
          { id: 'experience', value: 20 }
        ]
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual([{ id: 'experience', value: 20 }])
    })

    it('validates that stat.value must be a finite number', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => [
          { id: 'experience', value: Infinity },
          { id: 'experience', value: -5 },
          { id: 'experience', value: 15 }
        ]
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual([{ id: 'experience', value: 15 }])
    })

    it('accepts stat with value 0 as valid', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => [{ id: 'experience', value: 0 }]
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual([{ id: 'experience', value: 0 }])
    })

    it('rejects stat with Infinity as value (not finite)', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => [{ id: 'experience', value: Infinity }]
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual([])
    })

    it('preserves the order of valid items from the response', async () => {
      const responseData: StatResponse[] = [
        { id: 'satisfaction', value: 95 },
        { id: 'experience', value: 18 },
        { id: 'area', value: 11000 },
        { id: 'projects', value: 280 }
      ]
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => responseData
      } as unknown as Response)

      const result = await fetchStats()
      expect(result.map((s) => s.id)).toEqual(['satisfaction', 'experience', 'area', 'projects'])
    })

    it('falls back to FALLBACK_STATS when JSON.parse throws SyntaxError', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => {
          throw new SyntaxError('Unexpected token in JSON')
        }
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual(FALLBACK_STATS)
    })

    it('falls back to FALLBACK_STATS when json throws a generic Error', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => {
          throw new Error('Unexpected end of JSON input')
        }
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual(FALLBACK_STATS)
    })

    it('keeps both items when duplicate IDs are valid (filter does not dedupe)', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => [
          { id: 'experience', value: 20 },
          { id: 'experience', value: 30 }
        ]
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toHaveLength(2)
      expect(result[0]).toEqual({ id: 'experience', value: 20 })
      expect(result[1]).toEqual({ id: 'experience', value: 30 })
    })

    it('accepts stat objects with extra properties', async () => {
      mockFetch.mockResolvedValue({
        ok: true,
        status: 200,
        json: async () => [
          { id: 'experience', value: 20, extra: 'ignored', timestamp: '2024-01-01' }
        ]
      } as unknown as Response)

      const result = await fetchStats()
      expect(result).toEqual([
        { id: 'experience', value: 20, extra: 'ignored', timestamp: '2024-01-01' }
      ])
    })
  })
})
