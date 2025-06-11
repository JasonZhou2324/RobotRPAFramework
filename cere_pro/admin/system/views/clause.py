#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : clause.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""

from rest_framework.views import APIView
from django.shortcuts import render


class PrivacyView(APIView):
    """
    后台隐私政策
    """
    permission_classes = []

    def get(self, request, *args, **kwargs):
        return render(request, 'privacy.html')



class TermsServiceView(APIView):
    """
    后台服务条款
    """
    permission_classes = []

    def get(self, request, *args, **kwargs):
        return render(request, 'terms_service.html')
