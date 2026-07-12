import axios from 'axios'
import type { News } from '../generated/api-client/models'

export type PagedNewsResponse = {
  items: News[]
  totalCount: number
  page: number
  pageSize: number
  totalPages: number
}

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328'

export async function getNewsPaged(page: number, pageSize: number) {
  const res = await axios.get<PagedNewsResponse>(`${apiBaseUrl}/api/news/paged`, {
    params: {
      page,
      pageSize
    }
  })

  // Normalize keys in case backend casing differs
  const data = res.data as any
  return {
    items: (data.items ?? []) as News[],
    totalCount: data.totalCount ?? 0,
    page: data.page ?? page,
    pageSize: data.pageSize ?? pageSize,
    totalPages: data.totalPages ?? 0
  }
}

