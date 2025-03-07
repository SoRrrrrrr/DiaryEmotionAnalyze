<!-- 들어가야 하는 내용 
      프로젝트명, app이 무엇을 하는지, 왜 그 기술을 사용했는지, 당면한 문제나 나중에 추가하고 싶은 기능이 있는지, 프로젝트 설치 및 실행 방법 -->
# 😃Diary Emotion Analysis App😞
### This is an iOS Application about Diary Emotion Analysis.<br>
When you write a diary, the NLP model analyzes and displays your feelings for the diary. <br>
Also, You can save the diary and emotion to check your History page. <br>

**It's my first time developing an app so the features and UI are very simple 🥲😅**
I'm going to modify it gradually after !

## Tech Stacks
FrontEnd : Swift(iOS) <br>
BackEnd : python Django <br>
NLP : BERT(Model), fine-tuning, hugging face

## UI
<!-- 바꾼 모델은 맘에 안드므로 일단 이미지 이걸로 해두고 다음에 수정하기 -->
<p align="center">
<img src="https://github.com/user-attachments/assets/d5e69142-f34b-439e-81c7-08b97d3fbb36" width="300" height="600"/>
<img src="https://github.com/user-attachments/assets/3a98249f-05ed-4737-9826-fe6e9711d3c5" width="300" height="600"/>
<img src="https://github.com/user-attachments/assets/671a6e35-e176-4a65-a84f-26debf25b426" width="300" height="600"/>
</p>

## Key file Path
**1. views.py** 
https://github.com/SoRrrrrrr/DiaryEmotionAnalyze/blob/38a3ba561684543291c352afee0ef480d0343c9f/diary_app/views.py <br>
**1. models.py** 
https://github.com/SoRrrrrrr/DiaryEmotionAnalyze/blob/38a3ba561684543291c352afee0ef480d0343c9f/diary_app/models.py <br>
**2. settings.py**
https://github.com/SoRrrrrrr/DiaryEmotionAnalyze/blob/24627fb44b5714818785bea0aca9bf0c5ff93d33/myproject/settings.py <br>
**1. urls.py ( containing API path )** 
https://github.com/SoRrrrrrr/DiaryEmotionAnalyze/blob/38a3ba561684543291c352afee0ef480d0343c9f/myproject/urls.py <br>
