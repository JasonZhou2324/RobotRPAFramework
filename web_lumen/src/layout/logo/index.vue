<!--
@File    : index.vue
@Time    : 2025-04-09 11:12:24
@Author  : JackGong
-->

<template>
	<div class="layout-logo" v-if="setShowLogo" @click="onThemeConfigChange">
		<img :src="siteLogo" class="layout-logo-medium-img" />
		<span style="margin-left:10px; font-size: x-large">{{ getSystemConfig['login.site_title'] || themeConfig.globalTitle }}</span>
	</div>
	<div class="layout-logo-size" v-else @click="onThemeConfigChange">
		<img :src="siteLogo" class="layout-logo-size-img" />
	</div>
</template>

<script setup lang="ts" name="layoutLogo">
import { computed } from 'vue';
import { storeToRefs } from 'pinia';
import { useThemeConfig } from '/@/stores/themeConfig';
import logoMini from '/@/assets/logo-mini.svg';
import { SystemConfigStore } from "/@/stores/systemConfig";
import _ from "lodash-es";
// 定义变量内容
const storesThemeConfig = useThemeConfig();
const { themeConfig } = storeToRefs(storesThemeConfig);

// 设置 logo 的显示。classic 经典布局默认显示 logo
const setShowLogo = computed(() => {
	let { isCollapse, layout } = themeConfig.value;
	return !isCollapse || layout === 'classic' || document.body.clientWidth < 1000;
});
// logo 点击实现菜单展开/收起
const onThemeConfigChange = () => {
	if (themeConfig.value.layout === 'transverse') return false;
	themeConfig.value.isCollapse = !themeConfig.value.isCollapse;
};

const systemConfigStore = SystemConfigStore()
const { systemConfig } = storeToRefs(systemConfigStore)
const getSystemConfig = computed(() => {
	return systemConfig.value
})

const siteLogo = computed(() => {
	if (!_.isEmpty(getSystemConfig.value['login.site_logo'])) {
		return getSystemConfig.value['login.site_logo']
	}
	return logoMini
});

</script>

<style scoped lang="scss">
.layout-logo {
	width: 220px;
	height: 60px;
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: rgb(0 21 41 / 2%) 0px 1px 4px;
	color: #ffffff;
  background-color: #3B3B3B;
	font-size: 16px;
	cursor: pointer;
	animation: logoAnimation 0.3s ease-in-out;

	span {
		white-space: nowrap;
		display: inline-block;
	}

	&:hover {
		span {
			color: var(--color-primary-light-2);
		}
	}

	&-medium-img {
		width: 40px;
		margin-right: 5px;
	}
}

.layout-logo-size {
	width: 100%;
	height: 60px;
	display: flex;
	cursor: pointer;
  background-color: #3B3B3B;
	animation: logoAnimation 0.3s ease-in-out;

	&-img {
		width: 40px;
		margin: auto;
	}

	&:hover {
		img {
			animation: logoAnimation 0.3s ease-in-out;
		}
	}
}
</style>
