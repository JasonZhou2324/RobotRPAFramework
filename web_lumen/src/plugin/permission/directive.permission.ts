/**
 * @File    : directive.permission.ts
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

import permissionUtil from './func.permission'
export default {
  mounted (el:any, binding:any) {
    const { value } = binding
    const hasPermission = permissionUtil.hasPermissions(value)
    if (!hasPermission) {
      el.parentNode && el.parentNode.removeChild(el)
    }
  }
}
