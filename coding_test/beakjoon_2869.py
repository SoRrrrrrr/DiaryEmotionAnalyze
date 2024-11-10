## snail
# 썅 이거 풀어야 오늘 귀칼 볼 수 있다. 운동 갔다 와라.
import sys
a,b,v = map(int, sys.stdin.readline().split())
days = 0
d_total = 0

while True:
    d_total = d_total + a
    if d_total >=v:
        break
    d_total = d_total - b
    days = days + 1     

print(days)