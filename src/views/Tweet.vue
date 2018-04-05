<template>
  <div class="tweet">
    <DTweet/>
  </div>
</template>

<script>
// @ is an alias to /src
import DTweet from '@/components/DTweet.vue'

export default {
  name: 'tweet',
  components: {
    DTweet
  }
}
</script>

<style>
.tweet {
  padding: 15px;
}
</style>
