import { describe, it, expect } from 'vitest'

import {
  SERVICE_BASE_PATH,
  getServiceLanding,
  relatedProjectsFor,
  serviceLandings,
  servicePath
} from '../services'
import { featuredProjects } from '../featuredProjects'

describe('services config (landing SEO)', () => {
  describe('serviceLandings', () => {
    it('contains exactly 3 service landings', () => {
      expect(serviceLandings).toHaveLength(3)
    })

    it('has unique slugs', () => {
      const slugs = serviceLandings.map((s) => s.slug)
      expect(new Set(slugs).size).toBe(slugs.length)
    })

    it('covers the three target segments', () => {
      const slugs = serviceLandings.map((s) => s.slug)
      expect(slugs).toEqual(
        expect.arrayContaining([
          'thi-cong-noi-that-biet-thu',
          'thi-cong-noi-that-chung-cu',
          'thi-cong-noi-that-van-phong'
        ])
      )
    })

    it('has all required SEO fields non-empty for every landing', () => {
      serviceLandings.forEach((service) => {
        expect(service.slug).toBeTruthy()
        expect(service.name).toBeTruthy()
        expect(service.metaTitle).toBeTruthy()
        expect(service.metaDescription).toBeTruthy()
        expect(service.metaDescription.length).toBeGreaterThanOrEqual(80)
        expect(service.heroTagline).toBeTruthy()
        expect(service.heroImage).toMatch(/^\//)
      })
    })

    it('has rich content: intro, highlights, scope and FAQ for every landing', () => {
      serviceLandings.forEach((service) => {
        expect(service.intro.length).toBeGreaterThanOrEqual(2)
        expect(service.highlights).toHaveLength(3)
        expect(service.scope.length).toBeGreaterThanOrEqual(6)
        expect(service.faq.length).toBeGreaterThanOrEqual(4)
        service.faq.forEach((item) => {
          expect(item.question).toBeTruthy()
          expect(item.answer).toBeTruthy()
        })
      })
    })

    it('uses projectType values that exist in featuredProjects types', () => {
      const knownTypes = new Set(featuredProjects.map((p) => p.type))
      serviceLandings.forEach((service) => {
        // "Nội thất Văn phòng" chưa có dự án mẫu — được chấp nhận,
        // các loại hình còn lại phải khớp chính xác để lọc dự án liên quan.
        if (service.projectType !== 'Nội thất Văn phòng') {
          expect(knownTypes.has(service.projectType)).toBe(true)
        }
      })
    })

    it('has hero images pointing to existing public gallery media', () => {
      const galleryImages = new Set(featuredProjects.map((p) => p.image))
      serviceLandings.forEach((service) => {
        expect(galleryImages.has(service.heroImage)).toBe(true)
      })
    })
  })

  describe('getServiceLanding', () => {
    it('returns the matching landing for a valid slug', () => {
      const landing = getServiceLanding('thi-cong-noi-that-chung-cu')
      expect(landing).toBeDefined()
      expect(landing?.name).toContain('chung cư')
    })

    it('returns undefined for an unknown slug', () => {
      expect(getServiceLanding('khong-ton-tai')).toBeUndefined()
      expect(getServiceLanding('')).toBeUndefined()
    })
  })

  describe('relatedProjectsFor', () => {
    it('returns villa projects for the villa landing', () => {
      const villa = getServiceLanding('thi-cong-noi-that-biet-thu')
      expect(villa).toBeDefined()
      const projects = relatedProjectsFor(villa!)
      expect(projects.length).toBeGreaterThan(0)
      projects.forEach((project) => {
        expect(project.type).toBe(villa!.projectType)
      })
    })

    it('returns apartment projects for the apartment landing', () => {
      const apartment = getServiceLanding('thi-cong-noi-that-chung-cu')
      expect(apartment).toBeDefined()
      const projects = relatedProjectsFor(apartment!)
      expect(projects.length).toBeGreaterThan(0)
      projects.forEach((project) => {
        expect(project.type).toBe(apartment!.projectType)
      })
    })

    it('returns an empty list when the segment has no sample projects yet', () => {
      const office = getServiceLanding('thi-cong-noi-that-van-phong')
      expect(office).toBeDefined()
      expect(relatedProjectsFor(office!)).toEqual([])
    })
  })

  describe('servicePath / SERVICE_BASE_PATH', () => {
    it('builds the public URL under the shared base path', () => {
      expect(SERVICE_BASE_PATH).toBe('/dich-vu')
      const landing = getServiceLanding('thi-cong-noi-that-biet-thu')
      expect(servicePath(landing!)).toBe('/dich-vu/thi-cong-noi-that-biet-thu')
    })
  })
})