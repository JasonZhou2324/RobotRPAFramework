#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : dictionary.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""

from rest_framework import serializers
from rest_framework.views import APIView

from app import dispatch
from admin.system.models import Dictionary
from admin.utils.json_response import SuccessResponse
from admin.utils.serializers import CustomModelSerializer
from admin.utils.viewset import CustomModelViewSet


class DictionarySerializer(CustomModelSerializer):
    """
    字典-序列化器
    """

    class Meta:
        model = Dictionary
        fields = "__all__"
        read_only_fields = ["id"]





class DictionaryCreateUpdateSerializer(CustomModelSerializer):
    """
    字典管理 创建/更新时的列化器
    """
    value = serializers.CharField(max_length=100)

    def validate_value(self, value):
        """
        在父级的字典编号验证重复性
        """
        initial_data = self.initial_data
        parent = initial_data.get('parent',None)
        if parent is None:
            unique =  Dictionary.objects.filter(value=value).exists()
            if unique:
                raise serializers.ValidationError("字典编号不能重复")
        return value

    class Meta:
        model = Dictionary
        fields = '__all__'


class DictionaryViewSet(CustomModelViewSet):
    """
    字典管理接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = Dictionary.objects.all()
    serializer_class = DictionarySerializer
    create_serializer_class = DictionaryCreateUpdateSerializer
    extra_filter_class = []
    search_fields = ['label']

    def get_queryset(self):
        if self.action =='list':
            params = self.request.query_params
            parent = params.get('parent', None)
            if params:
                if parent:
                    queryset = self.queryset.filter(parent=parent)
                else:
                    queryset = self.queryset.filter(parent__isnull=True)
            else:
                queryset = self.queryset.filter(parent__isnull=True)
            return queryset
        else:
            return self.queryset


class InitDictionaryViewSet(APIView):
    """
    获取初始化配置
    """
    authentication_classes = []
    permission_classes = []
    queryset = Dictionary.objects.all()

    def get(self, request):
        dictionary_key = self.request.query_params.get('dictionary_key')
        if dictionary_key:
            if dictionary_key == 'all':
                data = [ele for ele in dispatch.get_dictionary_config().values()]
                if not data:
                    dispatch.refresh_dictionary()
                    data = [ele for ele in dispatch.get_dictionary_config().values()]
            else:
                data = self.queryset.filter(parent__value=dictionary_key, status=True).values('label', 'value', 'type',
                                                                                              'color')
            return SuccessResponse(data=data, msg="获取成功")
        return SuccessResponse(data=[], msg="获取成功")
