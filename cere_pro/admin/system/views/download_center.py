#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : download_center.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""

from rest_framework import serializers
from django.conf import settings
from django_filters.rest_framework import FilterSet, CharFilter
from django.contrib.auth.models import AnonymousUser

from admin.utils.serializers import CustomModelSerializer
from admin.utils.viewset import CustomModelViewSet
from admin.system.models import DownloadCenter


class DownloadCenterSerializer(CustomModelSerializer):
    url = serializers.SerializerMethodField(read_only=True)

    def get_url(self, instance):
        if self.request.query_params.get('prefix'):
            if settings.ENVIRONMENT in ['local']:
                prefix = 'http://127.0.0.1:8000'
            elif settings.ENVIRONMENT in ['test']:
                prefix = 'http://{host}/api'.format(host=self.request.get_host())
            else:
                prefix = 'https://{host}/api'.format(host=self.request.get_host())
            return (f'{prefix}/media/{str(instance.url)}')
        return f'media/{str(instance.url)}'

    class Meta:
        model = DownloadCenter
        fields = "__all__"
        read_only_fields = ["id"]


class DownloadCenterFilterSet(FilterSet):
    task_name = CharFilter(field_name='task_name', lookup_expr='icontains')
    file_name = CharFilter(field_name='file_name', lookup_expr='icontains')

    class Meta:
        model = DownloadCenter
        fields = ['task_status', 'task_name', 'file_name']


class DownloadCenterViewSet(CustomModelViewSet):
    queryset = DownloadCenter.objects.all()
    serializer_class = DownloadCenterSerializer
    filter_class = DownloadCenterFilterSet
    permission_classes = []
    extra_filter_class = []

    def get_queryset(self):
        # 处理 swagger schema fake view 情况
        if getattr(self, 'swagger_fake_view', False):
            return super().get_queryset().none()

        # 避免未登录用户查询（AnonymousUser 不能参与过滤）
        if isinstance(self.request.user, AnonymousUser):
            return super().get_queryset().none()

        # 已登录用户，正常过滤
        return super().get_queryset().filter(creator=self.request.user)

        # if self.request.user.is_superuser:
        #     return super().get_queryset()
        # return super().get_queryset().filter(creator=self.request.user)
