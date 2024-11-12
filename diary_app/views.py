# 감정분석 BERT 모델.ver
import torch
from rest_framework.response import Response
from rest_framework.decorators import api_view
from transformers import pipeline # BERT 모델 사용
from googletrans import Translator # 구글 번역 라이브러리
import warnings
warnings.filterwarnings('ignore')

# BERT 감정 분석 파이프라인 초기화
# GPU 사용할 환경이면 device=0
# model => Hugging face 에서 개발한 모델 (이 모델은 positive or negative 둘만 학습한 듯)
sentiment_analyzer = pipeline("sentiment-analysis", model="distilbert-base-uncased-finetuned-sst-2-english", device=-1)

## translator 초기화
translator = Translator()

@api_view(['POST'])
def analyze_diary(request):
    # get Korean text
    diary_text = request.data.get("diaryText")
    if not diary_text:
        return Response({"error":"No diary text provided"}, status=400)
    
    # Step1 : Korean -> Japanese
    japanese_text = translator.translate(diary_text, src='ko',dest='ja').text
    
    # Step2 : Japanese -> english
    english_text = translator.translate(diary_text, src='ja',dest='en').text
    
    # sentiment analyze
    analysis = sentiment_analyzer(english_text)
    sentiment = analysis[0]['label'] # 결과 라벨 가져오기
    
    #Positive or Negative or Neutral 
    return Response({"sentiment":sentiment})