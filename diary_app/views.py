# 감정분석 BERT 모델.ver
import torch
from rest_framework.response import Response
from rest_framework.decorators import api_view
from transformers import pipeline # BERT 모델 사용
from googletrans import Translator # 구글 번역 라이브러리

from django.db import transaction # For use the transaciton
from .models import Diary # add Diary model
from django.utils.dateparse import parse_date
import warnings
warnings.filterwarnings('ignore')

### BERT 감정 분석 파이프라인 초기화
# GPU 사용할 환경이면 device=0
# model => Hugging face 에서 개발한 모델
sentiment_analyzer = pipeline("sentiment-analysis", model="transformersbook/distilbert-base-uncased-finetuned-emotion", device=-1)

### translator 초기화
translator = Translator()

### 감성 분석 API
@api_view(['POST'])
def analyze_diary(request):
    diary_text = request.data.get("diaryText")
    if not diary_text:
        return Response({"error":"No diary text provided"}, status=400)
    try:
        ## Step1 : Korean -> Japanese
        japanese_text = translator.translate(diary_text, src='ko',dest='ja').text
        
        ## Step2 : Japanese -> english
        english_text = translator.translate(japanese_text, src='ja',dest='en').text
        
        ## sentiment analyze
        analysis = sentiment_analyzer(english_text)
        # 결과 라벨 가져오기
        sentiment = analysis[0]['label'] 
        
        ## Save to DB
        with transaction.atomic(): # commit only all tesk completed
            diary = Diary.objects.create(
                text=diary_text,
                sentiment=sentiment
            )
        
        ## API response
        return Response({
            # 이 message는 어디서 확인 가능하냐고 ;; 관리자 창인가 (아님)
            "message":"Diary saved successfully",
            "sentiment": sentiment,
            "diary_id":diary.id # return new created diary_id
        })
        
    except Exception as e:
        return Response({"error":f"Internal server error: {str(e)}"}, status=500)

### target date의 일기 기록 조회 API
@api_view(['GET'])
def get_diary_entries(request, date):
    try:
        # convert str -> datetime
        parsed_date = parse_date(date)
        if not parsed_date:
            return Response({"error":"Invalid date format"}, status=400)
        
        # Filter diary entries for the specific date
        diary_entries = Diary.objects.filter(created_at__date=parsed_date).order_by('-created_at')
        diary_list = [
            {
                "id": entry.id,
                "text": entry.text,
                "sentiment": entry.sentiment,
                "created_at": entry.created_at.strftime('%Y-%m-%d %H:%M:%S')
            } for entry in diary_entries
        ]
        return Response(diary_list)
    except Exception as e:
        return Response({"error":"Internal server error: {str(e)}"}, status=500)


### 일기 삭제 API
@api_view(['DELETE'])
def delete_diary_entry(request, diary_id):
    try:
        diary = Diary.objects.get(id=diary_id)
        diary.delete()
        return Response({"message":"Diary deleted successfully."}, status=200)
    except Diary.DoesNotExist:
        return Response({"error":"Diary entry not found."}, status=404)
    except Exception as e:
        return Response({"error":f"Internal server error: {str(e)}"}, status=500)