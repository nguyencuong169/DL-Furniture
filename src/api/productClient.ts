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

const FALLBACK_PRODUCTS: ProductResponse[] = [
  {
    id: 1,
    categoryId: 1,
    categoryName: 'Phòng Ngủ',
    categorySlug: 'phong-ngu',
    sku: 'G01',
    slug: 'giuong-oc-cho-g01',
    name: 'Giường Óc Chó - G01',
    summary: 'Giường óc chó sang trọng',
    description: 'Mô tả chi tiết Giường Óc Chó - G01',
    price: 11000000,
    currency: 'VND',
    mainImage: '/src/assets/img/rooms/1.jpg',
    images: [
      { id: 1, imageUrl: '/src/assets/img/rooms/1.jpg', caption: 'Giường G01', sortOrder: 1 }
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
    summary: 'Giường óc chó mẫu 2',
    description: 'Mô tả chi tiết G02',
    price: 10700000,
    currency: 'VND',
    mainImage: '/src/assets/img/rooms/2.jpg',
    images: [
      { id: 2, imageUrl: '/src/assets/img/rooms/2.jpg', caption: 'Giường G02', sortOrder: 1 }
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
    summary: 'Giường cao cấp',
    description: 'Mô tả chi tiết G03',
    price: 25000000,
    currency: 'VND',
    mainImage: '/src/assets/img/rooms/3.jpg',
    images: [
      { id: 3, imageUrl: '/src/assets/img/rooms/3.jpg', caption: 'Giường G03', sortOrder: 1 }
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
    summary: 'Tủ gỗ óc chó',
    description: 'Mô tả T01',
    price: 15000000,
    currency: 'VND',
    mainImage: '/src/assets/img/rooms/7.png',
    images: [{ id: 4, imageUrl: '/src/assets/img/rooms/7.png', caption: 'Tủ T01', sortOrder: 1 }]
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

export function getFallbackProducts(query: ProductQuery = {}): ProductResponse[] {
  const category = query.category && query.category !== 'all' ? query.category : null
  return FALLBACK_PRODUCTS.filter((product) => !category || product.categorySlug === category)
}

export function formatPrice(product: ProductResponse): string {
  const value = product.price ?? 0
  const currency = product.currency ?? 'VND'
  const formatted = new Intl.NumberFormat('vi-VN').format(value)
  return `${formatted} ${currency}`
}
