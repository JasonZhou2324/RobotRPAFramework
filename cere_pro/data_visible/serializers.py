#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : serializers.py
@Time    : 2025/4/10 15:25
@Author  : JackGong
"""
from data_visible.models import DataVisibleModel
#backend/crud_demo/serializers.py
from admin.utils.serializers import CustomModelSerializer

class DataVisibleModelSerializer(CustomModelSerializer):
    """
    序列化器
    """
#这里是进行了序列化模型及所有的字段
    class Meta:
        model = DataVisibleModel
        fields = "__all__"

#这里是创建/更新时的列化器
class DataVisibleModelCreateUpdateSerializer(CustomModelSerializer):
    """
    创建/更新时的列化器
    """

    class Meta:
        model = DataVisibleModel
        fields = '__all__'