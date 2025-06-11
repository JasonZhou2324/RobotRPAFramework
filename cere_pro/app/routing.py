#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : routing.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""
from django.urls import path
from application.websocketConfig import MegCenter

websocket_urlpatterns = [
    path('ws/<str:service_uid>/', MegCenter.as_asgi()),  # consumers.DvadminWebSocket 是该路由的消费者
]
