#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : asgi.py
@Time    : 2025-04-09 10:31:32
@Author  : JackGong
"""
import os
from channels.auth import AuthMiddlewareStack
from channels.security.websocket import AllowedHostsOriginValidator
from channels.routing import ProtocolTypeRouter, URLRouter
from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'application.settings')
os.environ["DJANGO_ALLOW_ASYNC_UNSAFE"] = "true"

http_application = get_asgi_application()

from app.routing import websocket_urlpatterns

application = ProtocolTypeRouter({
    "http": http_application,
    'websocket': AllowedHostsOriginValidator(
        AuthMiddlewareStack(
            URLRouter(
                websocket_urlpatterns  # 指明路由文件是devops/routing.py
            )
        )
    ),
})
