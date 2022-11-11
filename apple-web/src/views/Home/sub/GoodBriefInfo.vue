<template>
  <div class="homecontainer" :style="' background-color:'+String(backgoundcolor)">
     <GoodTitle :goodname="goodname" :goodinfo="goodinfo" :fontcolor="fontcolor" />
     <img :src="imgsrc" alt="iphonese">
  </div>
</template>

<script>
import GoodsTitle from '../../../components/GoodsTitle.vue'

export default {
  name: '',
  components: {
      GoodsTitle
  },
  props:['goodname','goodinfo','fontcolor','imgsrc','backgoundcolor']
}
</script>

<style lang="less" scoped>
.homecontainer{
    position: relative;
    width: 100%;
    display: flex;
    flex-direction:column-reverse;
    justify-content: center;
    align-items: center;
    min-height: 500px;
    font-size: 1em;
    padding-top:10%;
    margin-bottom: 13px;
    img{
        width:100%;
        height: auto;
        -webkit-transition:width 1s, height 1s,
        -webkit-transform 1s;
    transition:width 1s, height 1s, transform 1s;
    }
    img:hover{
      width: 110%;
      height: 110%;
    }
}
</style>
