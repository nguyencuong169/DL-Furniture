const apiBaseUrl = (import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328').replace(
  /\/$/,
  ''
)

export interface ProductCategoryResponse {
  id: number
  name: string
  slug: string
  description?: string | null
  imageUrl: string
  imageAlt: string
  displayOrder: number
  productCount: number
}

const fallbackCategories: ProductCategoryResponse[] = [
  {
    id: 1,
    name: 'Phòng Khách',
    slug: 'phong-khach',
    description: 'Không gian tiếp khách cân bằng giữa tỷ lệ, tiện nghi và dấu ấn vật liệu.',
    imageUrl: '/media/gallery/walnut-villa-living.webp',
    imageAlt: 'Phòng khách biệt thự với nội thất gỗ óc chó và cửa kính nhìn ra vườn',
    displayOrder: 1,
    productCount: 0
  },
  {
    id: 2,
    name: 'Phòng Ngủ',
    slug: 'phong-ngu',
    description: 'Không gian nghỉ ngơi ấm áp, riêng tư và phù hợp với nhịp sống của gia chủ.',
    imageUrl: '/media/gallery/villa-bedroom-earth.webp',
    imageAlt: 'Phòng ngủ biệt thự với nội thất gỗ và bảng màu nâu đất',
    displayOrder: 2,
    productCount: 0
  },
  {
    id: 3,
    name: 'Phòng Bếp',
    slug: 'phong-bep',
    description: 'Bếp và bàn ăn được tổ chức liền mạch cho những khoảnh khắc sum họp.',
    imageUrl: '/media/gallery/walnut-villa-kitchen.webp',
    imageAlt: 'Phòng bếp biệt thự với hệ tủ gỗ, đảo đá và bàn ăn',
    displayOrder: 3,
    productCount: 0
  }
]

export async function fetchProductCategories(): Promise<ProductCategoryResponse[]> {
  try {
    const response = await fetch(`${apiBaseUrl}/api/products/categories`, {
      headers: { Accept: 'application/json' }
    })

    if (!response.ok) throw new Error(`Product categories API returned ${response.status}`)

    const categories = (await response.json()) as ProductCategoryResponse[]
    return categories.length > 0 ? categories : fallbackCategories
  } catch {
    return fallbackCategories
  }
}
