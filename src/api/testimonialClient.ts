import avatar1 from '../assets/img/team/4.jpg'
import avatar2 from '../assets/img/team/1.jpg'
import avatar3 from '../assets/img/team/5.jpg'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328'

export interface TestimonialResponse {
  id: number
  customerName: string
  location: string
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
    content:
      'Tôi rất ấn tượng với các dịch vụ và sản phẩm của Nội thất D&L Furniture. Từ tư vấn thiết kế đến thi công, lắp đặt đều chuyên nghiệp, chính vì vậy nên gia đình tôi rất hài lòng khi lựa chọn. Không gian sống của chúng tôi thực sự đã thay đổi hoàn toàn sau khi được D&L Furniture tư vấn và thiết kế lại toàn bộ nội thất phòng khách và phòng ngủ.',
    avatarImage: avatar1,
    rating: 5,
    sortOrder: 0
  },
  {
    id: 2,
    customerName: 'Anh Nguyễn Hùng Cường',
    location: 'Hà Nội',
    content:
      'Tất cả những sản phẩm nội thất gỗ óc chó của D&L Furniture luôn mang giá trị thẩm mỹ rất cao, chất lượng và công năng hoàn hảo. Tôi đã mua rất nhiều sản phẩm từ D&L Furniture và chưa bao giờ thất vọng về chất lượng cũng như dịch vụ chăm sóc khách hàng tận tình.',
    avatarImage: avatar2,
    rating: 5,
    sortOrder: 0
  },
  {
    id: 3,
    customerName: 'Chị Nguyễn Thị Nguyệt',
    location: 'Hà Nội',
    content:
      'Đội ngũ D&L Furniture đã hỗ trợ tôi rất tận tình từ khâu tư vấn, lên bản vẽ đến hoàn thiện thi công. Sản phẩm bàn giao đúng tiến độ, đúng thiết kế. Tôi sẽ tiếp tục sử dụng dịch vụ của D&L Furniture cho các dự án nội thất sau này và giới thiệu cho bạn bè, người thân.',
    avatarImage: avatar3,
    rating: 5,
    sortOrder: 0
  }
]
