# TODO - Extract Sidebar Boxes into Reusable Components

## Goal

Tách các box trong sidebar (Search, Categories, Tags) thành component dùng chung cho NewsView và NewsDetailView, lấy NewsView làm chuẩn. Grid mode giữ nguyên.

## Steps

- [ ] Create `src/components/NewsSidebarSearch.vue`
- [ ] Create `src/components/NewsCategories.vue`
- [ ] Create `src/components/NewsTags.vue`
- [ ] Refactor `NewsView.vue` to use the 3 new components (list mode only)
- [ ] Refactor `NewsDetailView.vue` to use NewsCategories + NewsTags
- [ ] Verify no leftover unused styles/logic
