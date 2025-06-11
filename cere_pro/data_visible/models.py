from django.db import models

# Create your models here.
from admin.utils.models import CoreModel

class DataVisibleModel(CoreModel):
    task_id = models.CharField(max_length=255, verbose_name="任务编号")
    task_desc = models.IntegerField(verbose_name="任务描述")
    task_bot = models.FloatField(verbose_name="执行机器人")
    create_time = models.DateField(verbose_name="创建时间")

    class Meta:
        db_table = "DataVisible"
        verbose_name = '数据可视化表'
        verbose_name_plural = verbose_name
        ordering = ('-create_time',)
