# mysqlclient 설치에 문제 이슈로, 대체방안으로 pymysql 사용
import pymysql
pymysql.install_as_MySQLdb()