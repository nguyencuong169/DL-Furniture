import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const GalleryView = () => import('../views/GalleryView.vue')
const AboutView = () => import('../views/AboutView.vue')
const ProductView = () => import('../views/ProductView.vue')
const ProjectView = () => import('../views/ProjectView.vue')
const ProductDetailView = () => import('../views/ProductDetailView.vue')
const ThuocLoBanView = () => import('../views/ThuocLoBanView.vue')
const NotFoundComponent = () => import('../template/15_NotFoundComponent.vue')
const ProductComponent = () => import('../template/04_ProductComponent.vue')
const NewsView = () => import('../views/NewsView.vue')
const NewsDetailView = () => import('../views/NewsDetailView.vue')
const ContactUsView = () => import('../views/ContactUsView.vue')

const historyBase = import.meta.env.BASE_URL === './' ? '/' : import.meta.env.BASE_URL

const router = createRouter({
  linkActiveClass: 'active',
  history: createWebHistory(historyBase),
  scrollBehavior(to, _from, savedPosition) {
    if (savedPosition) return savedPosition
    if (to.hash) return { el: to.hash, top: 110, behavior: 'smooth' }
    return { top: 0 }
  },
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    // {
    //   path: '/about',
    //   name: 'about',
    //   // route level code-splitting
    //   // this generates a separate chunk (About.[hash].js) for this route
    //   // which is lazy-loaded when the route is visited.
    //   component: () => import('../views/AboutView.vue')
    // },
    {
      path: '/gioi-thieu',
      name: 'about',
      component: AboutView,
      meta: {
        title: 'Giới Thiệu D&L Furniture | 15+ Năm Thiết Kế Nội Thất Gỗ Óc Chó',
        description:
          'D&L Furniture – 15+ năm kinh nghiệm thiết kế & thi công nội thất gỗ óc chó cao cấp. 320+ dự án hoàn thiện, 98% khách hàng hài lòng.'
      }
    },
    {
      path: '/thu-vien',
      name: 'gallery',
      component: GalleryView,
      meta: {
        title: 'Thư Viện Nội Thất Gỗ Óc Chó | D&L Furniture',
        description:
          'Khám phá thư viện hình ảnh & video các không gian nội thất gỗ óc chó cao cấp do D&L Furniture thiết kế và thi công.'
      }
    },
    {
      path: '/du-an',
      name: 'project',
      component: ProjectView,
      meta: {
        title: 'Dự Án Thi Công Nội Thất Gỗ Óc Chó | D&L Furniture',
        description:
          'Các dự án thi công nội thất gỗ óc chó cho biệt thự, chung cư, khách sạn đã được D&L Furniture hoàn thiện trên toàn quốc.'
      }
    },
    {
      path: '/tin-tuc',
      name: 'news',
      component: NewsView,
      meta: {
        title: 'Tin Tức Nội Thất Gỗ Óc Chó & Xu Hướng Thiết Kế | D&L Furniture',
        description:
          'Cập nhật xu hướng thiết kế nội thất gỗ óc chó, kinh nghiệm chọn gỗ, phong thủy và mẹo bài trí không gian sống.'
      }
    },
    {
      path: '/tin-tuc/:id(\\d+)',
      name: 'news-detail',
      component: NewsDetailView
    },
    {
      path: '/san-pham',
      name: 'product',
      component: ProductView,
      meta: {
        title: 'Nội Thất Gỗ Óc Chó Cao Cấp: Sofa, Bàn Ăn, Giường Ngủ | D&L Furniture',
        description:
          'Bộ sưu tập nội thất gỗ óc chó cao cấp: sofa, bàn trà, bàn ăn, giường ngủ, tủ bếp… thiết kế riêng theo yêu cầu.'
      },
      children: [
        // Default child: /san-pham thuần hiển thị danh sách toàn bộ sản phẩm
        // (trước đây router-view rỗng → trang chỉ còn banner + footer)
        {
          path: '',
          name: 'product-list',
          component: ProductComponent
        },
        {
          path: 'phong-ngu',
          name: 'phongngu',
          component: ProductComponent,
          children: [
            {
              path: 'giuong-ngu',
              name: 'giuongngu',
              component: ProductComponent
            },
            {
              path: 'tu-quan-ao',
              name: 'tuquanao',
              component: ProductComponent
            },
            {
              path: 'ke-trang-diem',
              name: 'ketrangdiem',
              component: ProductComponent
            }
          ]
        },
        {
          path: 'phong-khach',
          name: 'phongkhach',
          component: ProductComponent,
          children: [
            {
              path: 'sofa',
              name: 'sofa',
              component: ProductComponent
            },
            {
              path: 'ban-tra',
              name: 'bantra',
              component: ProductComponent
            },
            {
              path: 'ke-ti-vi',
              name: 'ketivi',
              component: ProductComponent
            }
          ]
        },
        {
          path: 'phong-bep',
          name: 'phongbep',
          component: ProductComponent,
          children: [
            {
              path: 'ban-an',
              name: 'banan',
              component: ProductComponent
            },
            {
              path: 'tu-bep',
              name: 'tubep',
              component: ProductComponent
            }
          ]
        }
      ]
    },
    {
      // P1-2 SEO slug: /san-pham/giuong-oc-cho-g01 — URL chứa từ khóa
      path: '/san-pham/:slug',
      name: 'product-detail',
      component: ProductDetailView
    },
    {
      // Redirect 301-kiểu SPA: URL cũ /san-pham/detail/12 → /san-pham/12
      // (DetailView sẽ replace lên URL slug chuẩn sau khi fetch sản phẩm)
      path: '/san-pham/detail/:id',
      redirect: (to) => ({ name: 'product-detail', params: { slug: to.params.id } })
    },
    {
      // P1-3: công cụ tra Thước Lỗ Ban (đăng ký lại — trước đây là dead code)
      path: '/thuoc-lo-ban',
      name: 'thuoc-lo-ban',
      component: ThuocLoBanView,
      meta: {
        title: 'Tra Cứu Thước Lỗ Ban – Kích Thước Đẹp Theo Phong Thủy | D&L Furniture',
        description:
          'Công cụ tra cứu Thước Lỗ Ban trực tuyến: nhập kích thước (cm) để biết cung Tài/Nghĩa/Quan/Bản tốt hay Kiếp/Ly/Bệnh/Hậu xấu, kèm gợi ý kích thước đẹp chuẩn phong thủy.'
      }
    },
    {
      path: '/lien-he',
      name: 'contacts',
      component: ContactUsView,
      meta: {
        title: 'Liên Hệ D&L Furniture – Tư Vấn Nội Thất Gỗ Óc Chó: 0961 109 897',
        description:
          'Liên hệ D&L Furniture để được tư vấn thiết kế & thi công nội thất gỗ óc chó. Hotline: 0961 109 897.'
      }
    },
    {
      // path: "*",
      path: '/:catchAll(.*)',
      name: 'NotFound',
      component: NotFoundComponent
    }
  ]
})

// HM1 SEO: cập nhật title + meta description theo từng route.
// Merge meta từ các matched records để route con (vd /san-pham/phong-ngu) kế thừa meta của cha.
// HomeView & NewsDetailView tự ghi đè title sau khi fetch dữ liệu động.
router.afterEach((to) => {
  const seo = to.matched.reduce<{ title?: string; description?: string }>(
    (acc, record) => ({ ...acc, ...(record.meta as { title?: string; description?: string }) }),
    {}
  )
  if (seo.title) document.title = seo.title
  if (seo.description) {
    let tag = document.querySelector('meta[name="description"]')
    if (!tag) {
      tag = document.createElement('meta')
      tag.setAttribute('name', 'description')
      document.head.appendChild(tag)
    }
    tag.setAttribute('content', seo.description)
  }
})

export default router
