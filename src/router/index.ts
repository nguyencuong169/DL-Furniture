import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const GalleryView = () => import('../views/GalleryView.vue')
const AboutView = () => import('../views/AboutView.vue')
const ProductView = () => import('../views/ProductView.vue')
const ProjectView = () => import('../views/ProjectView.vue')
const ProductDetailView = () => import('../views/ProductDetailView.vue')
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
      component: AboutView
    },
    {
      path: '/thu-vien',
      name: 'gallery',
      component: GalleryView
    },
    {
      path: '/du-an',
      name: 'project',
      component: ProjectView
    },
    {
      path: '/tin-tuc',
      name: 'news',
      component: NewsView
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
      children: [
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
      path: '/san-pham/detail/:id',
      name: 'detail',
      component: ProductDetailView
    },
    {
      path: '/lien-he',
      name: 'contacts',
      component: ContactUsView
    },
    {
      // path: "*",
      path: '/:catchAll(.*)',
      name: 'NotFound',
      component: NotFoundComponent
    }
  ]
})

export default router
