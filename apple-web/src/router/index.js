import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home/Home.vue'
import Mac from '../views/Mac/Mac.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
    meta: {
      index: 1
    }
  },
  {
    path:'/mac',
    name: 'mac',
    component: Mac,
    meta: {
      index: 2
    }
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
