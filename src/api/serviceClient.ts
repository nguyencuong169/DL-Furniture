import serviceImg1 from '../assets/img/pricing/1.jpg'
import serviceImg2 from '../assets/img/pricing/2.jpg'
import serviceImg3 from '../assets/img/pricing/3.jpg'
import serviceImg4 from '../assets/img/pricing/4.jpg'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328'

export interface ServiceResponse {
  id: number
  name: string
  description: string
  image: string
  category: string
  sortOrder: number
}

export async function fetchServices(): Promise<ServiceResponse[]> {
  try {
    const res = await fetch(`${API_BASE}/api/services`)
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    return await res.json()
  } catch {
    return FALLBACK_SERVICES
  }
}

const FALLBACK_SERVICES: ServiceResponse[] = [
  {
    id: 1,
    name: 'Nội thất biệt thự',
    description:
      'Kiến tạo nên tính thẩm mỹ cá tính với đa phong cách thiết kế và cung cấp những tiện ích sống xứng tầm đẳng cấp',
    image: serviceImg1,
    category: 'Thi công',
    sortOrder: 0
  },
  {
    id: 2,
    name: 'Nội thất chung cư',
    description:
      'Chuyên thiết kế nội thất chung cư trọn gói, chuyên nghiệp với nhiều phong cách thiết kế khác nhau',
    image: serviceImg2,
    category: 'Thi công',
    sortOrder: 0
  },
  {
    id: 3,
    name: 'Nội thất văn phòng',
    description:
      'Cung cấp các mẫu thiết kế nội thất văn phòng đa dạng diện tích và phong cách tạo nên vẻ đẹp và phong cách riêng',
    image: serviceImg3,
    category: 'Thi công',
    sortOrder: 0
  },
  {
    id: 4,
    name: 'Showroom & Trung tâm',
    description:
      'Xây dựng không gian theo concept riêng, môi trường học tập chuẩn mực, đẹp mắt cho từng đối tượng khác nhau',
    image: serviceImg4,
    category: 'Thi công',
    sortOrder: 0
  }
]
