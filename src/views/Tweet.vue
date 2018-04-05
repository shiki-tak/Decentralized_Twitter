<template>
  <div class="tweet">
    <Article/>
  </div>
</template>

<script>
// @ is an alias to /src
import Article from '@/components/Article.vue'

export default {
  name: 'tweet',
  components: {
    Article
  }
}
</script>

<style>
.tweet {
  padding: 15px;
}
</style>
