#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : signals.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""

from django.dispatch import Signal
# 初始化信号
pre_init_complete = Signal()
detail_init_complete = Signal()
post_init_complete = Signal()
# 租户初始化信号
pre_tenants_init_complete = Signal()
detail_tenants_init_complete = Signal()
post_tenants_init_complete = Signal()
post_tenants_all_init_complete = Signal()
# 租户创建完成信号
tenants_create_complete = Signal()
