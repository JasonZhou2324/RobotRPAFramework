#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : __init__.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""

# This will make sure the application is always imported when
# Django starts so that shared_task will use this application.
from .celery import app as celery_app

__all__ = ('application',)