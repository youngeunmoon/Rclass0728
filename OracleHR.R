install.packages("rJava")  
install.packages("DBI")  
install.packages("RJDBC")  
install.packages("XML")  
install.packages("memoise")  
install.packages("KoNLP")  
install.packages("wordcloud")  
install.packages("dplyr")  
install.packages("ggplot2")  
install.packages("ggmap")  
install.packages("rvest")  
install.packages("RColorBrewer")  
install.packages("data.table")  
install.packages("dplyr")  
install.packages("reshape") 


#######################################################
## 문제 1 rJava, DBI, RJDBC, dplyr
## 패키지를 호출하시오
#######################################################

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
## 문제 2 오라클과 Project 를 연결하시오
#######################################################
drv <- JDBC(
  
  "oracle.jdbc.driver.OracleDriver",
  
  "C:\\oraclexe\\app\\oracle\\product\\11.2.0\\server\\jdbc\\lib\\ojdbc6.jar"
  
)

conn <- dbConnect(drv,
                  
                  "jdbc:oracle:thin:@localhost:1521:xe",
                  
                  "hr",
                  
                  "oracle")
#################접속코드
#######################################################
## 문제 3 오라클의 테이블을 조회하시오
####################################################### 
tab<-dbGetQuery(conn,"SELECT * FROM TAB")
tname <-tab$TNAME
tname
#######################################################
## 문제 4 오라클의 각 테이블을 데이터프레임으로 전환하시오
## 데이터프레임의 이름은 다음과 같이 하시오.
"COUNTRIES"->cnt       
"DEPARTMENTS" ->dep   
"EMPLOYEES" ->emp      
"EMP_DETAILS_VIEW"->empd
"JOBS" ->job            
"JOB_HISTORY"->jobh     
"LOCATIONS"->loc        
"REGIONS" ->reg

cnt<-data.frame(dbGetQuery(conn,"SELECT *FROM COUNTRIES"))
dep<-data.frame(dbGetQuery(conn,"SELECT *FROM DEPARTMENTS"))
emp <-data.frame(dbGetQuery(conn,"SELECT *FROM EMPLOYEES"))
empd <-data.frame(dbGetQuery(conn,"SELECT *FROM EMPLOYEES_VIEW"))
job<-data.frame(dbGetQuery(conn,"SELECT *FROM JOBS"))
jobh<-data.frame(dbGetQuery(conn,"SELECT *FROM JOB_HISTORY"))
loc<-data.frame(dbGetQuery(conn,"SELECT *FROM LOCATIONS"))
reg<-data.frame(dbGetQuery(conn,"SELECT *FROM REGIONS"))
View(cnt)
#######################################################
## 문제 5 cnt 의 컬럼명을 한글로 전환하시오
## 국가아이디 = COUNTRY_ID
## 국가명 = COUNTRY_NAME
## 지역아이디 = REGION_ID
#######################################################
cnt<-cnt%>% 
  dplyr::rename(국가아이디 = COUNTRY_ID,
                국가명 = COUNTRY_NAME,
                지역아이디 = REGION_ID)
head(cnt)                  
#######################################################
## 문제 6 dep 의 컬럼명을 한글로 전환하시오
## 부서아이디 = DEPARTMENT_ID
## 부서명 = DEPARTMENT_NAME
## 매니저아이디 = MANAGER_ID
## 위치아이디 = LOCATION_ID
#######################################################
dep<-dep %>% 
  dplyr::rename(부서아이디 = DEPARTMENT_ID,
                부서명 = DEPARTMENT_NAME,
                매니저아이디 = MANAGER_ID,
                위치아이디 = LOCATION_ID)
head(dep)
#######################################################
## 문제 7 emp 의 컬럼명을 한글로 전환하시오.
## 그리고 First Name 과 Last Name 을
## 붙여서 이름 으로 된 컬럼을 추가하시오
## 단, 이름 간격은 띄울것. ex) James Dean
## 직원아이디 = EMPLOYEE_ID
## 이메일 = EMAIL
## 전화번호 = PHONE_NUMBER
## 채용일 = HIRE_DATE
## 업무아이디 = JOB_ID
## 연봉 = SALARY
## 커미션비율 = COMMISSION_PCT
## 매니저아이디 = MANAGER_ID
## 부서아이디 = DEPARTMENT_ID
#######################################################
str(emp)
emp<-emp %>% 
  dplyr::rename(직원아이디 = EMPLOYEE_ID,
                     이메일 = EMAIL,
                     전화번호 = PHONE_NUMBER,
                     채용일 = HIRE_DATE,
                     업무아이디 = JOB_ID,
                     연봉 = SALARY,
                     커미션비율 = COMMISSION_PCT,
                     매니저아이디 = MANAGER_ID,
                     부서아이디 = DEPARTMENT_ID) %>%
  mutate(이름=paste(FIRST_NAME,LAST_NAME))
head(emp)
View(emp)
#######################################################
## 문제 8 emp 의 First Name 과 Last Name 컬럼 두개를
## 삭제하시오.
#######################################################
if(is.data.frame(emp))
  emp<-subset(emp,select=-c(FIRST_NAME,LAST_NAME))
View(emp)
#######################################################
## 문제 9
## 매달 지급하는 월급여(연봉 / 12)를 보여주는
## 월급 이라는 컬럼을
## 추가시키시오.(0단위 절삭)
#######################################################
emp<-emp %>% 
  dplyr::mutate(월급=연봉 %/%12)
#######################################################
## 문제 14. 연봉이 10000불 이상인
## 사원(emp)의 목록을 이름, 직원아이디, 연봉을
## 연봉 내림차순으로 보여주세요.
######################################################
emp %>% 
  dplyr::filter(연봉>=10000) %>% 
  dplyr::select(이름, 직원아이디, 연봉) %>% 
  dplyr::arrange(desc(연봉),이름, 직원아이디)
#######################################################
## 문제 15. 연봉이 3000 미만인
## 사원에게 보너스로 급여의 1%를 지급하겠다고 합니다
## 대상자의 목록을 이름, 직원아이디, 연봉을 기재하고
## 아이디 오름차순으로 보여주시오. 단 보너스지급내역서
## 라는 이름의 데이터프레임으로 작성한 후 삭제하시오.
## 보너스에는 각 금액에 만원단위를 첨부합니다.
## 힌트: 보너스= sprintf("%0.0f 만원", 연봉*0.01) 사용
## 힌트: rm(보너스지급내역서) 하면 rm 하면 데이터프레임삭제됨
#######################################################
##############################

보너스지급내역서<-emp %>% 
  dplyr::filter(연봉<3000) %>%
  dplyr::mutate(보너스= sprintf("%0.0f 만원", 연봉*0.01))%>% 
dplyr::select(이름, 직원아이디, 연봉) 
  write.csv(보너스지급내역서)
  #######################################################
  ## 문제 16. 직원중에서 급여가 가장 높은 사람이
  ## CEO 라고 합니다. 이름이 무엇입니까?
  ## apply(object, direction, function to apply)
  ## sapply,lapply
  
  ## 적용방향 - 1:가로방향, 2: 세로방향
  #######################################################
  
  emp %>% 
    dplyr::filter(연봉==apply(emp %>% select(연봉),2,max)) %>% 
    dplyr::select(이름)
  
  
  #######################################################
  ## 문제 17. 연봉이 10000이 넘는 직원의 부서명, 이름,
  ## 연봉을 봉출력하시오.
  #######################################################
  
  
  
  