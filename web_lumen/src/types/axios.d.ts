/**
 * @File    : axios.d.ts
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

/* eslint-disable */
import * as axios from 'axios';

// 扩展 axios 数据返回类型，可自行扩展
declare module 'axios' {
	export interface AxiosResponse<T = any> {
		code: number;
		data: T;
		message: string;
		type?: string;
		[key: string]: T;
	}
}
