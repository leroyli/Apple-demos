<template>
  <div class="maccontainer _maccontainer">
    <SubNavGuide />
    <MacBriefInfo :isnew="'yes'" :reversedirection="'yes'" :screensize="'13英寸'"  :goodsignature="'行动，行动力'" :imgsrc="require('./imgs/macbook_pro_13__1.jpg')"/>
    <MacBriefInfo :goodsignature="'够轻，够轻快'" :imgsrc="require('./imgs/macbook_air__1.jpg')"/>
  </div>
</template>

<script>
import SubNavGuide from './sub/SubNavGuide.vue'
import MacBriefInfo from "./sub/MacBriefInfo.vue"

export default {
  name: 'mac',
  components: {
    SubNavGuide,
    MacBriefInfo
  }
}
</script>

<style lang="less" scoped>

// 大于800px
@media only screen and (min-width: 800px){
    
}

// 小于800px
@media only screen and (max-width: 800px){
    
  
}
</style>
