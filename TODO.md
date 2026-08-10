# TODO - Product API Integration & Polish

## Goal

Polish `ProductComponent.vue` to use the real API (backend + frontend) while keeping the luxury design language of the site.

## Status

- [x] Backend model `Product.cs` (maps `products` table)
- [x] Backend model `ProductImage.cs` (maps `product_images` table)
- [x] Backend model `Category.cs` (maps `categories` table)
- [x] Register `Categories`, `Products`, `ProductImages` DbSets in `AppDbContext`
- [x] EF configuration for Category / Product / ProductImage (columns, indexes, relationships)
- [x] `ProductsController.cs` — `GET /api/products` (category + featured filter) and `GET /api/products/{id}`
- [x] Backend `dotnet build` succeeds (verify no compile errors)
- [x] Frontend `src/api/productClient.ts` — fetchProducts / fetchProductById / formatPrice + fallback data
- [x] Refactor `04_ProductComponent.vue` to load products from API, filter by route category, render grid, add luxury polish
- [x] Refactor `ProductDetailView.vue` to fetch and display real product by id
- [x] Frontend `npm run type-check` passes

## Notes

- Image paths in seed data point to `/src/assets/img/rooms/...`; the live API serves these as relative URLs the frontend resolves.
- Fallback data ensures the UI still renders if the API/DB is unavailable during development.
