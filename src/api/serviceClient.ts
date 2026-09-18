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
      'Biệt thự xứng tầm gia chủ — nội thất gỗ óc chó FAS được phát triển riêng theo hiện trạng, không dùng mẫu có sẵn.',
    image: serviceImg1,
    category: 'Thi công',
    sortOrder: 0
  },
  {
    id: 2,
    name: 'Nội thất chung cư',
    description:
      'Tối ưu từng m² cho không gian sống hiện đại — lưu trữ thông minh, công năng trọn vẹn mà không đánh đổi thẩm mỹ.',
    image: serviceImg2,
    category: 'Thi công',
    sortOrder: 1
  },
  {
    id: 3,
    name: 'Văn phòng & Showroom',
    description:
      'Không gian làm việc đồng bộ thương hiệu — từ quầy lễ tân đến phòng họp, sản xuất tại xưởng riêng, bàn giao đúng tiến độ.',
    image: serviceImg3,
    category: 'Thi công',
    sortOrder: 2
  },
  {
    id: 4,
    name: 'Nội thất theo yêu cầu',
    description:
      'Đo đạc hiện trường, đóng tủ, vách, bàn ghế gỗ óc chó — đồng hành từ chọn phôi đến hoàn thiện tại công trình.',
    image: serviceImg4,
    category: 'Thi công',
    sortOrder: 3
  }
]
