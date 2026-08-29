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
      'Thiết kế & thi công không gian biệt thự sang trọng từ gỗ óc chó, cân chỉnh tỷ lệ và chi tiết theo kiến trúc của gia chủ.',
    image: serviceImg1,
    category: 'Thi công',
    sortOrder: 0
  },
  {
    id: 2,
    name: 'Nội thất chung cư',
    description:
      'Trọn gói từ khảo sát hiện trường đến lắp đặt: tối ưu công năng, lưu trữ và thẩm mỹ cho diện tích căn hộ.',
    image: serviceImg2,
    category: 'Thi công',
    sortOrder: 1
  },
  {
    id: 3,
    name: 'Văn phòng & Showroom',
    description:
      'Thiết kế không gian làm việc và trưng bày theo concept riêng, đồng bộ thương hiệu và nhu cầu vận hành của doanh nghiệp.',
    image: serviceImg3,
    category: 'Thi công',
    sortOrder: 2
  },
  {
    id: 4,
    name: 'Nội thất theo yêu cầu',
    description:
      'Đóng tủ, vách, bàn ghế gỗ óc chó từ đo đạc hiện trường; đồng hành từ chọn phôi đến hoàn thiện tại công trình.',
    image: serviceImg4,
    category: 'Thi công',
    sortOrder: 3
  }
]
