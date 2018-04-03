<template>
  <div class="blog">
    <h3>This is an blog page</h3>
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
