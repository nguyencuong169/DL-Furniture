import avatar1 from '../assets/img/team/4.jpg'
import avatar2 from '../assets/img/team/1.jpg'
import avatar3 from '../assets/img/team/5.jpg'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328'

export interface TestimonialResponse {
  id: number
  customerName: string
  location: string
  projectName?: string
  content: string
  avatarImage: string
  rating: number
  sortOrder: number
}

export async function fetchTestimonials(): Promise<TestimonialResponse[]> {
  try {
    const res = await fetch(`${API_BASE}/api/testimonials`)
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    return await res.json()
  } catch {
    return FALLBACK_TESTIMONIALS
  }
}

const FALLBACK_TESTIMONIALS: TestimonialResponse[] = [
  {
    id: 1,
    customerName: 'Chị Nguyễn Thị Thuỳ Linh',
    location: 'Hồ Chí Minh',
    projectName: 'Cải tạo phòng khách & phòng ngủ',
    content:
      'Từ khâu tư vấn đến bàn giao, D&L đúng hẹn và duy nhất một lần chỉnh sửa nhỏ ở phòng ngủ — không phát sinh chi phí ngoài báo giá. Không gian phòng khách và phòng ngủ nhà tôi thay đổi hoàn toàn.',
    avatarImage: avatar1,
    rating: 5,
    sortOrder: 0
  },
  {
    id: 2,
    customerName: 'Anh Nguyễn Hùng Cường',
    location: 'Hà Nội',
    projectName: 'Nội thất gỗ óc chó theo yêu cầu',
    content:
      'Nội thất gỗ óc chó giao đúng tiến độ, từng mối ghép khớp chuẩn, bề mặt mịn tay. Sau nhiều lần đặt hàng, tôi chưa từng thất vọng về chất lượng và dịch vụ chăm sóc khách hàng.',
    avatarImage: avatar2,
    rating: 5,
    sortOrder: 0
  },
  {
    id: 3,
    customerName: 'Chị Nguyễn Thị Nguyệt',
    location: 'Hà Nội',
    projectName: 'Thiết kế & thi công nội thất trọn gói',
    content:
      'D&L kiên nhẫn điều chỉnh thiết kế 2 lần theo yêu cầu nhưng vẫn bàn giao đúng hạn, đúng bản vẽ. Tôi sẽ tiếp tục sử dụng dịch vụ cho các dự án sau và giới thiệu cho bạn bè, người thân.',
    avatarImage: avatar3,
    rating: 5,
    sortOrder: 0
  }
]
