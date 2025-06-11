#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : urls
@Time    : 2025/4/10 15:28
@Author  : JackGong
"""
#backend/crud_demo/urls.py

from rest_framework.routers import SimpleRouter

from .views import DataVisibleModelViewSet

router = SimpleRouter()
# 这里进行注册路径，并把视图关联上，这里的api地址以视图名称为后缀，这样方便记忆api/CrudDemoModelViewSet
router.register("api/DataVisibleModelViewSet", DataVisibleModelViewSet)

urlpatterns = [
]
urlpatterns += router.urls