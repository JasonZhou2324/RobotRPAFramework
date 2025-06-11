#!/bin/bash
# python manage.py makemigrations
# python manage.py migrate
# python manage.py init -y
uvicorn cere_pro.asgi:cere_pro --port 8000 --host 0.0.0.0 --workers 4
