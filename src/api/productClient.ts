const apiBaseUrl = (import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328').replace(
  /\/$/,
  ''
)

export interface ProductResponse {
  id: number
  categoryId?: number | null
  categoryName?: string | null
  categorySlug?: string | null
  sku?: string | null
  slug: string
  name: string
  summary?: string | null
  description?: string | null
  price?: number | null
  currency?: string | null
  mainImage?: string | null
  images: ProductImageResponse[]
}

export interface ProductImageResponse {
  id: number
  imageUrl: string
  caption?: string | null
  sortOrder: number
}

export interface ProductQuery {
  category?: string
  featured?: boolean
}

export interface ProductSpec {
  label: string
  value: string
}

/*
 * Thông số kỹ thuật trình bày theo dạng bảng "khoa học" trên trang chi tiết.
 * DB chưa có cột thông số riêng → giữ ở frontend (key theo slug) để không
 * phải đổi schema; khi cần có thể chuyển thành cột JSON ở products sau.
 */
const PRODUCT_SPECS: Record<string, ProductSpec[]> = {
  'giuong-oc-cho-g01': [
    { label: 'Chất liệu', value: 'Gỗ óc chó Bắc Mỹ (FAS)' },
    { label: 'Kích thước', value: '1800 × 2000 × 1200 mm (W×D×H)' },
    { label: 'Hoàn thiện', value: 'Sơn PU bóng mờ, không mùi' },
    { label: 'Màu sắc', value: 'Nâu óc chó tự nhiên' },
    { label: 'Bảo hành', value: '5 năm phần gỗ & kết cấu' },
    { label: 'Giao hàng', value: '20 – 30 ngày' }
  ],
  'giuong-oc-cho-g02': [
    { label: 'Chất liệu', value: 'Gỗ óc chó Bắc Mỹ' },
    { label: 'Kích thước', value: '1600 × 2000 × 1150 mm (W×D×H)' },
    { label: 'Hoàn thiện', value: 'Sơn PU mờ / dầu tự nhiên' },
    { label: 'Màu sắc', value: 'Nâu óc chó' },
    { label: 'Bảo hành', value: '5 năm' },
    { label: 'Giao hàng', value: '20 – 30 ngày' }
  ],
  'giuong-oc-cho-g03': [
    { label: 'Chất liệu', value: 'Gỗ óc chó cao cấp' },
    { label: 'Kích thước', value: '2000 × 2200 × 1250 mm (W×D×H)' },
    { label: 'Hoàn thiện', value: 'Sơn PU bóng' },
    { label: 'Màu sắc', value: 'Nâu óc chó sẫm' },
    { label: 'Bảo hành', value: '5 năm' },
    { label: 'Giao hàng', value: '25 – 35 ngày' }
  ],
  'tu-oc-cho-t01': [
    { label: 'Chất liệu', value: 'Gỗ óc chó Bắc Mỹ' },
    { label: 'Kích thước', value: '1800 × 450 × 2000 mm (W×D×H)' },
    { label: 'Hoàn thiện', value: 'Sơn PU không mùi' },
    { label: 'Màu sắc', value: 'Nâu óc chó tự nhiên' },
    { label: 'Bảo hành', value: '5 năm' },
    { label: 'Giao hàng', value: '25 – 35 ngày' }
  ]
}

export function getProductSpecs(slug: string): ProductSpec[] {
  return (
    PRODUCT_SPECS[slug] ?? [
      { label: 'Chất liệu', value: 'Gỗ óc chó tự nhiên tuyển chọn' },
      { label: 'Hoàn thiện', value: 'Sơn PU / dầu tự nhiên, không mùi' },
      { label: 'Bảo hành', value: '5 năm phần gỗ & kết cấu' },
      { label: 'Giao hàng', value: '20 – 35 ngày' }
    ]
  )
}

// Điểm chung của mọi sản phẩm D&L (cam kết thương hiệu) — hiển thị theo style
// `.room-facilities` của Cappa trên trang chi tiết.
export const PRODUCT_FEATURES = [
  'Gỗ óc chó tự nhiên tuyển chọn',
  'Sơn PU / dầu tự nhiên, không mùi',
  'Bản lề giảm chấn, ray chịu tải',
  'Bảo hành 5 năm & lắp đặt tận nơi'
]

const FALLBACK_PRODUCTS: ProductResponse[] = [
  {
    id: 1,
    categoryId: 1,
    categoryName: 'Phòng Ngủ',
    categorySlug: 'phong-ngu',
    sku: 'G01',
    slug: 'giuong-oc-cho-g01',
    name: 'Giường Óc Chó - G01',
    summary:
      'Giường gỗ óc chó Bắc Mỹ với đầu giường bọc nệm, kết hợp giữa khối gỗ nguyên tấm và chi tiết vân tự nhiên.',
    description:
      'Giường G01 được chế tác từ gỗ óc chó Bắc Mỹ chuẩn FAS, giữ nguyên vân gỗ tự nhiên và hoàn thiện bằng sơn PU bóng mờ không mùi. Khung giường gia cố thanh giằng chịu lực, đầu giường bọc nệm tạo cảm giác tựa lưng êm ái. Sản phẩm phù hợp cho phòng ngủ master có chiều rộng từ 4 m trở lên.',
    price: 11000000,
    currency: 'VND',
    mainImage: '/media/gallery/villa-bedroom-earth.webp',
    images: [
      { id: 1, imageUrl: '/media/gallery/villa-bedroom-earth.webp', caption: 'Giường G01', sortOrder: 1 },
      { id: 2, imageUrl: '/media/gallery/walnut-suite.jpg', caption: 'Không gian phòng ngủ', sortOrder: 2 },
      { id: 3, imageUrl: '/media/gallery/villa-bedroom-lounge.webp', caption: 'Phòng ngủ lounge', sortOrder: 3 },
      { id: 4, imageUrl: '/media/gallery/walnut-joinery-detail.webp', caption: 'Chi tiết mối ghép', sortOrder: 4 }
    ]
  },
  {
    id: 2,
    categoryId: 1,
    categoryName: 'Phòng Ngủ',
    categorySlug: 'phong-ngu',
    sku: 'G02',
    slug: 'giuong-oc-cho-g02',
    name: 'Giường Óc Chó - G02',
    summary:
      'Thiết kế giường thấp hiện đại, đầu giường liền vách ốp gỗ óc chó, phù hợp phòng ngủ tối giản.',
    description:
      'Giường G02 mang phong cách thấp và tối giản, đầu giường liền vách ốp gỗ óc chó giúp không gian liền mạch. Hệ khung sử dụng ván óc chó dày, được sấy đạt độ ẩm dưới 12% và lắp thử tại xưởng trước khi xuất xưởng. Dễ dàng kết hợp với tủ đầu giường và hệ tủ quần áo đồng bộ.',
    price: 10700000,
    currency: 'VND',
    mainImage: '/media/gallery/walnut-suite.jpg',
    images: [
      { id: 5, imageUrl: '/media/gallery/walnut-suite.jpg', caption: 'Giường G02', sortOrder: 1 },
      { id: 6, imageUrl: '/media/gallery/villa-bedroom-earth.webp', caption: 'Phòng ngủ gỗ óc chó', sortOrder: 2 },
      { id: 7, imageUrl: '/media/gallery/villa-bedroom-desk.webp', caption: 'Bàn làm việc liền phòng', sortOrder: 3 }
    ]
  },
  {
    id: 3,
    categoryId: 1,
    categoryName: 'Phòng Ngủ',
    categorySlug: 'phong-ngu',
    sku: 'G03',
    slug: 'giuong-oc-cho-g03',
    name: 'Giường Óc Chó - G03',
    summary:
      'Giường king-size cao cấp, đầu giường dựng tấm gỗ nguyên khối, điểm nhấn cho phòng ngủ lớn.',
    description:
      'Giường G03 là phiên bản king-size với đầu giường tấm gỗ óc chó nguyên khối, tạo điểm nhấn thị giác mạnh cho phòng ngủ lớn. Các mối ghép được gia công mộng kín, không lộ đinh vít, kết hợp sơn PU bóng để làm nổi bật độ sâu của vân gỗ. Bảo hành kết cấu 5 năm và hỗ trợ đo đạc, lắp đặt tận nơi.',
    price: 25000000,
    currency: 'VND',
    mainImage: '/media/gallery/villa-bedroom-lounge.webp',
    images: [
      { id: 8, imageUrl: '/media/gallery/villa-bedroom-lounge.webp', caption: 'Giường G03', sortOrder: 1 },
      { id: 9, imageUrl: '/media/gallery/villa-bedroom-earth.webp', caption: 'Phòng ngủ đất', sortOrder: 2 },
      { id: 10, imageUrl: '/media/gallery/walnut-suite.jpg', caption: 'Bộ sưu tập phòng ngủ', sortOrder: 3 }
    ]
  },
  {
    id: 4,
    categoryId: 2,
    categoryName: 'Phòng Khách',
    categorySlug: 'phong-khach',
    sku: 'T01',
    slug: 'tu-oc-cho-t01',
    name: 'Tủ Óc Chó - T01',
    summary:
      'Kệ tivi & tủ trưng bày gỗ óc chó cho phòng khách, kết hợp cánh mở lẫn khoang mở để trưng bày đồ.',
    description:
      'Tủ T01 được thiết kế cho phòng khách với sự kết hợp giữa khoang kín (cánh mở bản lề giảm chấn) và khoang mở để trưng bày. Mặt gỗ óc chó được chọn vân liền mạch, hoàn thiện sơn PU không mùi, an toàn cho không gian sinh hoạt. Kích thước có thể điều chỉnh theo hiện trạng tường nhà.',
    price: 15000000,
    currency: 'VND',
    mainImage: '/media/gallery/walnut-home-library.webp',
    images: [
      { id: 11, imageUrl: '/media/gallery/walnut-home-library.webp', caption: 'Tủ T01', sortOrder: 1 },
      { id: 12, imageUrl: '/media/gallery/walnut-villa-living.webp', caption: 'Phòng khách gỗ óc chó', sortOrder: 2 },
      { id: 13, imageUrl: '/media/gallery/arched-dining.jpg', caption: 'Không gian mở', sortOrder: 3 },
      { id: 14, imageUrl: '/media/gallery/quiet-lounge.jpg', caption: 'Khu tiếp khách', sortOrder: 4 }
    ]
  }
]

export async function fetchProducts(query: ProductQuery = {}): Promise<ProductResponse[]> {
  try {
    const params = new URLSearchParams()
    if (query.category && query.category !== 'all') params.set('category', query.category)
    if (query.featured === true) params.set('featured', 'true')

    const queryString = params.toString()
    const res = await fetch(`${apiBaseUrl}/api/products${queryString ? `?${queryString}` : ''}`, {
      headers: { Accept: 'application/json' }
    })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    return (await res.json()) as ProductResponse[]
  } catch {
    return getFallbackProducts(query)
  }
}

export async function fetchProductById(id: number): Promise<ProductResponse | null> {
  try {
    const res = await fetch(`${apiBaseUrl}/api/products/${id}`, {
      headers: { Accept: 'application/json' }
    })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    return (await res.json()) as ProductResponse
  } catch {
    return getFallbackProducts({}).find((product) => product.id === id) ?? null
  }
}

/** Resolve sản phẩm theo slug SEO (/san-pham/:slug) — chấp nhận cả id dạng số
 * (tương thích URL cũ /san-pham/detail/12). API lỗi → fallback data. */
export async function fetchProductBySlug(slugOrId: string): Promise<ProductResponse | null> {
  if (/^\d+$/.test(slugOrId)) return fetchProductById(Number(slugOrId))
  try {
    const res = await fetch(`${apiBaseUrl}/api/products`, {
      headers: { Accept: 'application/json' }
    })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    const products = (await res.json()) as ProductResponse[]
    return products.find((product) => product.slug === slugOrId) ?? null
  } catch {
    return FALLBACK_PRODUCTS.find((product) => product.slug === slugOrId) ?? null
  }
}

export function getFallbackProducts(query: ProductQuery = {}): ProductResponse[] {
  const category = query.category && query.category !== 'all' ? query.category : null
  return FALLBACK_PRODUCTS.filter((product) => !category || product.categorySlug === category)
}

/** Lấy sản phẩm liên quan cùng danh mục (loại trừ sản phẩm hiện tại). */
export async function fetchRelatedProducts(
  product: ProductResponse,
  limit = 4
): Promise<ProductResponse[]> {
  const all = await fetchProducts(
    product.categorySlug ? { category: product.categorySlug } : {}
  )
  return all.filter((p) => p.id !== product.id).slice(0, limit)
}

export function formatPrice(product: ProductResponse): string {
  const value = product.price ?? 0
  if (!value || value <= 0) return 'Liên hệ'
  const currency = product.currency ?? 'VND'
  const formatted = new Intl.NumberFormat('vi-VN').format(value)
  return `${formatted} ${currency}`
}
