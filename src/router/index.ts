import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import GalleryView from '../views/GalleryView.vue'
import AboutView from '../views/AboutView.vue'
import ProductView from '../views/ProductView.vue'
import ProjectView from '../views/ProjectView.vue'
import ProductDetailView from '../views/ProductDetailView.vue'
import NotFoundComponent from '../template/015_NotFoundComponent.vue'

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
          path: '/product/phong-ngu/:id',
          name: 'phongngu',
          component: ProductView
        },
        {
          path: '/product/phong-khach/:id',
          name: 'phongkhach',
          component: ProductView
        },
        {
          path: '/product/phong-bep/:id',
          name: 'phongbep',
          component: ProductView
        }
      ]
    },
    {
      path: '/product/detail/:id',
      name: 'detail',
      component: ProductDetailView
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
