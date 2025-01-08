## Django 모델 생성 : 다이어리 내용을 저장할 테이블 생성
## 작성 완료 후, makemigrations -> migrate (완)
from django.db import models

class Diary(models.Model):
    id = models.AutoField(primary_key=True) # 자동으로 증가하는 기본키
    text = models.TextField() # 일기 내용
    sentiment = models.CharField(max_length=20) # 감정 분석 결과
    created_at = models.DateTimeField(auto_now_add=True) # 생성 시간
    
    def __str__(self):
        return f"[{self.created_at}]  {self.sentiment} - {self.text[:20]}..." 