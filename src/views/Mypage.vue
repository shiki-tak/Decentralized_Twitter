<template>
  <div class="mypage">
    <DTweet/>
  </div>
</template>

<script>
// @ is an alias to /src
import DTweet from '@/components/DTweet.vue'

export default {
  name: 'mypage',
  components: {
    DTweet
  }
}
</script>

<style>
.mypage {
  padding: 15px;
}
</style>
