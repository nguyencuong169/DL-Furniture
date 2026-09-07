import { describe, expect, it } from 'vitest'
import { CUNGS, GOOD_SIZES, nearestGoodSize, traCuu } from '../thuocLoBan'

describe('thuocLoBan', () => {
  it('có đúng 8 cung: 4 tốt + 4 xấu', () => {
    expect(CUNGS).toHaveLength(8)
    expect(CUNGS.filter((c) => c.good)).toHaveLength(4)
    expect(CUNGS.filter((c) => !c.good)).toHaveLength(4)
  })

  it('mỗi cung có đúng 4 cung nhỏ', () => {
    for (const cung of CUNGS) {
      expect(cung.subCungs).toHaveLength(4)
    }
  })

  it('traCuu trả về null cho kích thước không hợp lệ', () => {
    expect(traCuu(0)).toBeNull()
    expect(traCuu(-10)).toBeNull()
    expect(traCuu(Number.NaN)).toBeNull()
    expect(traCuu(Number.POSITIVE_INFINITY)).toBeNull()
  })

  // ── Biên cung (52.2cm / 8 = 6.525cm mỗi cung) ──
  it('traCuu 52.2cm → quay về đầu thước (cung Tài)', () => {
    const result = traCuu(52.2)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Tài')
    expect(result?.position).toBeCloseTo(0, 5)
  })

  it('traCuu 6.525cm → cung Bệnh (xấu)', () => {
    const result = traCuu(6.525)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Bệnh')
    expect(result?.cung.good).toBe(false)
  })

  it('traCuu 19.575cm → cung Nghĩa (tốt)', () => {
    const result = traCuu(19.575)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Nghĩa')
    expect(result?.cung.good).toBe(true)
  })

  it('traCuu 26.1cm → cung Quan (tốt)', () => {
    const result = traCuu(26.1)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Quan')
    expect(result?.cung.good).toBe(true)
  })

  it('traCuu 45.675cm → cung Bản (tốt)', () => {
    const result = traCuu(45.675)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Bản')
    expect(result?.cung.good).toBe(true)
  })

  // ── Kích thước thông dụng ──
  it('traCuu 81cm → cung Quan (tốt)', () => {
    const result = traCuu(81)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Quan')
    expect(result?.cung.good).toBe(true)
  })

  it('traCuu 87cm → cung Kiếp (xấu)', () => {
    const result = traCuu(87)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Kiếp')
    expect(result?.cung.good).toBe(false)
  })

  it('traCuu 107cm → cung Tài (tốt)', () => {
    const result = traCuu(107)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Tài')
    expect(result?.cung.good).toBe(true)
  })

  it('traCuu 126cm → cung Nghĩa (tốt)', () => {
    const result = traCuu(126)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Nghĩa')
    expect(result?.cung.good).toBe(true)
  })

  it('traCuu 162cm → cung Tài (tốt)', () => {
    const result = traCuu(162)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Tài')
    expect(result?.cung.good).toBe(true)
  })

  it('traCuu 175cm → cung Ly (xấu)', () => {
    const result = traCuu(175)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Ly')
    expect(result?.cung.good).toBe(false)
  })

  it('traCuu 193cm → cung Kiếp (xấu)', () => {
    const result = traCuu(193)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Kiếp')
    expect(result?.cung.good).toBe(false)
  })

  it('traCuu 215cm → cung Tài (tốt)', () => {
    const result = traCuu(215)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Tài')
    expect(result?.cung.good).toBe(true)
  })

  it('traCuu 231cm → cung Nghĩa (tốt)', () => {
    const result = traCuu(231)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Nghĩa')
    expect(result?.cung.good).toBe(true)
  })

  it('traCuu 247cm → cung Kiếp (xấu)', () => {
    const result = traCuu(247)
    expect(result).not.toBeNull()
    expect(result?.cung.name).toBe('Kiếp')
    expect(result?.cung.good).toBe(false)
  })

  // ── nearestGoodSize ──
  it('nearestGoodSize trả về null cho kích thước không hợp lệ', () => {
    expect(nearestGoodSize(0)).toBeNull()
    expect(nearestGoodSize(-5)).toBeNull()
    expect(nearestGoodSize(Number.NaN)).toBeNull()
  })

  it('nearestGoodSize 87cm → gợi ý kích thước tốt gần nhất', () => {
    const result = nearestGoodSize(87)
    expect(result).not.toBeNull()
    expect(traCuu(result!.size)?.cung.good).toBe(true)
    expect(result!.offset).toBeLessThan(0)
  })

  it('nearestGoodSize 90cm → gợi ý kích thước tốt gần nhất', () => {
    const result = nearestGoodSize(90)
    expect(result).not.toBeNull()
    expect(traCuu(result!.size)?.cung.good).toBe(true)
    expect(result!.offset).toBeLessThan(0)
  })

  it('nearestGoodSize 120cm → gợi ý kích thước tốt gần nhất', () => {
    const result = nearestGoodSize(120)
    expect(result).not.toBeNull()
    expect(traCuu(result!.size)?.cung.good).toBe(true)
    expect(result!.offset).toBeGreaterThan(0)
  })

  it('nearestGoodSize 140cm → gợi ý kích thước tốt gần nhất', () => {
    const result = nearestGoodSize(140)
    expect(result).not.toBeNull()
    expect(traCuu(result!.size)?.cung.good).toBe(true)
    expect(result!.offset).toBeLessThan(0)
  })

  it('GOOD_SIZES có 10 kích thước đẹp thông dụng theo bảng tra cứu truyền thống', () => {
    expect(GOOD_SIZES).toHaveLength(10)
    expect(GOOD_SIZES).toEqual([81, 87, 107, 126, 162, 175, 193, 215, 231, 247])
  })
})