# 감정분석 BERT 모델.ver
import torch
from rest_framework.response import Response
from rest_framework.decorators import api_view
from transformers import pipeline# BERT 모델 사용
import warnings
warnings.filterwarnings('ignore')

# BERT 감정 분석 파이프라인 초기화
# GPU 사용할 환경이면 device=0
# model => Hugging face 에서 개발한 모델
sentiment_analyzer = pipeline("sentiment-analysis", model="distilbert-base-uncased-finetuned-sst-2-english", device=-1)

@api_view(['POST'])
def analyze_diary(request):
    diary_text = request.data.get("diaryText")
    if not diary_text:
        return Response({"error":"No diary text provided"}, status=400)
    
    # sentiment analyze
    analysis = sentiment_analyzer(diary_text)
    sentiment = analysis[0]['label'] # 결과 라벨 가져오기
    
    #Positive or Negative or Neutral 
    return Response({"sentiment":sentiment})