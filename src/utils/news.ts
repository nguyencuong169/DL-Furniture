import fallbackNewsImage from '../assets/img/news/1.jpg'
import type { NewsItem } from '../types/news'

const bundledNewsImages = import.meta.glob('../assets/img/news/*.{jpg,jpeg,png,webp}', {
  eager: true,
  query: '?url',
  import: 'default'
}) as Record<string, string>

const preferredNewsImages = ['1.jpg', '2.jpg', '3.jpg', '4.jpg', '6.jpg']
const legacyRemoteImagePrefix = 'https://images.unsplash.com/'

function fallbackImageFor(key: number | string = 0) {
  const numericKey =
    typeof key === 'number'
      ? key
      : Array.from(key).reduce((sum, char) => sum + char.charCodeAt(0), 0)
  const index = Math.abs(numericKey - 1) % preferredNewsImages.length
  const fileName = preferredNewsImages[index]
  return bundledNewsImages[`../assets/img/news/${fileName}`] ?? fallbackNewsImage
}

export function resolveNewsImage(image?: string, key: number | string = 0) {
  const fallback = fallbackImageFor(key)
  if (
    !image ||
    image.startsWith(legacyRemoteImagePrefix) ||
    image.trim().toLowerCase().startsWith('data:image/svg+xml')
  )
    return fallback

  const localPrefix = '/src/assets/img/news/'
  if (!image.startsWith(localPrefix)) return image

  const fileName = image.slice(localPrefix.length)
  return bundledNewsImages[`../assets/img/news/${fileName}`] ?? fallback
}

export function handleNewsImageError(event: Event, key: number | string = 0) {
  const image = event.currentTarget as HTMLImageElement | null
  if (!image) return

  image.onerror = null
  image.src = fallbackImageFor(key)
}

export function getNewsDate(item: NewsItem) {
  return item.updatedDate ?? item.createdDate
}

export function splitNewsTags(tags?: string) {
  if (!tags) return []
  return tags
    .split(',')
    .map((tag) => tag.trim())
    .filter(Boolean)
}
