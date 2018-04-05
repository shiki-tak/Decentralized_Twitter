<template>
  <div id="app">
    <div class="header">
      <div id="nav">
        <router-link to="/">Home</router-link> |
        <router-link to="/timeline"> Timeline</router-link> |
        <router-link to="/mypage">Mypage</router-link>
      </div>
    </div>
    <router-view/>
  </div>
</template>

<script>
import Web3 from 'web3'

export default {
  name: 'App',
}
</script>

<style lang="scss">
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  color: #2c3e50;
}

#nav {
  a {
    font-weight: bold;
    color: #2c3e50;
    &.router-link-exact-active {
      color: #42b983;
    }
  }
  padding-top: 15px;
  padding-left: 15px;
}

.header {
  background-color: #303030;
  height: 48px;
  width: 100%;
}

#nav a {
  color: white;
}
</style>
