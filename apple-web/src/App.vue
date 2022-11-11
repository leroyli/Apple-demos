<template>
  <navtop></navtop>
  <router-view></router-view>
  <footer></footer>
</template>

<script>
import navtop from './components/NavTop.vue'
import footer from './components/Footer.vue'
export default {
  name: 'app',
  components: {
    navtop,
    footer
  }
}
</script>

<style lang="less">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

nav {
  padding: 30px;

  a {
    font-weight: bold;
    color: #2c3e50;

    &.router-link-exact-active {
      color: #42b983;
    }
  }
}
</style>
