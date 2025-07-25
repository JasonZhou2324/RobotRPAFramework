#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : string_util.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""

import hashlib
import random

CHAR_SET = ("2", "3", "4", "5",
            "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H",
            "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "U", "V",
            "W", "X", "Y", "Z")


def random_str(number=16):
    """
    返回特定长度的随机字符串(非进制)
    :return:
    """
    result = ""
    for i in range(0, number):
        inx = random.randint(0, len(CHAR_SET) - 1)
        result += CHAR_SET[inx]
    return result


def has_md5(str, salt='123456'):
    """
    md5 加密
    :param str:
    :param salt:
    :return:
    """
    # satl是盐值，默认是123456
    str = str + salt
    md = hashlib.md5()  # 构造一个md5对象
    md.update(str.encode())
    res = md.hexdigest()
    return res
