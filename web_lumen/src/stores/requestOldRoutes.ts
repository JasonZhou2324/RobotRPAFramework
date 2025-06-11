/**
 * @File    : requestOldRoutes.ts
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

import { defineStore } from 'pinia';

/**
 * 后端返回原始路由(未处理时)
 * @methods setCacheKeepAlive 设置接口原始路由数据
 */
export const useRequestOldRoutes = defineStore('requestOldRoutes', {
	state: (): RequestOldRoutesState => ({
		requestOldRoutes: [],
	}),
	actions: {
		async setRequestOldRoutes(routes: Array<string>) {
			this.requestOldRoutes = routes;
		},
	},
});
