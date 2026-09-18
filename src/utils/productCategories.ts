/**
 * Bản đồ danh mục sản phẩm dùng chung cho banner + section header.
 *
 * Cấu trúc URL: /san-pham/:category/:subcategory
 *   - /san-pham/phong-khach            → danh mục cha "Phòng Khách"
 *   - /san-pham/phong-khach/sofa       → danh mục con "Sofa" (thuộc Phòng Khách)
 *
 * Mục tiêu: banner hiển thị eyebrow = cấp cha, title = cấp hiện tại
 * (vd "Phòng Khách" / "Sofa") thay vì lặp lại cùng một tiêu đề.
 */

export interface ProductCategoryNode {
  /** slug trên URL, vd "phong-khach" */
  slug: string
  /** tên hiển thị, vd "Phòng Khách" */
  name: string
  /** danh mục con: slug → tên hiển thị */
  children: Record<string, string>
}

export const PRODUCT_CATEGORY_TREE: ProductCategoryNode[] = [
  {
    slug: 'phong-khach',
    name: 'Phòng Khách',
    children: {
      sofa: 'Sofa',
      'ban-tra': 'Bàn Trà',
      'ke-ti-vi': 'Kệ Ti Vi'
    }
  },
  {
    slug: 'phong-ngu',
    name: 'Phòng Ngủ',
    children: {
      'giuong-ngu': 'Giường Ngủ',
      'tu-quan-ao': 'Tủ Quần Áo',
      'ke-trang-diem': 'Kệ Trang Điểm'
    }
  },
  {
    slug: 'phong-bep',
    name: 'Phòng Bếp',
    children: {
      'ban-an': 'Bàn Ăn',
      'tu-bep': 'Tủ Bếp'
    }
  }
]

export interface ProductBreadcrumb {
  /** tên cấp cha (eyebrow), vd "Phòng Khách"; rỗng nếu đang ở gốc /san-pham */
  parent: string
  /** tên cấp hiện tại (title), vd "Sofa" hoặc "Phòng Khách" */
  current: string
  /** slug danh mục cha (để tạo link breadcrumb), vd "phong-khach" */
  parentSlug: string
  /** slug danh mục con nếu có, vd "sofa" */
  childSlug?: string
}

/**
 * Phân giải path hiện tại thành breadcrumb 2 cấp.
 * Trả về null nếu path không thuộc /san-pham.
 */
export function resolveProductBreadcrumb(path: string): ProductBreadcrumb | null {
  const segments = path.replace(/^\/+|\/+$/g, '').split('/')
  if (segments[0] !== 'san-pham') return null

  const parentSlug = segments[1]
  const childSlug = segments[2]

  // /san-pham (không có danh mục) → trang danh mục tổng
  if (!parentSlug) {
    return { parent: '', current: 'Sản phẩm', parentSlug: '' }
  }

  const parent = PRODUCT_CATEGORY_TREE.find((node) => node.slug === parentSlug)
  if (!parent) {
    return { parent: '', current: 'Sản phẩm', parentSlug: '' }
  }

  // /san-pham/phong-khach → title = tên danh mục cha
  if (!childSlug) {
    return { parent: '', current: parent.name, parentSlug: parent.slug }
  }

  // /san-pham/phong-khach/sofa → eyebrow = cha, title = con
  const childName = parent.children[childSlug]
  return {
    parent: parent.name,
    current: childName ?? parent.name,
    parentSlug: parent.slug,
    childSlug
  }
}