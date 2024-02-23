import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import GalleryView from '../views/GalleryView.vue'
import AboutView from '../views/AboutView.vue'
import ProductView from '../views/ProductView.vue'
import ProjectView from '../views/ProjectView.vue'
import ProductDetailView from '../views/ProductDetailView.vue'
import NotFoundComponent from '../template/15_NotFoundComponent.vue'
import ProductComponent from '../template/04_ProductComponent.vue'
import NewsView from '../views/NewsView.vue'
import ContactUsView from '../views/ContactUsView.vue'

const router = createRouter({
  linkActiveClass: 'active',
  history: createWebHistory(import.meta.env.BASE_URL),
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
          component: ProductComponent
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
