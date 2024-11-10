# -*- coding: utf-8 -*-
# UTF-8 encoding when using korean
import sys

## 문자열 n줄 입력받아 리스트에 저장
num = int(input()) # num of sentences

user_input = [sys.stdin.readline().strip() for i in range(num)] # strip : 문자열 양 끝의 공백문자 제거

# one sentence
for sent in user_input:
	# one character
	for	c in sent:
		result = list() # save vowel character
		r_len = len(result)
		# 이게 문제 같은데 모음 찾는 부분이 리스트에서 비교하는 게 안됨
		if c in ['a','e','i','o','u','A','E','I','O','U']:
		 	result.append(c)
	    else:
			continue
	## if there's no vowel in the sentence
	if r_len==0:
		print("???")	
	else:
		for i in range(r_len):
			print(result[i])
	print('\n')
	
