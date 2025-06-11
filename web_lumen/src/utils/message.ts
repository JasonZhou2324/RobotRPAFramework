/**
 * @File    : message.ts
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

import { ElMessage, ElNotification, MessageOptions } from 'element-plus';

export function message(message: string, option?: MessageOptions) {
	ElMessage({ message, ...option });
}
export function successMessage(message: string, option?: MessageOptions) {
	ElMessage({ message, type: 'success' });
}
export function warningMessage(message: string, option?: MessageOptions) {
	ElMessage({ message, ...option, type: 'warning' });
}
export function errorMessage(message: string, option?: MessageOptions) {
	ElMessage({ message, ...option, type: 'error' });
}
export function infoMessage(message: string, option?: MessageOptions) {
	ElMessage({ message, ...option, type: 'info' });
}

export function notification(message: string) {
	ElNotification({ message });
}
export function successNotification(message: string) {
	ElNotification({ message, type: 'success' });
}
export function warningNotification(message: string) {
	ElNotification({ message, type: 'warning' });
}
export function errorNotification(message: string) {
	ElNotification({ message, type: 'error' });
}
export function infoNotification(message: string) {
	ElNotification({ message, type: 'info' });
}
