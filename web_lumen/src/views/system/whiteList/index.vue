<!--
@File    : index.vue
@Time    : 2025-04-09 11:12:24
@Author  : JackGong
-->

<template>
    <fs-page>
        <fs-crud ref="crudRef" v-bind="crudBinding"></fs-crud>
    </fs-page>
</template>

<script lang="ts" setup name="whiteList">
import {ref, onMounted} from 'vue';
import {useFs} from '@fast-crud/fast-crud';
import {createCrudOptions} from './crud';

const {crudBinding, crudRef, crudExpose} = useFs({createCrudOptions});

// 页面打开后获取列表数据
onMounted(() => {
    crudExpose.doRefresh();
});
</script>
