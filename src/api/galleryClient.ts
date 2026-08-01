import type {
  GalleryCategory,
  GalleryItem,
  GalleryMediaType,
  GalleryQuery,
  GalleryResponse
} from '../types/gallery'

const apiBaseUrl = (import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328').replace(/\/$/, '')

const fallbackItems: GalleryItem[] = [
  {
    id: 1,
    title: 'Walnut Villa — Phòng khách nhiệt đới',
    description: 'Không gian sinh hoạt mở với sofa, bàn trà và ghế thư giãn chế tác từ gỗ óc chó.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/walnut-villa-living.webp',
    thumbnailUrl: '/media/gallery/walnut-villa-living.webp',
    altText: 'Phòng khách biệt thự với nội thất gỗ óc chó và cửa kính nhìn ra vườn',
    provider: 'local',
    isFeatured: true,
    categoryName: 'Phòng khách',
    categorySlug: 'phong-khach',
    projectId: 1,
    projectTitle: 'Thiết kế nội thất Saroma Villa'
  },
  {
    id: 2,
    title: 'Bếp mở trong ánh sáng tự nhiên',
    description: 'Hệ tủ bếp và bàn ăn đồng bộ, cân bằng giữa vân gỗ ấm và đá tự nhiên.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/walnut-villa-kitchen.webp',
    thumbnailUrl: '/media/gallery/walnut-villa-kitchen.webp',
    altText: 'Bếp biệt thự với tủ gỗ óc chó, đảo đá và bàn ăn sáu ghế',
    provider: 'local',
    isFeatured: true,
    categoryName: 'Phòng bếp',
    categorySlug: 'phong-bep',
    projectId: 1,
    projectTitle: 'Thiết kế nội thất Saroma Villa'
  },
  {
    id: 3,
    title: 'Phòng ngủ Walnut Suite',
    description: 'Bảng màu trầm, hệ giường liền bàn và ánh sáng điểm tạo cảm giác riêng tư.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/walnut-suite.jpg',
    thumbnailUrl: '/media/gallery/walnut-suite.jpg',
    altText: 'Phòng ngủ tông trầm với giường và bàn làm việc gỗ óc chó',
    provider: 'local',
    isFeatured: false,
    categoryName: 'Phòng ngủ',
    categorySlug: 'phong-ngu',
    projectId: 2,
    projectTitle: 'Thiết kế nội thất biệt thự Vinhomes Grand Park'
  },
  {
    id: 4,
    title: 'Điểm chạm thủ công',
    description: 'Từng đường cong của ghế được hoàn thiện bằng tay để giữ trọn biểu cảm của gỗ.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/artisan-walnut-chair.webp',
    thumbnailUrl: '/media/gallery/artisan-walnut-chair.webp',
    altText: 'Nghệ nhân hoàn thiện thủ công một chi tiết ghế bằng gỗ óc chó',
    provider: 'local',
    isFeatured: false,
    categoryName: 'Xưởng chế tác',
    categorySlug: 'xuong-che-tac'
  },
  {
    id: 5,
    title: 'Sảnh nghỉ tĩnh lặng',
    description: 'Đường nét Á Đông tối giản kết hợp bề mặt gỗ tự nhiên và vật liệu đan.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/quiet-lounge.jpg',
    thumbnailUrl: '/media/gallery/quiet-lounge.jpg',
    altText: 'Sảnh nghỉ tối giản với tủ console gỗ và mảng trang trí thủ công',
    provider: 'local',
    isFeatured: false,
    categoryName: 'Phòng khách',
    categorySlug: 'phong-khach',
    projectId: 3,
    projectTitle: 'Thiết kế nội thất biệt thự KĐT Vĩnh Yên'
  },
  {
    id: 6,
    title: 'Dining Hall — Ánh sáng và chất liệu',
    description: 'Không gian bàn ăn dài với nhịp vòm, ánh sáng ấm và bảng màu đất.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/arched-dining.jpg',
    thumbnailUrl: '/media/gallery/arched-dining.jpg',
    altText: 'Không gian bàn ăn dài dưới trần vòm với đèn thủ công',
    provider: 'local',
    isFeatured: false,
    categoryName: 'Phòng bếp',
    categorySlug: 'phong-bep',
    projectId: 3,
    projectTitle: 'Thiết kế nội thất biệt thự KĐT Vĩnh Yên'
  },
  {
    id: 7,
    title: 'The Art of Furniture Making',
    description: 'Góc nhìn sâu vào hành trình biến vật liệu thô thành đồ nội thất có tuổi thọ lâu dài.',
    mediaType: 'video',
    mediaUrl: 'https://vimeo.com/573906036',
    thumbnailUrl: '/media/gallery/artisan-walnut-chair.webp',
    altText: 'Video về nghệ thuật chế tác nội thất thủ công',
    provider: 'vimeo',
    duration: '04:18',
    isFeatured: true,
    categoryName: 'Xưởng chế tác',
    categorySlug: 'xuong-che-tac'
  },
  {
    id: 8,
    title: 'Nghệ thuật của kỹ thuật ghép mộng',
    description: 'Độ chính xác, độ bền và thẩm mỹ gặp nhau trong từng mối ghép.',
    mediaType: 'video',
    mediaUrl: 'https://vimeo.com/174156297',
    thumbnailUrl: '/media/gallery/walnut-joinery-detail.webp',
    altText: 'Video về kỹ thuật ghép mộng trong nội thất gỗ',
    provider: 'vimeo',
    duration: '02:42',
    isFeatured: false,
    categoryName: 'Xưởng chế tác',
    categorySlug: 'xuong-che-tac'
  },
  {
    id: 9,
    title: 'Từ nhà thiết kế đến người hoàn thiện',
    description: 'Hành trình hợp tác giữa thiết kế, chế tác và hoàn thiện một không gian sống độc bản.',
    mediaType: 'video',
    mediaUrl: 'https://vimeo.com/82229898',
    thumbnailUrl: '/media/gallery/walnut-villa-living.webp',
    altText: 'Video về quy trình thiết kế và hoàn thiện nội thất',
    provider: 'vimeo',
    duration: '06:34',
    isFeatured: false,
    categoryName: 'Dự án',
    categorySlug: 'du-an',
    projectId: 1,
    projectTitle: 'Thiết kế nội thất Saroma Villa'
  },
  {
    id: 10,
    title: 'Di sản của gỗ óc chó',
    description: 'Câu chuyện vật liệu, tỷ lệ và ngôn ngữ thiết kế làm nên sức sống bền bỉ của walnut.',
    mediaType: 'video',
    mediaUrl: 'https://vimeo.com/340431711',
    thumbnailUrl: '/media/gallery/walnut-suite.jpg',
    altText: 'Video kể câu chuyện về nội thất gỗ óc chó',
    provider: 'vimeo',
    duration: '03:56',
    isFeatured: false,
    categoryName: 'Vật liệu',
    categorySlug: 'vat-lieu'
  },
  {
    id: 11,
    title: 'Thư phòng Walnut Library',
    description: 'Hệ tủ sách cao kịch trần, bàn làm việc điêu khắc và ghế da trong ánh sáng dịu.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/walnut-home-library.webp',
    thumbnailUrl: '/media/gallery/walnut-home-library.webp',
    altText: 'Thư phòng biệt thự với hệ tủ sách gỗ óc chó và bàn làm việc',
    provider: 'local',
    isFeatured: true,
    categoryName: 'Phòng khách',
    categorySlug: 'phong-khach',
    projectId: 1,
    projectTitle: 'Thiết kế nội thất Saroma Villa'
  },
  {
    id: 12,
    title: 'Phòng tắm Walnut & Limestone',
    description: 'Gỗ óc chó, đá limestone và ánh sáng gián tiếp tạo nên nhịp nghỉ thư thái.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/walnut-stone-bathroom.webp',
    thumbnailUrl: '/media/gallery/walnut-stone-bathroom.webp',
    altText: 'Phòng tắm cao cấp với tủ lavabo gỗ óc chó và bồn tắm đá',
    provider: 'local',
    isFeatured: true,
    categoryName: 'Dự án',
    categorySlug: 'du-an',
    projectId: 1,
    projectTitle: 'Thiết kế nội thất Saroma Villa'
  },
  {
    id: 13,
    title: 'Mối ghép lưu dấu bàn tay',
    description: 'Chi tiết mộng gỗ được căn chỉnh và hoàn thiện thủ công tại xưởng.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/walnut-joinery-detail.webp',
    thumbnailUrl: '/media/gallery/walnut-joinery-detail.webp',
    altText: 'Đôi tay người thợ đang hoàn thiện mối ghép gỗ óc chó',
    provider: 'local',
    isFeatured: false,
    categoryName: 'Xưởng chế tác',
    categorySlug: 'xuong-che-tac'
  },
  {
    id: 14,
    title: 'Bức tường nghệ thuật trong ánh nắng sớm',
    description: 'Một khoảng chuyển tiếp được tiết chế bằng tranh sơn mài, bình gốm và gỗ tối màu.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/villa-art-wall.webp',
    thumbnailUrl: '/media/gallery/villa-art-wall.webp',
    altText: 'Bức tường nghệ thuật và tủ gỗ trong không gian biệt thự',
    provider: 'local',
    isFeatured: false,
    categoryName: 'Vật liệu',
    categorySlug: 'vat-lieu',
    projectId: 3,
    projectTitle: 'Thiết kế nội thất biệt thự KĐT Vĩnh Yên'
  },
  {
    id: 15,
    title: 'Phòng ngủ sắc đất',
    description: 'Bảng màu nâu đất, vải dệt thô và bề mặt gỗ tạo cảm giác ấm, sâu và yên tĩnh.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/villa-bedroom-earth.webp',
    thumbnailUrl: '/media/gallery/villa-bedroom-earth.webp',
    altText: 'Phòng ngủ biệt thự mang bảng màu nâu đất',
    provider: 'local',
    isFeatured: false,
    categoryName: 'Phòng ngủ',
    categorySlug: 'phong-ngu',
    projectId: 2,
    projectTitle: 'Thiết kế nội thất biệt thự Vinhomes Grand Park'
  },
  {
    id: 16,
    title: 'Bedroom Lounge — Khoảng nghỉ riêng',
    description: 'Khu ngồi thư giãn được nối liền với phòng ngủ bằng cùng một ngôn ngữ vật liệu.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/villa-bedroom-lounge.webp',
    thumbnailUrl: '/media/gallery/villa-bedroom-lounge.webp',
    altText: 'Phòng ngủ có khu ghế nghỉ và cửa kính lớn',
    provider: 'local',
    isFeatured: false,
    categoryName: 'Phòng ngủ',
    categorySlug: 'phong-ngu',
    projectId: 2,
    projectTitle: 'Thiết kế nội thất biệt thự Vinhomes Grand Park'
  },
  {
    id: 17,
    title: 'Góc làm việc trong phòng ngủ',
    description: 'Bàn viết gọn, ánh sáng tập trung và hệ tủ liền khối cho căn hộ đô thị.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/villa-bedroom-desk.webp',
    thumbnailUrl: '/media/gallery/villa-bedroom-desk.webp',
    altText: 'Góc làm việc bằng gỗ trong phòng ngủ căn hộ',
    provider: 'local',
    isFeatured: false,
    categoryName: 'Phòng ngủ',
    categorySlug: 'phong-ngu',
    projectId: 4,
    projectTitle: 'Thiết kế nội thất căn hộ Vinhomes Metropolis'
  },
  {
    id: 18,
    title: 'Bếp gỗ và mây đan',
    description: 'Các bề mặt cứng được làm mềm bằng cánh tủ mây đan và sắc gỗ tự nhiên.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/villa-kitchen-rattan.webp',
    thumbnailUrl: '/media/gallery/villa-kitchen-rattan.webp',
    altText: 'Tủ bếp gỗ kết hợp cánh mây đan',
    provider: 'local',
    isFeatured: false,
    categoryName: 'Phòng bếp',
    categorySlug: 'phong-bep',
    projectId: 4,
    projectTitle: 'Thiết kế nội thất căn hộ Vinhomes Metropolis'
  },
  {
    id: 19,
    title: 'Vanity Stone — Đá và gỗ',
    description: 'Bàn lavabo gỗ đặt trong lớp nền đá sáng, giữ tinh thần tối giản và sang trọng.',
    mediaType: 'image',
    mediaUrl: '/media/gallery/villa-vanity-stone.webp',
    thumbnailUrl: '/media/gallery/villa-vanity-stone.webp',
    altText: 'Bàn lavabo gỗ trong phòng tắm ốp đá sáng',
    provider: 'local',
    isFeatured: false,
    categoryName: 'Vật liệu',
    categorySlug: 'vat-lieu',
    projectId: 4,
    projectTitle: 'Thiết kế nội thất căn hộ Vinhomes Metropolis'
  },
  {
    id: 20,
    title: 'Thiết kế ghế như một tác phẩm',
    description: 'Từ phác thảo, tạo dáng đến bọc hoàn thiện một mẫu ghế có cá tính riêng.',
    mediaType: 'video',
    mediaUrl: 'https://vimeo.com/213826087',
    thumbnailUrl: '/media/gallery/villa-bedroom-lounge.webp',
    altText: 'Video về thiết kế và chế tác ghế thủ công',
    provider: 'vimeo',
    duration: '03:28',
    isFeatured: false,
    categoryName: 'Xưởng chế tác',
    categorySlug: 'xuong-che-tac'
  },
  {
    id: 21,
    title: 'Process — Nhịp điệu của người thợ',
    description: 'Một thước phim chậm về triết lý, độ chính xác và niềm vui trong nghề mộc.',
    mediaType: 'video',
    mediaUrl: 'https://vimeo.com/247657353',
    thumbnailUrl: '/media/gallery/walnut-joinery-detail.webp',
    altText: 'Video ghi lại quy trình làm đồ gỗ thủ công',
    provider: 'vimeo',
    duration: '05:12',
    isFeatured: true,
    categoryName: 'Xưởng chế tác',
    categorySlug: 'xuong-che-tac'
  },
  {
    id: 22,
    title: 'Biểu tượng ghế trong không gian sống',
    description: 'Hình khối, vật liệu và tỷ lệ biến một chiếc ghế thành điểm nhấn của căn phòng.',
    mediaType: 'video',
    mediaUrl: 'https://vimeo.com/748153633',
    thumbnailUrl: '/media/gallery/walnut-home-library.webp',
    altText: 'Video giới thiệu thiết kế ghế mang tính biểu tượng',
    provider: 'vimeo',
    duration: '01:46',
    isFeatured: false,
    categoryName: 'Vật liệu',
    categorySlug: 'vat-lieu',
    projectId: 2,
    projectTitle: 'Thiết kế nội thất biệt thự Vinhomes Grand Park'
  },
  {
    id: 23,
    title: 'Không gian linh hoạt cho căn hộ đô thị',
    description: 'Cách tư duy nội thất thông minh giúp một diện tích gọn vẫn giàu trải nghiệm.',
    mediaType: 'video',
    mediaUrl: 'https://vimeo.com/383115350',
    thumbnailUrl: '/media/gallery/villa-bedroom-desk.webp',
    altText: 'Video về giải pháp nội thất linh hoạt cho căn hộ',
    provider: 'vimeo',
    duration: '03:08',
    isFeatured: false,
    categoryName: 'Dự án',
    categorySlug: 'du-an',
    projectId: 4,
    projectTitle: 'Thiết kế nội thất căn hộ Vinhomes Metropolis'
  }
]

function buildCategories(items: GalleryItem[]): GalleryCategory[] {
  const counts = new Map<string, GalleryCategory>()
  for (const item of items) {
    const current = counts.get(item.categorySlug)
    if (current) current.itemCount += 1
    else {
      counts.set(item.categorySlug, {
        id: counts.size + 1,
        name: item.categoryName,
        slug: item.categorySlug,
        itemCount: 1
      })
    }
  }
  return Array.from(counts.values())
}

export async function getGallery(query: GalleryQuery = {}): Promise<GalleryResponse> {
  const params = new URLSearchParams()
  if (query.type && query.type !== 'all') params.set('type', query.type)
  if (query.category && query.category !== 'all') params.set('category', query.category)
  if (query.search?.trim()) params.set('search', query.search.trim())
  params.set('page', String(query.page ?? 1))
  params.set('pageSize', String(query.pageSize ?? 9))

  const response = await fetch(`${apiBaseUrl}/api/gallery?${params.toString()}`, {
    headers: { Accept: 'application/json' }
  })

  if (!response.ok) throw new Error(`Gallery API returned ${response.status}`)
  return (await response.json()) as GalleryResponse
}

export function getFallbackGallery(query: GalleryQuery = {}): GalleryResponse {
  const normalizedSearch = query.search?.trim().toLocaleLowerCase('vi') ?? ''
  const type = query.type && query.type !== 'all' ? (query.type as GalleryMediaType) : null
  const category = query.category && query.category !== 'all' ? query.category : null
  const page = Math.max(query.page ?? 1, 1)
  const pageSize = Math.max(query.pageSize ?? 9, 1)

  const filtered = [...fallbackItems]
    .sort((left, right) => right.id - left.id)
    .filter((item) => {
      if (type && item.mediaType !== type) return false
      if (category && item.categorySlug !== category) return false
      if (!normalizedSearch) return true
      return [item.title, item.description, item.categoryName, item.projectTitle]
        .filter(Boolean)
        .some((value) => value!.toLocaleLowerCase('vi').includes(normalizedSearch))
    })

  const start = (page - 1) * pageSize
  return {
    items: filtered.slice(start, start + pageSize),
    categories: buildCategories(fallbackItems),
    counts: {
      all: fallbackItems.length,
      images: fallbackItems.filter((item) => item.mediaType === 'image').length,
      videos: fallbackItems.filter((item) => item.mediaType === 'video').length
    },
    totalCount: filtered.length,
    page,
    pageSize,
    totalPages: Math.ceil(filtered.length / pageSize)
  }
}
