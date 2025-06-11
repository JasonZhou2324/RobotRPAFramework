/**
 * @File    : messageCenter.ts
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

import {defineStore} from "pinia";
/**
 * 消息中心
 */
export const messageCenterStore = defineStore('messageCenter', {
    state: () => ({
        // 未读消息
        unread: 0
    }),
    actions: {
        async setUnread (number:any) {
           this.unread = number
        }
    },
});
