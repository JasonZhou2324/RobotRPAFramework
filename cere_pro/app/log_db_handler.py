#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@File    : log_db_handler.py
@Time    : 2025-04-09 10:31:51
@Author  : JackGong
"""
import logging
import datetime
import pymysql
import json
import re


class DatabaseLogHandler(logging.Handler):
    def __init__(self, db_config=None, keep_days=7):
        super().__init__()
        self.db_config = db_config or {}
        self.keep_days = keep_days
        self.cleaned_today = False

    def emit(self, record):
        try:
            today = datetime.date.today().strftime('%Y%m%d')
            table_name = f"log_{today}"
            self._write_to_db(table_name, record)

            if not self.cleaned_today:
                self._cleanup_old_tables()
                self.cleaned_today = True
        except Exception as e:
            print("DatabaseLogHandler emit failed:", e)

    def _write_to_db(self, table_name, record: logging.LogRecord):
        conn = pymysql.connect(**self.db_config)
        cursor = conn.cursor()

        # 建表，字段名为 func_name_line
        cursor.execute(f"""
            CREATE TABLE IF NOT EXISTS `{table_name}` (
                id INT AUTO_INCREMENT PRIMARY KEY,
                level VARCHAR(10),
                logger VARCHAR(255),
                func_name_line VARCHAR(255),
                message TEXT,
                created_at DATETIME(3)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        """)

        # 获取当前时间并格式化为精确到毫秒
        log_time = datetime.datetime.fromtimestamp(record.created).strftime('%Y-%m-%d %H:%M:%S.') + str(int(record.created * 1000) % 1000).zfill(3)

        # 创建函数名和行号信息
        func_name_line = f"{record.filename}:{record.lineno}::{record.funcName}()"

        # 插入数据时字段也要用 func_name_line
        cursor.execute(
            f"""INSERT INTO `{table_name}` (level, logger, func_name_line, message, created_at)
                VALUES (%s, %s, %s, %s, %s)""",
            (
                record.levelname,
                record.name,
                func_name_line,
                record.getMessage(),
                log_time,
            )
        )

        conn.commit()
        cursor.close()
        conn.close()

    def _cleanup_old_tables(self):
        conn = pymysql.connect(**self.db_config)
        cursor = conn.cursor()
        cursor.execute("SHOW TABLES")
        all_tables = [row[0] for row in cursor.fetchall()]

        valid_table_names = {
            f"log_{(datetime.date.today() - datetime.timedelta(days=i)).strftime('%Y%m%d')}"
            for i in range(self.keep_days)
        }

        for table in all_tables:
            if re.match(r"log_\d{8}$", table) and table not in valid_table_names:
                try:
                    cursor.execute(f"DROP TABLE `{table}`")
                    print(f"[DBLog] Deleted old table: {table}")
                except Exception as e:
                    print(f"[DBLog] Failed to delete {table}: {e}")

        conn.commit()
        cursor.close()
        conn.close()
