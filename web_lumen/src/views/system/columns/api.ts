/**
 * @File    : api.ts
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

import { request } from '/@/utils/service';
import { PageQuery } from './types'

export function getRoleList(query: PageQuery) {
  return request({
    url: '/api/system/role/',
    method: 'get',
    params: query,
  });
}

export function getMenuList(query: PageQuery) {
  return request({
    url: '/api/system/menu/',
    method: 'get',
    params: {is_catalog:0,...query},
  });
}

export function getModelList() {
  return request({
    url: '/api/system/column/get_models/',
    method: 'get',
  });
}
