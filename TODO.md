# NewsView Grid Hover Effect Plan

## Steps:

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
