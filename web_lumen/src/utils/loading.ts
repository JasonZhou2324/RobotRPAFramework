/**
 * @File    : loading.ts
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

import { nextTick } from 'vue';
import '/@/theme/loading.scss';
import { showUpgrade } from "/@/utils/upgrade";


/**
 * 页面全局 Loading
 * @method start 创建 loading
 * @method done 移除 loading
 */
export const NextLoading = {
	// 创建 loading
	start: () => {
		// 显示升级提示
		showUpgrade()
		const bodys: Element = document.body;
		const div = <HTMLElement>document.createElement('div');
		div.setAttribute('class', 'loading-next');
		const htmls = `
			<div class="loading-next-box">
				<div class="loading-next-box-warp">
					<div class="loading-next-box-item"></div>
					<div class="loading-next-box-item"></div>
					<div class="loading-next-box-item"></div>
					<div class="loading-next-box-item"></div>
					<div class="loading-next-box-item"></div>
					<div class="loading-next-box-item"></div>
					<div class="loading-next-box-item"></div>
					<div class="loading-next-box-item"></div>
					<div class="loading-next-box-item"></div>
				</div>
			</div>
		`;
		div.innerHTML = htmls;
		bodys.insertBefore(div, bodys.childNodes[0]);
		window.nextLoading = true;
	},
	// 移除 loading
	done: (time: number = 0) => {
		nextTick(() => {
			setTimeout(() => {
				window.nextLoading = false;
				const el = <HTMLElement>document.querySelector('.loading-next');
				el?.parentNode?.removeChild(el);
			}, time);
		});
	},
};
