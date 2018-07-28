library(rJava)  
library(DBI)  
library(RJDBC)  
library(XML)  
library(memoise)  
library(KoNLP)  
library(wordcloud)  
library(dplyr)  
library(ggplot2)  
library(ggmap)  
library(rvest)  
library(RColorBrewer)  
library(data.table)  
library(reshape)

#######################################################
## 문제 1. class_scores.csv을 데이터프레임으로 전환하시오
# 데이터프레임의 이름은 다음과 같이 하시오.
# scores
# R에서는 기본적으로 데이터파일안에 들어있는 문자열(Strings)를
# 요인(Factor)로 취급하는 것이 기본이다. 만약 요인으로 설정하지 않고
# 불러오고 싶다면 readCSV()함수내에 stringsAsFactors=FALSE; 를 추가한다.
#######################################################
scores<-data.frame(read.csv("class_scores.csv"))
## Stu_ID
## grade
## class
## gender
## Math
## English
## Science
## Marketing
## Writing

#######################################################
## 문제 2. scores을 분석하시오
#######################################################
str(scores)
# 'data.frame':	600 obs. of  9 variables:
#   $ Stu_ID   : int  10101 10102 10103 10104 10105 10106 10107 10108 10109 10110 ...
# $ grade    : int  1 1 1 1 1 1 1 1 1 1 ...
# $ class    : Factor w/ 5 levels "A","B","C","D",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ gender   : Factor w/ 2 levels "F","M": 2 2 1 1 1 2 2 1 2 2 ...
# $ Math     : int  55 29 28 45 28 86 47 80 30 94 ...
# $ English  : int  84 94 80 74 69 51 52 67 32 39 ...
# $ Science  : int  50 41 68 48 57 68 98 98 74 90 ...
# $ Marketing: int  40 87 41 88 91 59 81 85 86 67 ...
# $ Writing  : int  59 57 100 75 66 92 79 90 52 28 ...
head(scores)
tail(scores)
summary(scores)
dim(scores)
View(scores)
#######################################################
## 문제 3. scores 의 컬럼명을 한글로 전환하시오
## 학번= Stu_ID
## 학년 = grade
## 등급 = class
## 성별 = gender
## 수학 = Math
## 영어 = English
## 과학 = Science
## 마케팅 = Marketing
## 작문 = Writing
head(scores)
#######################################################
scores<-scores%>% 
  dplyr::rename(학번=Stu_ID,
                  학년=grade,
                  등급=class,
                  성별=gender,
                  수학 = Math,
                  영어 = English,
                  과학 = Science,
                  마케팅 = Marketing,
                  작문 = Writing)

head(scores)
#######################################################
## 문제 4. 1학년 학생들을 학번,이름, 성별을 출력하시오. 단, 내림차순 정렬
#######################################################
scores<-scores %>% 
  dplyr::filter(grade==1) %>% 
  dplyr::select(Stu_ID,grade,gender) %>% 
  dplyr::arrange(desc(Stu_ID))


#######################################################
## 문제 5. 1학년 남학생만 보기
#######################################################
