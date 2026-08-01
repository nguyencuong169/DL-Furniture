# NewsView Grid Hover Effect Plan
# TODO — About page (`/gioi-thieu`) fixes & API wiring

## Priority fixes (reconstructed after `git reset --hard HEAD`)

- [x] 1. Unify phone number (`tel:` → `+84961109897`) in:
  - `src/template/03_AboutComponent.vue`
  - `src/template/05_PricingComponent.vue`
  - `src/views/ContactUsView.vue`
  - `src/template/13_FooterComponent.vue` (added `tel:` link)
- [x] 2. Replace hard-coded Netlify banner URLs with local assets + `:style` binding:
  - `src/views/AboutView.vue` → `slider/1.jpg`
  - `src/template/08_TestiominalsComponent.vue` → `slider/2.jpg`
- [x] 3. Replace hotel-template Team content with Vietnamese sample team data & fix nested `.social` duplicate:
  - `src/template/14_TeamComponent.vue`
- [x] 4. Clean testimonials: remove duplicate review text + hidden preload `<img>` hack:
  - `src/template/08_TestiominalsComponent.vue`
- [x] 5. Localize English subtitles:
  - `05_PricingComponent.vue` ("Dịch vụ của chúng tôi")
  - `07_FaciltiesComponent.vue` ("Vì sao chọn chúng tôi")
  - `14_TeamComponent.vue` ("Đội ngũ")
  - `08_TestiominalsComponent.vue` ("Khách hàng đánh giá")
- [x] 6. Add meaningful Vietnamese `alt` text (About images, Team avatars, Testimonial avatars)
- [x] 7. Set `lang="vi"` in `index.html`

## API wiring (About page dynamic components)

### Backend (DLFurniture.Api)

- [x] `Models/Testimonial.cs` (long Id, DateTimeOffset?)
- [x] `Models/TeamMember.cs` (long Id, DateTimeOffset?)
- [x] `Models/ServiceItem.cs` (long Id, DateTimeOffset?)
- [x] `Data/AppDbContext.cs` — DbSets + entity configs (testimonials, team_members, services)
- [x] `Controllers/TestimonialsController.cs` (CRUD, long Id)
- [x] `Controllers/TeamMembersController.cs` (CRUD, long Id)
- [x] `Controllers/ServicesController.cs` (CRUD, long Id)

### Frontend (src/api + components)

- [x] `src/api/testimonialClient.ts` (fallback data, `VITE_API_BASE_URL` || `https://localhost:44328`)
- [x] `src/api/teamClient.ts` (fallback data)
- [x] `src/api/serviceClient.ts` (fallback data)
- [x] `08_TestiominalsComponent.vue` — fetches testimonials via API
- [x] `14_TeamComponent.vue` — fetches team members via API
- [x] `05_PricingComponent.vue` — fetches services via API

## Steps:
## Follow-up

- [x] Step 1: Information gathering (read NewsView.vue and NewsComponent.vue)
- [x] Step 2: Plan creation and approval
- [x] Step 3: Add CSS transitions and hover effects to grid cards in NewsView.vue
  - 3a: Add `position: relative; overflow: hidden` to `.item` in grid view
  - 3b: Add `transition` and `filter: brightness(100%)` to `.news-grid-view .item img`
  - 3c: Add hover: image scale(1.09) + brightness(75%) (matching NewsComponent)
  - 3d: Add `bottom: -70px` + `transition` to `.con`, hover sets `bottom: 0` (slide-up)
  - 3e: Add `background` + `border` to `.con` matching NewsComponent
  - 3f: Handle popular card variant (no slide-up, keep static layout)
- [x] Step 4: Verified all changes in file
- [x] Backend `dotnet build` — succeeded
- [x] Frontend `vue-tsc` type-check — exit code 0
- [ ] Run `npm run dev` and verify `/gioi-thieu` renders with fallback data (API may not be running)
