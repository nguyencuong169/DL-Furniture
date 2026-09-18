import { featuredProjects } from '../config/featuredProjects'

const apiBaseUrl = (import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328').replace(
  /\/$/,
  ''
)

export interface ProjectResponse {
  id: number
  title: string
  subtitle?: string | null
  clientName?: string | null
  location?: string | null
  description?: string | null
  coverImage?: string | null
  status: string
  createdAt?: string
  updatedAt?: string
  images: ProjectImageResponse[]
}

export interface ProjectImageResponse {
  id: number
  imageUrl: string
  caption?: string | null
  sortOrder: number
}

// Mô tả chi tiết dùng cho fallback (khi API chưa chạy) — khớp với 4 dự án tiêu biểu.
const FALLBACK_DESCRIPTIONS: Record<number, string> = {
  1: 'Không gian phòng khách và phòng ăn mở về phía khu vườn, sử dụng gỗ óc chó Bắc Mỹ chuẩn FAS. D&L Furniture chịu trách nhiệm từ bản vẽ chi tiết, sản xuất tại xưởng đến lắp đặt hoàn thiện tại Saroma Villa, Thủ Thiêm.',
  2: 'Thi công trọn gói toàn bộ nội thất biệt thự Vinhomes Grand Park: hệ tủ, vách ốp, giường, bàn làm việc kết hợp gỗ óc chó và da. Tổng diện tích thi công 260 m², chuẩn khớp nối lắp thử tại xưởng trước khi bàn giao.',
  3: 'Phòng ăn và phòng thờ được thiết kế theo ngôn ngữ gỗ óc chó đồng bộ, nhấn vào vân gỗ tự nhiên và tỷ lệ cân đối. Dự án tại khu đô thị Vĩnh Yên với tổng diện tích 180 m².',
  4: 'Căn hộ chung cư Vinhomes Metropolis được tối ưu công năng với thư phòng và phòng khách liền mạch. Vách tủ gỗ óc chó kết hợp ánh sáng gián tiếp giúp không gian 95 m² rộng và sâu hơn về thị giác.'
}

const FALLBACK_PROJECTS: ProjectResponse[] = featuredProjects.map((project) => ({
  id: project.id,
  title: project.title,
  subtitle: project.type,
  clientName: project.client,
  location: project.location,
  description: `${project.result}. ${FALLBACK_DESCRIPTIONS[project.id] ?? ''}`,
  coverImage: project.image,
  status: 'published',
  images: [{ id: project.id, imageUrl: project.image, caption: project.title, sortOrder: 1 }]
}))

export async function fetchProjects(): Promise<ProjectResponse[]> {
  try {
    const res = await fetch(`${apiBaseUrl}/api/projects`, {
      headers: { Accept: 'application/json' }
    })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    return (await res.json()) as ProjectResponse[]
  } catch {
    return FALLBACK_PROJECTS
  }
}

export async function fetchProjectById(id: number): Promise<ProjectResponse | null> {
  try {
    const res = await fetch(`${apiBaseUrl}/api/projects/${id}`, {
      headers: { Accept: 'application/json' }
    })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    return (await res.json()) as ProjectResponse
  } catch {
    return FALLBACK_PROJECTS.find((project) => project.id === id) ?? null
  }
}