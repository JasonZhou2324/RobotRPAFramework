<!--
@File    : subItem.vue
@Time    : 2025-04-09 11:12:24
@Author  : JackGong
-->

<template>
	<template v-for="val in chils">
		<el-sub-menu :index="val.path" :key="val.path" v-if="val.children && val.children.length > 0">
			<template #title>
				<SvgIcon style="color: var(--menu-text-color);" :name="val.meta.icon" />
				<span style="color: var(--menu-text-color);">{{ $t(val.meta.title) }}</span>
			</template>
			<sub-item :chil="val.children" />
		</el-sub-menu>
		<template v-else>
      <a v-if="val.name==='templateCenter'" href="#/templateCenter" target="_blank">
        <el-menu-item   :key="val.path">
          <template v-if="!val.meta.isLink || (val.meta.isLink && val.meta.isIframe)">
            <SvgIcon :name="val.meta.icon" />
            <span>{{ $t(val.meta.title) }}</span>
          </template>
          <template v-else>
            <a class="w100" @click.prevent="onALinkClick(val)">
              <SvgIcon :name="val.meta.icon" />
              {{ $t(val.meta.title) }}
            </a>
          </template>
        </el-menu-item>
      </a>
			<el-menu-item v-else :index="val.path" :key="val.path">
				<template v-if="!val.meta.isLink || (val.meta.isLink && val.meta.isIframe)">
					<SvgIcon :name="val.meta.icon" />
					<span>{{ $t(val.meta.title) }}</span>
				</template>
				<template v-else>
					<a class="w100" @click.prevent="onALinkClick(val)">
						<SvgIcon :name="val.meta.icon" />
						{{ $t(val.meta.title) }}
					</a>
				</template>
			</el-menu-item>
		</template>
	</template>
</template>

<script setup lang="ts" name="navMenuSubItem">
import { computed } from 'vue';
import { RouteRecordRaw } from 'vue-router';
import other from '/@/utils/other';

// 定义父组件传过来的值
const props = defineProps({
	// 菜单列表
	chil: {
		type: Array<RouteRecordRaw>,
		default: () => [],
	},
});

// 获取父级菜单数据
const chils = computed(() => {
	return <RouteItems>props.chil;
});
// 打开外部链接
const onALinkClick = (val: RouteItem) => {
	other.handleOpenLink(val);
};
</script>

<style scoped lang="scss">
::v-deep .el-menu {
  background-color: #F6F6F6 !important;
}

::v-deep .el-menu .el-menu-item {
  color: #4E5969 !important;
}

::v-deep .el-menu {
  color: #4E5969 !important;
}

::v-deep .el-menu .el-menu-item.is-active {
  color: #EE742A !important;
}
</style>
