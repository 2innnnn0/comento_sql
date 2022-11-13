-- https://school.programmers.co.kr/learn/courses/30/parts/17042
# 1. 과일로 만든 아이스크림 고르기
-- 코드를 입력하세요
SELECT
    FH.FLAVOR
FROM FIRST_HALF FH
    JOIN ICECREAM_INFO II
        ON FH.FLAVOR = II.FLAVOR -- ICECREAM_INFO테이블의 FLAVOR는 FIRST_HALF 테이블의 FLAVOR의 외래 키입니다.
WHERE 1=1
AND FH.TOTAL_ORDER > 3000 -- "총주문량"이 3,000보다 높으면서
AND II.INGREDIENT_TYPE = 'fruit_based' -- "아이스크림의 주 성분이 과일"
ORDER BY FH.TOTAL_ORDER DESC --  총주문량이 큰 순서대로 조회"


# 2. 12세 이하인 여자 환자 목록 출력하기
-- 코드를 입력하세요
SELECT
    PT_NAME, 
    PT_NO,
    GEND_CD, 
    AGE, 
    (CASE WHEN TLNO IS NULL THEN 'NONE' ELSE TLNO END) AS TLNO -- 이때 전화번호가 없는 경우, 'NONE'으로
FROM PATIENT
WHERE 1=1
AND AGE <= 12 -- 12세 이하
AND GEND_CD = 'W' -- 여자
ORDER BY 
    AGE DESC, -- 나이를 기준으로 내림차순
    PT_NAME ASC -- 나이 같다면 환자이름을 기준으로 오름차순

# 3. 흉부외과 또는 일반외과 의사 목록 출력하기
-- 코드를 입력하세요
SELECT
    # 의사의 이름, 의사ID, 진료과, 고용일자를 조회
    DR_NAME,
    DR_ID,
    MCDP_CD,
    DATE_FORMAT(HIRE_YMD, '%Y-%m-%d') AS HIRE_YMD
FROM DOCTOR
WHERE 1=1
AND MCDP_CD IN ('CS', 'GS') -- 진료과가 흉부외과(CS)이거나 일반외과(GS)
ORDER BY 
    HIRE_YMD DESC, -- 1. 고용일자를 기준으로 내림차순 정렬하고, 
    DR_NAME ASC -- 2. 고용일자가 같다면 이름을 기준으로 오름차순


# 4. 3월에 태어난 여성 회원 목록 출력하기
-- 코드를 입력하세요
SELECT
    -- 회원의 ID, 이름, 성별, 생년월일
    MEMBER_ID,
    MEMBER_NAME,
    GENDER,
    DATE_FORMAT(DATE_OF_BIRTH, '%Y-%m-%d') AS DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE 1=1
AND MONTH(DATE_OF_BIRTH) = 3 -- 생일이 3월
AND GENDER = 'W' -- 여성 회원
AND TLNO IS NOT NULL -- 전화번호가 NULL인 경우는 출력대상에서 제외
ORDER BY 
    MEMBER_ID # 회원ID를 기준으로 오름차순

# 5. 강원도에 위치한 생산공장 목록 출력하기
-- 코드를 입력하세요
SELECT
    -- 공장 ID, 공장 이름, 주소
    FACTORY_ID,
    FACTORY_NAME,
    ADDRESS
FROM FOOD_FACTORY 
WHERE 1=1
# AND SUBSTRING(ADDRESS,1,3) = '강원도' -- 강원도
AND SUBSTRING(TLNO,1,3) = '033'
ORDER BY
    FACTORY_ID -- 공장 ID를 기준으로 오름차순 정렬

# 6. 서울에 위치한 식당 목록 출력하기
SELECT *
FROM
(
    SELECT
        -- 식당 ID, 식당 이름, 음식 종류, 즐겨찾기수, 주소, 리뷰 평균 점수
        RI.REST_ID,
        RI.REST_NAME,
        RI.FOOD_TYPE,
        RI.FAVORITES,
        RI.ADDRESS,
        ROUND(AVG(RR.REVIEW_SCORE * 1.0),2) AS SCORE -- 리뷰 평균점수는 소수점 세 번째 자리에서 반올림
    FROM REST_INFO RI
        JOIN REST_REVIEW RR
            ON RI.REST_ID = RR.REST_ID
    WHERE 1=1
    AND SUBSTRING(RI.ADDRESS,1,2) = '서울' -- 서울에 위치한 식당
    # AND SUBSTRING(RI.TEL,1,2) = '02' -- 서울에 위치한 식당
    GROUP BY 1,2,3,4,5
) t
ORDER BY 
    SCORE DESC,
    FAVORITES DESC
    -- 평균점수를 기준으로 내림차순 정렬
    -- 평균점수가 같다면 즐겨찾기수를 기준으로 내림차순 정렬

# 7. 인기있는 아이스크림
-- 코드를 입력하세요
SELECT FLAVOR
FROM FIRST_HALF
ORDER BY 
    TOTAL_ORDER DESC, # 총주문량을 기준으로 내림차순 정렬
    SHIPMENT_ID ASC # 출하 번호를 기준으로 오름차순 정렬

# 8. 재구매가 일어난 상품과 회원 리스트 구하기
SELECT
    USER_ID,
    PRODUCT_ID
FROM ONLINE_SALE
GROUP BY 1,2
HAVING COUNT(*) > 1 -- 동일한 회원이 동일한 상품을 재구매한 데이터
ORDER BY
    USER_ID ASC, # 1. 회원 ID를 기준으로 오름차순 정렬해주시고 
    PRODUCT_ID DESC # 2. 회원 ID가 같다면 상품 ID를 기준으로 내림차순

# 9. 모든 레코드 조회하기


# "동물 보호소에 들어온" "모든 동물의 정보"를 "ANIMAL_ID순"으로 조회하는 SQL문을 작성해주세요
# 바구니에서 빨간 사과를 꺼낸다.

# 동물 보호소에 들어온 : FROM ANIMAL_INS
# 모든 동물의 정보를 : SELECT *
# 조건 X : WHERE 없음.
# ANIMAL_ID순으로 : ORDER BY ANIMAL_ID
# 조회하는 SQL문을 작성해주세요.

SELECT -- 2. 모든 동물의 정보
    ANIMAL_ID, 
    ANIMAL_TYPE,
    DATETIME,
    INTAKE_CONDITION,
    NAME,
    SEX_UPON_INTAKE
FROM ANIMAL_INS -- 1. 어디에서? "동물 보호소 바구니"에서
ORDER BY ANIMAL_ID -- 3. ANIMAL_ID순으로

# 10. 역순 정렬하기

SELECT 
    NAME, -- 이름
    DATETIME -- 보호시작일
FROM ANIMAL_INS
ORDER BY ANIMAL_ID DESC -- ASC : 오름차순

# 11. 오프라인/온라인 판매 데이터 통합하기

WITH online_t AS (
SELECT
    # "오프라인/온라인 상품 판매 데이터의 판매 날짜, 상품ID, 유저ID, 판매량"
    DATE_FORMAT(SALES_DATE, '%Y-%m-%d') AS SALES_DATE,
    PRODUCT_ID,
    USER_ID, -- OFFLINE_SALE 테이블의 판매 데이터의 USER_ID 값은 NULL 로 표시
    SALES_AMOUNT
FROM 
    ONLINE_SALE
WHERE 1=1
AND SALES_DATE BETWEEN '2022-03-01' AND '2022-03-31'  -- "2022년 3월"
), offline_t AS (
SELECT
    # "오프라인/온라인 상품 판매 데이터의 판매 날짜, 상품ID, 유저ID, 판매량"
    SALES_DATE,
    PRODUCT_ID,
    NULL AS USER_ID, -- OFFLINE_SALE 테이블의 판매 데이터의 USER_ID 값은 NULL 로 표시
    SALES_AMOUNT
FROM 
    OFFLINE_SALE
WHERE 1=1
AND SALES_DATE BETWEEN '2022-03-01' AND '2022-03-31'  -- "2022년 3월"
)

SELECT 
    DATE_FORMAT(SALES_DATE, '%Y-%m-%d') AS SALES_DATE,
    PRODUCT_ID,
    USER_ID,
    SALES_AMOUNT
FROM online_t
UNION ALL 
SELECT 
    SALES_DATE,
    PRODUCT_ID,
    USER_ID,
    SALES_AMOUNT
FROM offline_t
ORDER BY 
    SALES_DATE ASC, # 판매일을 기준으로 오름차순 정렬해주시고 
    PRODUCT_ID ASC, # 판매일이 같다면 상품 ID를 기준으로 오름차순
    USER_ID ASC # 상품ID까지 같다면 유저 ID를 기준으로 오름차순

# 12. 아픈 동물 찾기

-- 코드를 입력하세요
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE INTAKE_CONDITION = 'Sick' -- INTAKE_CONDITION이 Sick 인 경우를 뜻함
ORDER BY ANIMAL_ID

# 13. 어린 동물 찾기
# 동물 보호소에 들어온 동물 중 "젊은 동물의 아이디와 이름"을 조회하는 SQL 문을 작성해주세요. 이때 결과는 아이디 순으로 조회해주세요.
-- 코드를 입력하세요
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS 
WHERE INTAKE_CONDITION != 'Aged' -- INTAKE_CONDITION이 Aged가 아닌 경우를 뜻함 ↩
ORDER BY ANIMAL_ID
# WHERE INTAKE_CONDITION <> 'Aged' -- INTAKE_CONDITION이 Aged가 아닌 경우를 뜻함 ↩
# 같지 않다. !=, <>

# 14. 동물의 아이디와 이름
-- 코드를 입력하세요
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID


# 15. 여러 기준으로 정렬하기
-- 코드를 입력하세요
SELECT ANIMAL_ID, NAME, DATETIME -- "모든 동물의 아이디와 이름, 보호 시작일"
FROM ANIMAL_INS
ORDER BY NAME ASC, DATETIME DESC -- "이름 순", "최근에 들어온 애들순(보호를 나중에 시작한 동물을 먼저 보여줘)"

# 16. 상위 n개 레코드
-- 코드를 입력하세요
SELECT NAME FROM ANIMAL_INS ORDER BY DATETIME LIMIT 1 -- TOP 1 (row수 갯수 정하는 명령어) -- Jack
    -- 가장 오래된 순으로 나옴.

# 17. 조건에 맞는 회원수 구하기
-- 코드를 입력하세요
SELECT
    COUNT(*) AS USERS -- 회원이 몇 명
FROM USER_INFO
WHERE 1=1
AND EXTRACT(YEAR FROM JOINED) = 2021 -- 2021년에 가입한 회원 중 
AND AGE BETWEEN 20 AND 29 -- 나이가 20세 이상 29세 이하인 회원
