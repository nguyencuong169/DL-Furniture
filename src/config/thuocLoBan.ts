/**
 * THƯỚC LỖ BAN — tra cứu phong thủy kích thước nội thất.
 * Dùng thước 52.2cm (dương trạch — dùng cho cửa, nội thất, đồ đạc).
 *
 * Cách tra cứu thực tế: thước 52.2cm chia 8 cung, mỗi cung 6.525cm.
 * Vị trí trên thước = (kích thước % 52.2). Cung = floor(vị trí / 6.525).
 *
 * LƯU Ý QUAN TRỌNG: Các kích thước đẹp truyền thống (81, 87, 107, 126...)
 * được xác định theo BẢNG TRA CỨU của các thầy phong thủy — không phải
 * công thức toán học đơn giản. Vì vậy GOOD_SIZES là danh sách tĩnh đã
 * được xác nhận, không sinh ra từ công thức.
 */

export interface Cung {
  name: string
  good: boolean
  meaning: string
  subCungs: string[]
}

export const CUNGS: Cung[] = [
  {
    name: 'Tài',
    good: true,
    meaning: 'Tài lộc, phú quý, thịnh vượng',
    subCungs: ['Tài Tinh', 'Tài Vượng', 'Tài Nghĩa', 'Tài Quan']
  },
  {
    name: 'Bệnh',
    good: false,
    meaning: 'Bệnh tật, ốm đau, hao tổn sức khỏe',
    subCungs: ['Bệnh Khổ', 'Bệnh Tử', 'Bệnh Hại', 'Bệnh Vong']
  },
  {
    name: 'Ly',
    good: false,
    meaning: 'Ly tán, chia lìa, mất mát',
    subCungs: ['Ly Tán', 'Ly Biệt', 'Ly Thất', 'Ly Tài']
  },
  {
    name: 'Nghĩa',
    good: true,
    meaning: 'Nghĩa khí, tình nghĩa, lợi ích',
    subCungs: ['Nghĩa Tinh', 'Nghĩa Vượng', 'Nghĩa Lợi', 'Nghĩa Quan']
  },
  {
    name: 'Quan',
    good: true,
    meaning: 'Quan lộc, thăng tiến, danh vọng',
    subCungs: ['Quan Tinh', 'Quan Vượng', 'Quan Nghĩa', 'Quan Lợi']
  },
  {
    name: 'Kiếp',
    good: false,
    meaning: 'Kiếp nạn, hao tài, tổn thất',
    subCungs: ['Kiếp Tài', 'Kiếp Bại', 'Kiếp Tử', 'Kiếp Vong']
  },
  {
    name: 'Hại',
    good: false,
    meaning: 'Tai hại, xung khắc, bất lợi',
    subCungs: ['Hại Tinh', 'Hại Vượng', 'Hại Tài', 'Hại Tử']
  },
  {
    name: 'Bản',
    good: true,
    meaning: 'Bản lĩnh, vững vàng, an cư',
    subCungs: ['Bản Tinh', 'Bản Vượng', 'Bản Nghĩa', 'Bản Quan']
  }
]

export const CUNG_SIZE = 52.2 / 8 // 6.525cm mỗi cung
export const SUB_CUNG_SIZE = CUNG_SIZE / 4 // 1.63125cm mỗi cung nhỏ

export interface ThuocLoBanResult {
  cung: Cung
  subCung: string
  position: number
  size: number
}

/** Tra cứu kích thước (cm) → cung + cung nhỏ + vị trí trên thước */
export function traCuu(size: number): ThuocLoBanResult | null {
  if (!Number.isFinite(size) || size <= 0) return null

  const position = ((size % 52.2) + 52.2) % 52.2
  // Epsilon chống floating-point error (vd: 6.525/6.525 = 0.9999... → cung 0)
  const cungIndex = Math.min(7, Math.floor(position / CUNG_SIZE + 1e-9))
  const subIndex = Math.min(3, Math.floor((position % CUNG_SIZE) / SUB_CUNG_SIZE + 1e-9))
  const cung = CUNGS[cungIndex]

  return {
    cung,
    subCung: cung.subCungs[subIndex],
    position,
    size
  }
}

/** Tìm kích thước tốt gần nhất (trong khoảng ±52.2cm) */
export function nearestGoodSize(size: number): { size: number; offset: number } | null {
  if (!Number.isFinite(size) || size <= 0) return null

  for (let offset = 0; offset <= 52.2; offset += 0.01) {
    for (const sign of [1, -1]) {
      const candidate = size + sign * offset
      if (candidate <= 0) continue
      const result = traCuu(candidate)
      if (result?.cung.good) {
        return { size: candidate, offset: sign * offset }
      }
    }
  }
  return null
}

/**
 * Các kích thước đẹp thông dụng (cm) cho cửa, tủ, giường...
 * Được xác nhận theo bảng tra cứu thước lỗ ban phổ biến tại Việt Nam.
 * Đây là danh sách TĨNH — không sinh từ công thức, vì bảng tra cứu
 * truyền thống có các khoảng cung không đều nhau.
 */
export const GOOD_SIZES = [81, 87, 107, 126, 162, 175, 193, 215, 231, 247]