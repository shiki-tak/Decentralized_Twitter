<template>
  <div class="blog">
    <CreateArticle/>
  </div>
</template>

<script>
// @ is an alias to /src
import CreateArticle from '@/components/CreateArticle.vue'

export default {
  name: 'blog',
  components: {
    CreateArticle
  }
}
</script>
