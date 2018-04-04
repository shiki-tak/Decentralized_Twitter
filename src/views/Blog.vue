<template>
  <div class="blog">
    <Article/>
  </div>
</template>

<script>
// @ is an alias to /src
import Article from '@/components/Article.vue'

export default {
  name: 'blog',
  components: {
    Article
  }
}
</script>
