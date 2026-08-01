import avatar1 from '../assets/img/team/4.jpg'
import avatar2 from '../assets/img/team/1.jpg'
import avatar3 from '../assets/img/team/2.jpg'
import avatar4 from '../assets/img/team/5.jpg'
import avatar5 from '../assets/img/team/3.jpg'
import avatar6 from '../assets/img/team/6.jpg'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328'

export interface TeamMemberResponse {
  id: number
  fullName: string
  role: string
  avatarImage: string
  email: string
  facebookUrl?: string
  twitterUrl?: string
  instagramUrl?: string
  pinterestUrl?: string
  sortOrder: number
}

export async function fetchTeamMembers(): Promise<TeamMemberResponse[]> {
  try {
    const res = await fetch(`${API_BASE}/api/team-members`)
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    return await res.json()
  } catch {
    return FALLBACK_TEAM
  }
}

const FALLBACK_TEAM: TeamMemberResponse[] = [
  {
    id: 1,
    fullName: 'KTS. Nguyễn Văn Dũng',
    role: 'Giám đốc sáng tạo',
    avatarImage: avatar1,
    email: 'dungnv@dl-furniture.com',
    sortOrder: 0
  },
  {
    id: 2,
    fullName: 'KTS. Trần Thị Linh',
    role: 'Trưởng nhóm thiết kế',
    avatarImage: avatar2,
    email: 'linhtt@dl-furniture.com',
    sortOrder: 0
  },
  {
    id: 3,
    fullName: 'KTS. Phạm Minh Quân',
    role: 'Kiến trúc sư nội thất',
    avatarImage: avatar3,
    email: 'quanpm@dl-furniture.com',
    sortOrder: 0
  },
  {
    id: 4,
    fullName: 'KTS. Lê Thu Hà',
    role: 'Kiến trúc sư nội thất',
    avatarImage: avatar4,
    email: 'halt@dl-furniture.com',
    sortOrder: 0
  },
  {
    id: 5,
    fullName: 'KTS. Hoàng Đức Anh',
    role: 'Giám sát thi công',
    avatarImage: avatar5,
    email: 'anhhd@dl-furniture.com',
    sortOrder: 0
  },
  {
    id: 6,
    fullName: 'KTS. Vũ Ngọc Mai',
    role: 'Chuyên viên vật liệu & màu sắc',
    avatarImage: avatar6,
    email: 'maivn@dl-furniture.com',
    sortOrder: 0
  }
]
