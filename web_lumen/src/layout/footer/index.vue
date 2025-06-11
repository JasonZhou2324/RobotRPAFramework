<!--
@File    : index.vue
@Time    : 2025-04-09 11:12:24
@Author  : JackGong
-->

<template>
	<div class="layout-footer pb5 pt2">
		<div class="layout-footer-warp">
			<div>❤️ Powered by Web_lumen Copyright © youibot ❤️</div>
		</div>
	</div>
</template>

<script setup lang="ts" name="layoutFooter">
// 此处需有内容（注释也得），否则缓存将失败
</script>

<style scoped lang="scss">
.layout-footer {
	width: 100%;
	display: flex;
	&-warp {
		margin: auto;
		color: var(--el-text-color-secondary);
		text-align: center;
		animation: error-num 0.3s ease;
	}
}
</style>
