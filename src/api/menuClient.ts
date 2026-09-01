const API_BASE = import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328'

export interface MenuLink {
  label: string
  url: string
  children?: MenuLink[]
}

export interface MenuResponse {
  primary: MenuLink[]
  consultation: { label: string; url: string }
  footer: MenuLink[]
}

/**
 * Menu mặc định (dummy) dùng khi API chưa sẵn sàng —
 * giữ nguyên cấu trúc navbar/footer hiện tại để site không bao giờ trống menu.
 */

export const FALLBACK_MENU: MenuResponse = {
  primary: [
    { label: 'Trang chủ', url: '/' },
    { label: 'Giới thiệu', url: '/gioi-thieu' },
    {
      label: 'Sản phẩm',
      url: '/san-pham',
      children: [
        {
          label: 'Phòng khách',
          url: '/san-pham/phong-khach',
          children: [
            { label: 'Sofa gỗ', url: '/san-pham/phong-khach/sofa' },
            { label: 'Bàn trà', url: '/san-pham/phong-khach/ban-tra' },
            { label: 'Kệ ti vi', url: '/san-pham/phong-khach/ke-ti-vi' }
          ]
        },
        {
          label: 'Phòng ngủ',
          url: '/san-pham/phong-ngu',
          children: [
            { label: 'Giường ngủ', url: '/san-pham/phong-ngu/giuong-ngu' },
            { label: 'Tủ quần áo', url: '/san-pham/phong-ngu/tu-quan-ao' },
            { label: 'Kệ trang điểm', url: '/san-pham/phong-ngu/ke-trang-diem' }
          ]
        },
        {
          label: 'Phòng bếp',
          url: '/san-pham/phong-bep',
          children: [
            { label: 'Bàn ăn', url: '/san-pham/phong-bep/ban-an' },
            { label: 'Tủ bếp', url: '/san-pham/phong-bep/tu-bep' }
          ]
        }
      ]
    },
    { label: 'Dự án', url: '/du-an' },
    { label: 'Thư viện', url: '/thu-vien' },
    { label: 'Tin tức', url: '/tin-tuc' },
    { label: 'Liên hệ', url: '/lien-he' }
  ],
  consultation: { label: 'Đặt lịch tư vấn', url: '/#consultation' },
  footer: [
    { label: 'Trang chủ', url: '/' },
    { label: 'Giới thiệu', url: '/gioi-thieu' },
    { label: 'Sản phẩm', url: '/san-pham' },
    { label: 'Dự án', url: '/du-an' },
    { label: 'Liên hệ', url: '/lien-he' },
    { label: 'Câu hỏi thường gặp', url: '/lien-he#faq' }
  ]
}

function isMenuLink(item: unknown): item is MenuLink {
  if (typeof item !== 'object' || item === null) return false
  const candidate = item as { label?: unknown; url?: unknown }
  return typeof candidate.label === 'string' && typeof candidate.url === 'string'
}

function isMenuResponse(data: unknown): data is MenuResponse {
  if (typeof data !== 'object' || data === null) return false
  const candidate = data as {
    primary?: unknown
    consultation?: unknown
    footer?: unknown
  }
  return (
    Array.isArray(candidate.primary) &&
    candidate.primary.every(isMenuLink) &&
    typeof candidate.consultation === 'object' &&
    candidate.consultation !== null &&
    typeof (candidate.consultation as { label?: unknown }).label === 'string' &&
    typeof (candidate.consultation as { url?: unknown }).url === 'string' &&
    Array.isArray(candidate.footer) &&
    candidate.footer.every(isMenuLink)
  )
}

export async function fetchMenus(): Promise<MenuResponse> {
  try {
    const res = await fetch(`${API_BASE}/api/menus`)
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    const data: unknown = await res.json()
    if (!isMenuResponse(data)) throw new Error('Invalid menus payload')
    return data
  } catch {
    return FALLBACK_MENU
  }
}
