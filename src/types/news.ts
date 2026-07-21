import type { News } from '../generated/api-client/models'

export type NewsItem = News & {
  newsCategoryId?: number
  tags?: string
}
