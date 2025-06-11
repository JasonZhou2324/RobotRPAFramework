from django.shortcuts import render

from data_visible.models import DataVisibleModel
from data_visible.serializers import DataVisibleModelSerializer, DataVisibleModelCreateUpdateSerializer
# Create your views here.
from admin.utils.viewset import CustomModelViewSet

class DataVisibleModelViewSet(CustomModelViewSet):
    """
    list:查询
    create:新增
    update:修改
    retrieve:单例
    destroy:删除
    """
    queryset = DataVisibleModel.objects.all()
    serializer_class = DataVisibleModelSerializer
    create_serializer_class = DataVisibleModelCreateUpdateSerializer
    update_serializer_class = DataVisibleModelCreateUpdateSerializer
