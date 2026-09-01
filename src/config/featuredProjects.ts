import { Ruler, Sofa, Trees, type LucideIcon } from 'lucide-vue-next'

export interface FeaturedProject {
  id: number
  client: string
  location: string
  title: string
  type: string
  image: string
  alt: string
  specs: { icon: LucideIcon; label: string }[]
}

/**
 * Dự án tiêu biểu — dùng chung cho homepage (HomeFeaturedProjectsComponent)
 * và trang dự án (ProjectView) để hai nơi luôn đồng bộ nội dung & kích thước card.
 */
export const featuredProjects: FeaturedProject[] = [
  {
    id: 1,
    client: 'Anh Tuấn',
    location: 'Thủ Thiêm',
    title: 'Thiết kế nội thất Saroma Villa',
    type: 'Nội thất Villa - Biệt Thự',
    image: '/media/gallery/walnut-villa-living.webp',
    alt: 'Không gian phòng khách gỗ óc chó mở ra khu vườn tại Saroma Villa',
    specs: [
      { icon: Ruler, label: 'Diện tích 220 m²' },
      { icon: Sofa, label: 'Phòng khách & phòng ăn' },
      { icon: Trees, label: 'Gỗ óc chó FAS' }
    ]
  },
  {
    id: 2,
    client: 'Anh Cường',
    location: 'Vinhomes Grand Park',
    title: 'Thiết kế nội thất biệt thự Vinhomes Grand Park',
    type: 'Nội thất Villa - Biệt Thự',
    image: '/media/gallery/villa-bedroom-lounge.webp',
    alt: 'Không gian phòng ngủ biệt thự Vinhomes Grand Park',
    specs: [
      { icon: Ruler, label: 'Diện tích 260 m²' },
      { icon: Sofa, label: 'Toàn bộ nội thất' },
      { icon: Trees, label: 'Gỗ óc chó & da' }
    ]
  },
  {
    id: 3,
    client: 'Chị Hằng',
    location: 'Vĩnh Yên',
    title: 'Thiết kế nội thất biệt thự KĐT Vĩnh Yên',
    type: 'Nội thất Villa - Biệt Thự',
    image: '/media/gallery/arched-dining.jpg',
    alt: 'Không gian phòng ăn biệt thự tại khu đô thị Vĩnh Yên',
    specs: [
      { icon: Ruler, label: 'Diện tích 180 m²' },
      { icon: Sofa, label: 'Phòng ăn & phòng thờ' },
      { icon: Trees, label: 'Gỗ óc chó' }
    ]
  },
  {
    id: 4,
    client: 'Chị Nguyệt',
    location: 'Liễu Giai',
    title: 'Thiết kế nội thất chung cư Vinhomes Metropolis',
    type: 'Nội thất Căn hộ chung cư',
    image: '/media/gallery/walnut-home-library.webp',
    alt: 'Vách tủ thư phòng gỗ óc chó tại chung cư Vinhomes Metropolis',
    specs: [
      { icon: Ruler, label: 'Diện tích 95 m²' },
      { icon: Sofa, label: 'Phòng khách & thư phòng' },
      { icon: Trees, label: 'Gỗ óc chó' }
    ]
  }
]
