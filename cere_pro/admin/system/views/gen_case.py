#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : gen_case.py
@Time    : 2025-05-27 10:31:51
@Author  : kongweige
"""
import requests
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status


class GenCaseView(APIView):
    """
    测试用例管理接口
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """

    def post(self, request):
        doc_text = request.data.get("content", "")
        if not doc_text:
            return Response({"error": "No content provided"}, status=status.HTTP_400_BAD_REQUEST)
        try:
            ai_response = requests.post("http://localhost:8001/chunk_doc", json={"content": doc_text})
            ai_response.raise_for_status()
            return Response(ai_response.json())
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
