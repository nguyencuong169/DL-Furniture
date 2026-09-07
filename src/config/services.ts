import { featuredProjects, type FeaturedProject } from './featuredProjects'

/**
 * DỊCH VỤ THEO LOẠI HÌNH — landing SEO (B2)
 * Mỗi loại hình (biệt thự / chung cư / văn phòng) là một trang riêng
 * `/dich-vu/:slug` nhằm bẫy từng nhóm từ khóa, đối chiếu cách Lạc Gia
 * tách trang "thi công nội thất biệt thự / chung cư / khách sạn".
 *
 * LƯU Ý khi sửa nội dung:
 * - `slug` là URL công khai — KHÔNG đổi trừ khi chấp nhận mất thứ hạng SEO.
 * - `projectType` phải khớp chính xác `type` của featuredProjects để lọc
 *   dự án liên quan (hiện chỉ có 2 loại; văn phòng chưa có dự án mẫu).
 * - Copy các trang viết theo hướng "thi công trọn gói từ bản vẽ đến
 *   bàn giao" — đúng mạch định vị của D&L.
 */

export interface ServiceHighlight {
  title: string
  text: string
}

export interface ServiceFaq {
  question: string
  answer: string
}

export interface ServiceLanding {
  slug: string
  navLabel: string
  name: string
  metaTitle: string
  metaDescription: string
  heroTagline: string
  heroImage: string
  intro: string[]
  highlights: ServiceHighlight[]
  scope: string[]
  /** Giá trị `type` trong featuredProjects dùng để lọc dự án liên quan */
  projectType: string
  faq: ServiceFaq[]
}

export const SERVICE_BASE_PATH = '/dich-vu'

export const serviceLandings: ServiceLanding[] = [
  {
    slug: 'thi-cong-noi-that-biet-thu',
    navLabel: 'Nội thất biệt thự',
    name: 'Thi công nội thất biệt thự',
    metaTitle: 'Thi công nội thất biệt thự trọn gói gỗ óc chó tại Hà Nội',
    metaDescription:
      'Thi công nội thất biệt thự trọn gói từ bản vẽ đến bàn giao: gỗ óc chó FAS, xưởng sản xuất riêng, lắp đặt và bảo hành 5 năm. D&L Furniture đồng hành cùng chủ đầu tư.',
    heroTagline: 'Không gian sống xứng tầm chủ nhân',
    heroImage: '/media/gallery/walnut-villa-living.webp',
    intro: [
      'Biệt thự là công trình mà mọi chi tiết nội thất đều phải trả lời câu hỏi: "Đây có phải dấu ấn riêng của gia chủ?". D&L Furniture không làm nội thất mẫu có sẵn — chúng tôi phát triển thiết kế từ chính hiện trạng công trình, thói quen sinh hoạt và gu thẩm mỹ của từng gia đình.',
      'Với xưởng sản xuất tại Thạch Thất, Hà Nội, chúng tôi tự kiểm soát toàn bộ vòng đời: từ chọn gỗ óc chó nguyên liệu, gia công chuẩn khớp nối đến lắp đặt tại công trình. Chủ đầu tư chỉ đối thoại với một đầu mối duy nhất từ bản vẽ đến ngày bàn giao.'
    ],
    highlights: [
      {
        title: 'Thiết kế theo hiện trạng',
        text: 'Khảo sát đo đạc trực tiếp, tận dụng đúng từng góc trần, cột, cầu thang đặc trưng của biệt thự.'
      },
      {
        title: 'Gia công xưởng riêng',
        text: 'Sản xuất tại xưởng D&L — kiểm soát chất liệu, mối ghép và độ hoàn thiện trước khi lên công trình.'
      },
      {
        title: 'Bàn giao & bảo hành',
        text: 'Nghiệm thu từng hạng mục cùng chủ đầu tư, bảo hành dài hạn và đồng hành sau bàn giao.'
      }
    ],
    scope: [
      'Nội thất phòng khách & phòng ăn',
      'Bộ bàn ghế, giường, tủ quần áo gỗ óc chó',
      'Vách ốp, tủ thờ, kệ trang trí theo thiết kế',
      'Cầu thang, lan can, ốp trần gỗ tự nhiên',
      'Tủ bếp & đảo bếp kết hợp đá tự nhiên',
      'Phòng làm việc, thư phòng, phòng giải trí'
    ],
    projectType: 'Nội thất Villa - Biệt Thự',
    faq: [
      {
        question: 'Chi phí thi công nội thất biệt thự trọn gói được tính như thế nào?',
        answer:
          'Chi phí dựa trên diện tích thi công, danh mục hạng mục và cấp bậc vật liệu được thống nhất trong bản vẽ kỹ thuật. Sau khảo sát, D&L gửi bảng khối lượng chi tiết từng hạng mục để chủ đầu tư kiểm soát được từng đồng chi tiêu.'
      },
      {
        question: 'Tôi đã có bản vẽ thiết kế của đơn vị khác, D&L có thi công được không?',
        answer:
          'Có. Đây là phạm vi quen thuộc của chúng tôi: tiếp nhận hồ sơ thiết kế, hiệu chỉnh chi tiết để phù hợp sản xuất (đủ thông tin kích thước, vật liệu, mối ghép), báo giá khối lượng minh bạch rồi thi công đúng bản vẽ đã chốt.'
      },
      {
        question: 'Thời gian thi công một biệt thự trọn gói mất bao lâu?',
        answer:
          'Tùy phạm vi, thông thường từ 60–120 ngày kể từ khi chốt bản vẽ kỹ thuật. Tiến độ được chia theo từng hạng mục với mốc nghiệm thu rõ ràng để chủ đầu tư theo dõi.'
      },
      {
        question: 'D&L bảo hành nội thất bao lâu?',
        answer:
          'Toàn bộ sản phẩm gỗ tự nhiên được bảo hành 5 năm về kết cấu, mối ghép và lỗi gia công, kèm chính sách bảo trì, đánh vecni định kỳ sau bàn giao.'
      }
    ]
  },
  {
    slug: 'thi-cong-noi-that-chung-cu',
    navLabel: 'Nội thất chung cư',
    name: 'Thi công nội thất căn hộ chung cư',
    metaTitle: 'Thi công nội thất căn hộ chung cư trọn gói — D&L Furniture',
    metaDescription:
      'Thi công nội thất căn hộ chung cư tối ưu từng mét vuông: tủ thông minh đa năng, vật liệu chuẩn gỗ óc chó, thi công nhanh gọn đúng tiến độ bàn giao căn hộ.',
    heroTagline: 'Tối ưu từng mét vuông không gian',
    heroImage: '/media/gallery/walnut-home-library.webp',
    intro: [
      'Căn hộ chung cư đặt ra bài toán ngược lại với biệt thự: diện tích có hạn nhưng công năng phải đủ cho cả gia đình. Mỗi mét vuông đều phải làm việc — tủ giày kiêm ghế ngồi, thư phòng gài trong phòng ngủ, tủ âm tường tận dụng sát trần.',
      'D&L Furniture thiết kế và thi công nội thất chung cư theo hiện trạng thực tế của từng căn hộ: đo đạc chuẩn xác từng milimet, sản xuất tại xưởng rồi lắp ghép tại chỗ — không phát sinh, không làm hư hại công trình xung quanh.'
    ],
    highlights: [
      {
        title: 'Công năng thông minh',
        text: 'Tủ đa năng, nội thất âm tường, giải pháp gấp gài giúp căn hộ rộng hơn mà không mất vẻ cao cấp.'
      },
      {
        title: 'Đo đạc chuẩn milimet',
        text: 'Khảo sát hiện trạng kỹ càng trước khi sản xuất — nội thất khớp hoàn hảo với tường, trần, sàn căn hộ.'
      },
      {
        title: 'Thi công gọn, đúng hạn',
        text: 'Sản xuất sẵn tại xưởng, lắp đặt nhanh trong vài ngày — phù hợp tiến độ nhận bàn giao căn hộ.'
      }
    ],
    scope: [
      'Tủ giày, tủ quần áo âm tường đa năng',
      'Nội thất phòng khách & kệ tivi',
      'Tủ bếp liền khối kết hợp đá và gia dụng',
      'Phòng ngủ trọn bộ: giường, đầu giường, tủ',
      'Góc làm việc, thư phòng tích hợp',
      'Vách ngăn trang trí, ốp tường gỗ óc chó'
    ],
    projectType: 'Nội thất Căn hộ chung cư',
    faq: [
      {
        question: 'Chi phí thi công nội thất chung cư khoảng bao nhiêu?',
        answer:
          'Phụ thuộc diện tích và danh mục hạng mục. Bạn có thể tham khảo các gói đầu tư tại trang chủ; con số chính xác sẽ được báo sau khi khảo sát và thống nhất bản vẽ — luôn kèm bảng khối lượng minh bạch từng hạng mục.'
      },
      {
        question: 'Căn hộ đã bàn giao, có thi công được luôn không?',
        answer:
          'Có. Quy trình của D&L thiết kế cho kịch bản này: khảo sát trong một buổi, chốt bản vẽ nhanh, sản xuất tại xưởng song song với thủ tục xin phép ban quản lý, lắp đặt gọn trong vài ngày không ảnh hưởng các căn hộ lân cận.'
      },
      {
        question: 'Nhà có trẻ nhỏ, vật liệu có an toàn không?',
        answer:
          'Chúng tôi dùng gỗ tự nhiên và vật liệu phủ bề mặt đạt chuẩn, hệ keo và vecni ưu tiên dòng ít mùi, an toàn khi sử dụng. Chi tiết được bo tròn, xử lý mép cạnh để hạn chế tổn thương cho trẻ nhỏ.'
      },
      {
        question: 'Nội thất chung cư có được bảo hành như biệt thự không?',
        answer:
          'Cùng một chính sách: bảo hành 5 năm về kết cấu, mối ghép và lỗi gia công cho toàn bộ sản phẩm D&L sản xuất, bất kể loại hình công trình.'
      }
    ]
  },
  {
    slug: 'thi-cong-noi-that-van-phong',
    navLabel: 'Nội thất văn phòng',
    name: 'Thi công nội thất văn phòng',
    metaTitle: 'Thi công nội thất văn phòng gỗ óc chó trọn gói — D&L Furniture',
    metaDescription:
      'Thi công nội thất văn phòng, phòng làm việc, showroom theo hiện trạng: quầy lễ tân, hệ bàn làm việc, phòng họp — sản xuất xưởng riêng, bàn giao đúng tiến độ.',
    heroTagline: 'Không gian làm việc thể hiện đẳng cấp thương hiệu',
    heroImage: '/media/gallery/villa-bedroom-lounge.webp',
    intro: [
      'Văn phòng là nơi thương hiệu được "đọc" trước cả cuộc gặp đầu tiên. Quầy lễ tân, phòng họp, khu vực làm việc chung — mỗi hạng mục cần vừa đẹp, vừa bền, vừa đúng tiến độ khai trương.',
      'D&L Furniture thi công nội thất văn phòng với lợi thế xưởng sản xuất riêng: hàng loạt module bàn, tủ, vách được gia công đồng bộ, lắp đặt theo ca để không làm gián đoạn hoạt động của doanh nghiệp.'
    ],
    highlights: [
      {
        title: 'Đồng bộ thương hiệu',
        text: 'Nội thất nhất quán chất liệu, màu sắc và ngôn ngữ thiết kế với nhận diện thương hiệu của doanh nghiệp.'
      },
      {
        title: 'Lắp đặt theo ca',
        text: 'Triển khai lắp ghép ngoài giờ hoặc theo ca — văn phòng vẫn vận hành trong suốt quá trình thi công.'
      },
      {
        title: 'Đúng tiến độ khai trương',
        text: 'Kế hoạch sản xuất bám mốc khai trương, nghiệm thu theo hạng mục để doanh nghiệp vào làm đúng hẹn.'
      }
    ],
    scope: [
      'Quầy lễ tân & khu vực tiếp khách',
      'Hệ bàn làm việc cá nhân và open-space',
      'Phòng họp, phòng giám đốc trọn bộ',
      'Vách ngăn kính kết gỗ, ốp tường logo',
      'Tủ hồ sơ, kệ tài liệu đồng bộ',
      'Khu pantry, không gian nghỉ nhân viên'
    ],
    projectType: 'Nội thất Văn phòng',
    faq: [
      {
        question: 'D&L có thi công văn phòng diện tích nhỏ hoặc hạng mục lẻ không?',
        answer:
          'Có. Chúng tôi nhận từ một hạng mục (quầy lễ tân, phòng họp) đến toàn bộ mặt bằng. Điều kiện duy nhất là hạng mục đó phải sản xuất tại xưởng D&L để đảm bảo chuẩn chất lượng bảo hành.'
      },
      {
        question: 'Văn phòng đang hoạt động, thi công có làm ảnh hưởng không?',
        answer:
          'Hàng hóa được sản xuất hoàn thiện tại xưởng, tại công trình chỉ lắp ghép. Chúng tôi bố trí thi công ngoài giờ hành chính hoặc theo ca, khu vực nào xong dọn sạch khu vực đó ngay.'
      },
      {
        question: 'Có hỗ trợ thiết kế không hay chỉ thi công?',
        answer:
          'Cả hai. Với văn phòng, D&L thường phối hợp cùng đơn vị thiết kế của khách để triển khai chi tiết kỹ thuật; hoặc nhận thiết kế trọn gói nếu doanh nghiệp chưa có hồ sơ.'
      },
      {
        question: 'Tiến độ điển hình cho một mặt bằng văn phòng là bao lâu?',
        answer:
          'Với mặt bằng dưới 300m² và bản vẽ đã chốt, thông thường 30–60 ngày sản xuất và lắp đặt. Mốc nghiệm thu theo từng khu vực giúp doanh nghiệp kiểm soát tiến độ khai trương.'
      }
    ]
  }
]

/** Tìm landing theo slug; trả về undefined nếu slug không tồn tại */
export function getServiceLanding(slug: string): ServiceLanding | undefined {
  return serviceLandings.find((service) => service.slug === slug)
}

/** Dự án tiêu biểu liên quan đến loại hình dịch vụ (lọc theo `type`) */
export function relatedProjectsFor(service: ServiceLanding): FeaturedProject[] {
  return featuredProjects.filter((project) => project.type === service.projectType)
}

/** Đường dẫn đầy đủ của một landing dịch vụ */
export function servicePath(service: ServiceLanding): string {
  return `${SERVICE_BASE_PATH}/${service.slug}`
}
