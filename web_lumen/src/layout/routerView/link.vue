<!--
@File    : link.vue
@Time    : 2025-04-09 11:12:24
@Author  : JackGong
-->

<template>
	<div class="layout-padding layout-link-container">
		<div class="layout-padding-auto layout-padding-view">
			<div class="layout-link-warp">
				<i class="layout-link-icon iconfont icon-xingqiu"></i>
				<div class="layout-link-msg">页面 "{{ $t(state.title) }}" 已在新窗口中打开</div>
				<el-button class="mt30" round size="default" @click="onGotoFullPage">
					<i class="iconfont icon-lianjie"></i>
					<span>立即前往体验</span>
				</el-button>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts" name="layoutLinkView">
import { reactive, watch } from 'vue';
import { useRoute } from 'vue-router';
import { verifyUrl } from '/@/utils/toolsValidate';
import {cookie} from "xe-utils";

// 定义变量内容
const route = useRoute();
const state = reactive<LinkViewState>({
	title: '',
	isLink: '',
  query: null
});

// 立即前往
const onGotoFullPage = () => {
	const { origin, pathname } = window.location;
  if (state.isLink.includes("{{token}}")) {
		state.isLink = state.isLink.replace("{{token}}", cookie.get('token'))
	}
	if (verifyUrl(<string>state.isLink)) window.open(state.isLink);
	else {
    function objectToUrlParams(obj: { [key: string]: string | number }): string {
      return Object.keys(obj)
          .map(key => encodeURIComponent(key) + '=' + encodeURIComponent(obj[key]))
          .join('&');
    }
    window.open(`${origin}${pathname}#${state.isLink}?${objectToUrlParams(state.query)}`)
  };
};
// 监听路由的变化，设置内容
watch(
	() => route.path,
	() => {
		state.title = <string>route.meta.title;
		state.isLink = <string>route.meta.isLink;
    state.query = <any>route.query;
	},
	{
		immediate: true,
	}
);
</script>

<style scoped lang="scss">
.layout-link-container {
	.layout-link-warp {
		margin: auto;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		i.layout-link-icon {
			position: relative;
			font-size: 100px;
			color: var(--el-color-primary);
			&::after {
				content: '';
				position: absolute;
				left: 50px;
				top: 0;
				width: 15px;
				height: 100px;
				background: linear-gradient(
					rgba(255, 255, 255, 0.01),
					rgba(255, 255, 255, 0.01),
					rgba(255, 255, 255, 0.01),
					rgba(255, 255, 255, 0.05),
					rgba(255, 255, 255, 0.05),
					rgba(255, 255, 255, 0.05),
					rgba(235, 255, 255, 0.5),
					rgba(255, 255, 255, 0.05),
					rgba(255, 255, 255, 0.05),
					rgba(255, 255, 255, 0.05),
					rgba(255, 255, 255, 0.01),
					rgba(255, 255, 255, 0.01),
					rgba(255, 255, 255, 0.01)
				);
				transform: rotate(-15deg);
				animation: toRight 5s linear infinite;
			}
		}
		.layout-link-msg {
			font-size: 12px;
			color: var(--next-bg-topBarColor);
			opacity: 0.7;
			margin-top: 15px;
		}
	}
}
</style>
