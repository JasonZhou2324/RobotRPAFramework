#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : operation_log.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""
"""
@Remark: 操作日志管理
"""

from admin.system.models import OperationLog
from admin.utils.serializers import CustomModelSerializer
from admin.utils.viewset import CustomModelViewSet

class OperationLogSerializer(CustomModelSerializer):
    """
    日志-序列化器
    """

    class Meta:
        model = OperationLog
        fields = "__all__"
        read_only_fields = ["id"]


class OperationLogCreateUpdateSerializer(CustomModelSerializer):
    """
    操作日志  创建/更新时的列化器
    """

    class Meta:
        model = OperationLog
        fields = '__all__'


class OperationLogViewSet(CustomModelViewSet):
    """
    操作日志接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = OperationLog.objects.order_by('-create_datetime')
    serializer_class = OperationLogSerializer
    # permission_classes = []
