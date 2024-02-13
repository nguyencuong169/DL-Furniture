import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import GalleryView from '../views/GalleryView.vue'
import AboutView from '../views/AboutView.vue'
import ProductView from '../views/ProductView.vue'
import ProjectView from '../views/ProjectView.vue'
import ProductDetailView from '../views/ProductDetailView.vue'
import NotFoundComponent from '../template/15_NotFoundComponent.vue'
import ProductComponent from '../template/04_ProductComponent.vue'

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
      path: '/about',
      name: 'about',
      component: AboutView
    },
    {
      path: '/gallery',
      name: 'gallery',
      component: GalleryView
    },
    {
      path: '/project',
      name: 'project',
      component: ProjectView
    },
    {
      path: '/product',
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
          path: '/phong-khach',
          name: 'phongkhach',
          component: ProductView,
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
          component: ProductView
        }
      ]
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
