# Django URL 라우팅 시스템을 사용해 클라이언트가 요청을 보낼 수 있는 API 엔드포인트 설정
from django.urls import path
from .views import analyze_diary 

urlpatterns = [
    path('analyze', analyze_diary, name='analyze_diary')
]