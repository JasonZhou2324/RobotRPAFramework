<!--
@File    : userNews.vue
@Time    : 2025-04-09 11:12:24
@Author  : JackGong
-->

<template>
	<div class="layout-navbars-breadcrumb-user-news">
		<div class="head-box">
			<div class="head-box-title">{{ $t('message.user.newTitle') }}</div>
<!--			<div class="head-box-btn" v-if="state.newsList.length > 0" @click="onAllReadClick">{{ $t('message.user.newBtn') }}</div>-->
		</div>
		<div class="content-box">
			<template v-if="state.newsList.length > 0">
				<div class="content-box-item" v-for="(v, k) in state.newsList" :key="k">
					<div>{{ v.title }}</div>
					<div class="content-box-msg">
						<div v-html="v.content"></div>
					</div>
					<div class="content-box-time">{{ v.create_datetime }}</div>
				</div>
			</template>
			<el-empty :description="$t('message.user.newDesc')" v-else></el-empty>
		</div>
		<div class="foot-box" @click="onGoToGiteeClick" v-if="state.newsList.length > 0">{{ $t('message.user.newGo') }}</div>
	</div>
</template>

<script setup lang="ts" name="layoutBreadcrumbUserNews">
import { reactive,onBeforeMount,ref,onMounted } from 'vue';

// 定义变量内容
const state = reactive({
	newsList: [] as any,
});

// 全部已读点击
const onAllReadClick = () => {
	state.newsList = [];
};
// 前往通知中心点击
import {useRouter } from "vue-router";
const route = useRouter()
const onGoToGiteeClick = () => {
  route.push('/messageCenter')
};
//获取最新消息
import { request } from "/@/utils/service";
const getLastMsg= ()=>{
  request({
    url: '/api/system/message_center/get_newest_msg/',
    method: 'get',
    params: {}
  }).then((res:any) => {
    const { data } = res
    state.newsList= [data]
  })
}
onMounted(()=>{
  getLastMsg()
})

</script>

<style scoped lang="scss">
.layout-navbars-breadcrumb-user-news {
	.head-box {
		display: flex;
		border-bottom: 1px solid var(--el-border-color-lighter);
		box-sizing: border-box;
		color: var(--el-text-color-primary);
		justify-content: space-between;
		height: 35px;
		align-items: center;
		.head-box-btn {
			color: var(--el-color-primary);
			font-size: 13px;
			cursor: pointer;
			opacity: 0.8;
			&:hover {
				opacity: 1;
			}
		}
	}
	.content-box {
		font-size: 13px;
		.content-box-item {
			padding-top: 12px;
			&:last-of-type {
				padding-bottom: 12px;
			}
			.content-box-msg {
				color: var(--el-text-color-secondary);
				margin-top: 5px;
				margin-bottom: 5px;
			}
			.content-box-time {
				color: var(--el-text-color-secondary);
			}
		}
	}
	.foot-box {
		height: 35px;
		color: var(--el-color-primary);
		font-size: 13px;
		cursor: pointer;
		opacity: 0.8;
		display: flex;
		align-items: center;
		justify-content: center;
		border-top: 1px solid var(--el-border-color-lighter);
		&:hover {
			opacity: 1;
		}
	}
	:deep(.el-empty__description p) {
		font-size: 13px;
	}
}
</style>
