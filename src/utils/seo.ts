// Quản lý SEO per-page (title, meta description, canonical, Open Graph, Twitter)
// cho các view — thay cho việc copy-paste đoạn head-management của HomeView.
// Lưu ý: HomeView/NewsDetailView đã có logic riêng, không bắt buộc dùng tại đó.

const SITE_NAME = 'D&L Furniture'

export const DEFAULT_META_DESCRIPTION =
  'Thiết kế và thi công nội thất gỗ óc chó cao cấp theo hiện trạng và nhu cầu sử dụng. D&L Furniture đồng hành từ ý tưởng đến khi công trình hoàn thiện.'

interface PageSeo {
  title: string
  description?: string
  /** Đường dẫn tương đối (ví dụ '/gioi-thieu') để set canonical + og:url */
  path?: string
}

function upsertMeta(attribute: 'name' | 'property', key: string, content: string): void {
  let tag = document.head.querySelector<HTMLMetaElement>(`meta[${attribute}="${key}"]`)
  if (!tag) {
    tag = document.createElement('meta')
    tag.setAttribute(attribute, key)
    document.head.appendChild(tag)
  }
  tag.setAttribute('content', content)
}

function upsertCanonical(href: string): void {
  let link = document.head.querySelector<HTMLLinkElement>('link[rel="canonical"]')
  if (!link) {
    link = document.createElement('link')
    link.rel = 'canonical'
    document.head.appendChild(link)
  }
  link.setAttribute('href', href)
}

export function setPageSeo({ title, description = DEFAULT_META_DESCRIPTION, path }: PageSeo): void {
  const fullTitle = title.includes(SITE_NAME) ? title : `${title} | ${SITE_NAME}`
  document.title = fullTitle

  upsertMeta('name', 'description', description)
  upsertMeta('property', 'og:title', fullTitle)
  upsertMeta('property', 'og:description', description)
  upsertMeta('name', 'twitter:title', fullTitle)
  upsertMeta('name', 'twitter:description', description)

  if (path) {
    const url = new URL(path, window.location.origin).href
    upsertMeta('property', 'og:url', url)
    upsertCanonical(url)
  }
}