/**
 * @File    : index.ts
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

import { request } from "/@/utils/service";

/**
 * 后端控制菜单模拟json，路径在 https://gitee.com/lyt-top/vue-next-admin-images/tree/master/menu
 * 后端控制路由，isRequestRoutes 为 true，则开启后端控制路由
 * @method getMenuAdmin 获取后端动态路由菜单(admin)
 * @method getMenuTest 获取后端动态路由菜单(test)
 */
export function useMenuApi() {
	return {
		getSystemMenu: (params?: object) => {
			return request({
				url: '/api/system/menu/web_router/',
				method: 'get',
				params,
			});
		},
		getMenuAdmin: (params?: object) => {
			return request({
				url: '/gitee/lyt-top/vue-next-admin-images/raw/master/menu/adminMenu.json',
				method: 'get',
				params,
			});
		},
		getMenuTest: (params?: object) => {
			return request({
				url: '/gitee/lyt-top/vue-next-admin-images/raw/master/menu/testMenu.json',
				method: 'get',
				params,
			});
		},
	};
}
