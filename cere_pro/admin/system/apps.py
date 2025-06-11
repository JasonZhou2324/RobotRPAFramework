#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : apps.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""

from django.apps import AppConfig


class SystemConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'admin.system'
