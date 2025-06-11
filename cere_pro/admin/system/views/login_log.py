#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : login_log.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""

from admin.system.models import LoginLog
from admin.utils.field_permission import FieldPermissionMixin
from admin.utils.serializers import CustomModelSerializer
from admin.utils.viewset import CustomModelViewSet


class LoginLogSerializer(CustomModelSerializer):
    """
    登录日志权限-序列化器
    """

    class Meta:
        model = LoginLog
        fields = "__all__"
        read_only_fields = ["id"]


class LoginLogViewSet(CustomModelViewSet, FieldPermissionMixin):
    """
    登录日志接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = LoginLog.objects.all()
    serializer_class = LoginLogSerializer
    # extra_filter_class = []
