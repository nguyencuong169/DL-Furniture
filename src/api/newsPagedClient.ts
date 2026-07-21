import axios from 'axios'
import type { NewsItem } from '../types/news'

export type PagedNewsResponse = {
  items: NewsItem[]
  totalCount: number
  page: number
  pageSize: number
  totalPages: number
}

export type NewsPageFilters = {
  year?: number
  month?: number
  categoryId?: number
  tag?: string
  search?: string
}

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328'

export async function getNewsPaged(page: number, pageSize: number, filters: NewsPageFilters = {}) {
  const res = await axios.get<PagedNewsResponse>(`${apiBaseUrl}/api/news/paged`, {
    params: {
      page,
      pageSize,
      ...filters
    }
  })

  // Normalize keys in case backend casing differs
  const data = res.data as any
  return {
    items: (data.items ?? []) as NewsItem[],
    totalCount: data.totalCount ?? 0,
    page: data.page ?? page,
    pageSize: data.pageSize ?? pageSize,
    totalPages: data.totalPages ?? 0
  }
}

export async function getNewsPagedByArchiveMonth(
  year: number,
  month: number,
  page: number,
  pageSize: number,
  filters: Omit<NewsPageFilters, 'year' | 'month'> = {}
) {
  return getNewsPaged(page, pageSize, { ...filters, year, month })
}
