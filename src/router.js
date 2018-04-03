import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import Timeline from './views/Timeline.vue'
import Blog from './views/Blog.vue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/timeline',
      name: 'Timeline',
      component: Timeline
    },
    {
      path: '/blog',
      name: 'blog',
      component: Blog
    }
  ]
})
