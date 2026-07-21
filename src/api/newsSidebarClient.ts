import axios from 'axios'
import type { NewsItem } from '../types/news'

export type CategoryDto = {
  id: number
  name: string
  slug: string
}

export type TagDto = {
  name: string
  count: number
}

export type ArchiveDto = {
  year: number
  month: number
  monthLabel: string
  count: number
}

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328'

export async function getNewsCategories() {
  const res = await axios.get<CategoryDto[]>(`${apiBaseUrl}/api/news/categories`)
  return res.data
}

export async function getNewsTags() {
  const res = await axios.get<TagDto[]>(`${apiBaseUrl}/api/news/tags`)
  return res.data
}

export async function getNewsArchives() {
  const res = await axios.get<ArchiveDto[]>(`${apiBaseUrl}/api/news/archives`)
  return res.data
}

export async function getNewsRelated(newsId: number, take = 3) {
  const res = await axios.get<NewsItem[]>(`${apiBaseUrl}/api/news/${newsId}/related`, {
    params: { take }
  })

  // Normalize keys in case backend casing differs
  const data = res.data as any
  return (data ?? []) as NewsItem[]
}

export async function getNewsById(newsId: number) {
  const res = await axios.get<NewsItem>(`${apiBaseUrl}/api/news/${newsId}`)
  return res.data
}
