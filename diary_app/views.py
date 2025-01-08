# 감정분석 BERT 모델.ver
import torch
from rest_framework.response import Response
from rest_framework.decorators import api_view
from transformers import pipeline # BERT 모델 사용
from googletrans import Translator # 구글 번역 라이브러리

from django.db import transaction # For use the transaciton
from .models import Diary # add Diary model
import warnings
warnings.filterwarnings('ignore')

# BERT 감정 분석 파이프라인 초기화
# GPU 사용할 환경이면 device=0
# model => Hugging face 에서 개발한 모델
sentiment_analyzer = pipeline("sentiment-analysis", model="distilbert-base-uncased-finetuned-sst-2-english", device=-1)

## translator 초기화
translator = Translator()

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
        
        # 영어 텍스트가 문자열인지 확인
        if not isinstance(english_text,str):
            raise Response({"error":"Translated text is not a valid string."}, status=400)
        
        # sentiment analyze
        analysis = sentiment_analyzer(english_text)
        # 결과 라벨 가져오기
        sentiment = analysis[0]['label'] #Positive or Negative or Neutral
        
        ## Step3 : save diary data
        # -> 여기서 error 발생
        # with transaction.atomic(): # commit only all tesk completed
        #     diary = Diary.objects.create(
        #         text=diary_text,
        #         sentiment=sentiment
        #     )
        
        ## API response
        return Response({
            # 메세지는 어디서 확인 가능함 ?
            "message":"Diary saved successfully",
            "sentiment": sentiment,
           # "diary_id":diary.id # return new created diary_id
        })
        
    except Exception as e:
        return Response({"error":f"Internal server error: {str(e)}"}, status=500)