#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : wsgi.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'application.settings')
os.environ["DJANGO_ALLOW_ASYNC_UNSAFE"] = "true"

app = get_wsgi_application()
