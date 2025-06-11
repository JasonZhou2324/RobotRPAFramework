/**
 * @File    : RoleMenuTreeStores.ts
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

import { defineStore } from 'pinia';
import { RoleMenuTreeType } from '../types';
/**
 * 权限抽屉：角色-菜单
 */

export const RoleMenuTreeStores = defineStore('RoleMenuTreeStores', {
	state: (): RoleMenuTreeType => ({
		id: 0,
		parent: 0,
		name: '',
		isCheck: false,
		is_catalog: false,
	}),
	actions: {
		/** 赋值 */
		setRoleMenuTree(data: RoleMenuTreeType) {
			this.$state = data;
		},
	},
});
