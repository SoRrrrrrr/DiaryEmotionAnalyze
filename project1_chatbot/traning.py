import random
import json
import pickle
import numpy as np # 아니 이미 있는데 왜 안됨 킹받게
import nltk
# stem : 단어를 원형(R)으로 만드는 것 / Lemmatizer : 표제어 추출
from nltk.stem import WordNetLemmatizer

from tensorflow.keras.models import Sequential
