export type GalleryMediaType = 'image' | 'video'

export type GalleryItem = {
  id: number
  title: string
  description?: string | null
  mediaType: GalleryMediaType
  mediaUrl: string
  thumbnailUrl?: string | null
  altText?: string | null
  provider: 'local' | 'youtube' | 'vimeo' | string
  duration?: string | null
  isFeatured: boolean
  categoryName: string
  categorySlug: string
  projectId?: number | null
  projectTitle?: string | null
}

export type GalleryCategory = {
  id: number
  name: string
  slug: string
  itemCount: number
}

export type GalleryCounts = {
  all: number
  images: number
  videos: number
}

export type GalleryResponse = {
  items: GalleryItem[]
  categories: GalleryCategory[]
  counts: GalleryCounts
  totalCount: number
  page: number
  pageSize: number
  totalPages: number
}

export type GalleryQuery = {
  type?: GalleryMediaType | 'all'
  category?: string
  search?: string
  page?: number
  pageSize?: number
}
