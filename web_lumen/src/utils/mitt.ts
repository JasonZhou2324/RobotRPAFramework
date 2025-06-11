/**
 * @File    : mitt.ts
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

// https://www.npmjs.com/package/mitt
import mitt, { Emitter } from 'mitt';

// 类型
const emitter: Emitter<MittType> = mitt<MittType>();

// 导出
export default emitter;
