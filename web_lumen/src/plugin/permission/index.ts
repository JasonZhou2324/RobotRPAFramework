/**
 * @File    : index.ts
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

import permissionDirective from './directive.permission'
import permissionFunc from './func.permission'
export const RegisterPermission = function (app:any) {
  app.directive('permission', permissionDirective)
  app.provide('$hasPermissions',permissionFunc.hasPermissions)
}
