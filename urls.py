"""
URL configuration for myproject project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
## add new API endpoint
from diary_app.views import analyze_diary, get_diary_entries, delete_diary_entry

urlpatterns = [
    #path("admin/", admin.site.urls),
    path('analyze/',analyze_diary), # 일기 내용을 서버로 전송하고 감정 분석 결과 반환
    path('diary_entries/',get_diary_entries), # 서버에 저장된 모든 일기 기록을 조회
    path('diary_entries/<int:diary_id>/', delete_diary_entry), # request delete
    path('', include('diary_app.urls')) # include app's urls.py
]