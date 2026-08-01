# Fix "Invalid column name" errors for Testimonials / Team / Services API

## Root cause

EF Core entities (`Testimonial`, `TeamMember`, `ServiceItem`) and `AppDbContext`
mappings expect audit/soft-delete columns that do not exist in the actual SQL
Server tables (`del_flag`, `hidden`, `avatar_image`, `created_date`,
`created_user`, `customer_name`, `sort_order`, ...).

## Steps

- [x] Step 1: Check `sqlcmd` availability and SQL Server connectivity
- [x] Step 2: Create `database-about-api-migration.sql` (idempotent migration for
      `testimonials`, `team_members`, `services`)
- [x] Step 3: Run the migration against the local `DLFurniture` database
- [x] Step 4: Update original schema files (`database-schema-mssql.sql`,
      `CreateDatabase.sql`, `database-schema.sql`) to include the new columns
- [x] Step 5: Build API (`dotnet build`) and verify endpoints
      (`/api/testimonials`, `/api/team-members`, `/api/services`)

## CSS fix — Services & Team carousels hidden after async API data

- [x] Root cause: `.owl-carousel { display: none }` default; `custom.js` initialises
      carousels on document ready — before async API data renders — so carousels never
      init on the newly rendered `.item` elements and stay hidden.
- [x] `src/utils/carousel.ts` — reusable `initOwlCarousel()` helper: re-initialises an
      Owl Carousel after Vue renders async content; destroys existing instance first;
      retries briefly if DOM/jQuery not ready.
- [x] `src/template/05_PricingComponent.vue` — re-init `.pricing .owl-carousel`
      (items: 1/1/2) after `fetchServices()`.
- [x] `src/template/14_TeamComponent.vue` — re-init `.team .owl-carousel`
      (items: 1/2/3) after `fetchTeamMembers()`.
- [x] `src/template/08_TestiominalsComponent.vue` — re-init `.testimonials .owl-carousel`
      (items: 1/1/1) after `fetchTestimonials()`.
- [x] `vue-tsc` — no new type errors (only pre-existing errors in `src/generated/`).
