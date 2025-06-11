<!--
@File    : index.vue
@Time    : 2025-04-09 11:12:24
@Author  : JackGong
-->

<template>
  <div>
    {{ data }}
  </div>
</template>
<script setup lang="ts">
import {defineProps,ref,watch} from 'vue'
import {useDeptInfoStore} from '/@/stores/modules/dept'
const props = defineProps({
  modelValue:{
    type: Number || String
  }
})
const data = ref()
watch(()=>{
  return props.modelValue
},async (newVal)=>{
  const deptInfoStore = useDeptInfoStore()
  const result = await deptInfoStore.getParentDeptById(newVal)
  if(result?.nodes){
    let name = ""
    console.log(result)
    result.nodes.forEach((item:any,index:number)=>{
      name +=  index>0?`/${item.name}`:item.name
    })
    data.value = name
  }
},{immediate: true} )
</script>
