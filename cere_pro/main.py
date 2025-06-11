#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : main.py
@Time    : 2025/3/31 11:17
@Author  : JackGong
"""
import os
import sys
import uvicorn
import multiprocessing
from app.settings import LOGGING

root_path = os.getcwd()
sys.path.append(root_path)

if __name__ == '__main__':
    multiprocessing.freeze_support()
    workers = 4
    if os.sys.platform.startswith('win'):
        # Windows操作系统
        workers = None
    uvicorn.run("application.asgi:application", reload=False, host="0.0.0.0", port=8000, workers=workers,
                log_config=LOGGING)
