<!--
@File    : index.vue
@Time    : 2025-04-09 11:12:24
@Author  : JackGong
-->

<template>
	<fs-page>
		<fs-crud ref="crudRef" v-bind="crudBinding"> </fs-crud>
	</fs-page>
</template>

<script lang="ts" setup name="loginLog">
import { onMounted } from 'vue';
import { useFs } from '@fast-crud/fast-crud';
import { createCrudOptions } from './crud';
import { GetPermission } from './api';
import { handleColumnPermission } from '/@/utils/columnPermission';

const { crudBinding, crudRef, crudExpose, crudOptions, resetCrudOptions } = useFs({ createCrudOptions });

// 页面打开后获取列表数据
onMounted(async () => {
	// 设置列权限
	const newOptions = await handleColumnPermission(GetPermission, crudOptions);
	//重置crudBinding
	resetCrudOptions(newOptions);
	// 刷新
	crudExpose.doRefresh();
});
</script>
