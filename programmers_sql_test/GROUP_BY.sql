https://school.programmers.co.kr/learn/courses/30/parts/17044

# 대여 횟수가 많은 자동차들의 월별 대여 횟수 구하기 https://school.programmers.co.kr/learn/courses/30/lessons/151139
--  "(FROM)CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서" 
--  "(WHERE)"대여 시작일을 기준으로 2022년 8월부터 2022년 10월까지" "총 대여 횟수가 5회 이상"인 자동차들에 대해서" 
--  "(SELECT)해당 기간 동안의 월별 자동차 ID 별 총 대여 횟수(컬럼명: RECORDS) 리스트를 출력"하는 SQL문을 작성해주세요. 
--  "(ORDER BY)결과는 월을 기준으로 오름차순 정렬하고, 월이 같다면 자동차 ID를 기준으로 내림차순 정렬"해주세요. 
--  특정 월의 총 대여 횟수가 0인 경우에는 결과에서 제외해주세요

-- 코드를 입력하세요
SELECT
    MONTH(START_DATE) AS MONTH,
    CAR_ID,
    COUNT(HISTORY_ID) AS RECORDS
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE START_DATE BETWEEN '2022-08-01' AND '2022-10-31' -- 2022년 8월부터 2022년 10월
AND CAR_ID IN (
                SELECT CAR_ID
               FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
               WHERE START_DATE BETWEEN '2022-08-01' AND '2022-10-31' -- 2022년 8월부터 2022년 10월
               GROUP BY CAR_ID
               HAVING COUNT(HISTORY_ID) >= 5
              ) -- 자동차별 총대여횟수 5회 이상
GROUP BY 
    MONTH, 
    CAR_ID
HAVING RECORDS > 0
ORDER BY 
    MONTH(START_DATE), 
    CAR_ID DESC

# 자동차 대여 기록에서 대여중 / 대여 가능 여부 구분하기 https://school.programmers.co.kr/learn/courses/30/lessons/157340#
SELECT 
    CAR_ID,
    CASE 
        WHEN AVAILABILITY > 0 THEN '대여중'
        ELSE '대여 가능'
    END AVAILABILITY
FROM
(
    SELECT
        CAR_ID, -- 자동차 ID와 AVAILABILITY 리스트를 출력
        # START_DATE,
        # END_DATE,
        SUM(CASE WHEN START_DATE <= '2022-10-16' AND END_DATE >= '2022-10-16' THEN 1 ELSE 0 END) AS AVAILABILITY 
         -- 2022년 10월 16일에 대여 중인 자동차인 경우 '대여중' 이라고 표시 &
         -- 대여 중이지 않은 자동차인 경우 '대여 가능'을 표시하는 컬럼(컬럼명: AVAILABILITY)을 추가(조건을 표시) 
         -- 이때 반납 날짜가 2022년 10월 16일인 경우에도 '대여중'으로 표시
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    GROUP BY 1
    ORDER BY 1 DESC -- 결과는 자동차 ID를 기준으로 내림차순 정렬
) t

# 카테고리 별 도서 판매량 집계하기 https://school.programmers.co.kr/learn/courses/30/lessons/144855
SELECT
    b.category AS CATEGORY, -- "카테고리 별 도서 판매량을 합산" (~별 = GROUP)
    SUM(bs.sales) AS TOTAL_SALES  -- 카테고리(CATEGORY), 총 판매량(TOTAL_SALES) 리스트를 출력
FROM BOOK_SALES bs
    JOIN BOOK b
        ON bs.book_id = b.book_id
WHERE bs.sales_date BETWEEN '2022-01-01' AND '2022-01-31' -- "2022년 1월"
GROUP BY 
    1 -- 첫번째 컬럼(category)
ORDER BY 
    1 -- 카테고리명을 기준으로 오름차순 정렬



# 1. 진료과별 총 예약 횟수 출력하기
SELECT
   MCDP_CD AS 진료과코드,
   COUNT(APNT_NO) AS 5월예약건수
FROM APPOINTMENT
WHERE 1=1
AND DATE_FORMAT(APNT_YMD, '%Y-%m') = '2022-05' -- 2022년 5월에 예약한 환자 수
# AND APNT_CNCL_YN ='N'
GROUP BY 1
ORDER BY 
    5월예약건수 ASC, -- 결과는 진료과별 예약한 환자 수를 기준으로 오름차순 정렬하고
    진료과코드 ASC -- 예약한 환자 수가 같다면 진료과 코드를 기준으로 오름차순 정렬해주세요.

# 2. 식품분류별 가장 비싼 식품의 정보 조회하기
WITH max_price_t AS (
SELECT
    CATEGORY,
    PRODUCT_NAME,
    PRICE,
    MAX(PRICE) OVER(PARTITION BY CATEGORY) AS MAX_PRICE, -- 식품분류별로 가격이 제일 비싼 식품
    RANK() OVER(PARTITION BY CATEGORY ORDER BY PRICE DESC) AS PRICE_RANKING
FROM FOOD_PRODUCT
WHERE 1=1
AND CATEGORY IN ('과자', '국', '김치', '식용유') -- 식품분류가 '과자', '국', '김치', '식용유'인 경우만
)

SELECT
    CATEGORY,
    MAX_PRICE,
    PRODUCT_NAME
FROM max_price_t
WHERE PRICE_RANKING = 1
ORDER BY MAX_PRICE DESC -- 식품 가격을 기준으로 내림차순 정렬

# 3. 성분으로 구분한 아이스크림 총 주문량
SELECT
    -- 아이스크림 성분 타입과 성분 타입에 대한 아이스크림의 총주문량
    II.INGREDIENT_TYPE,
    SUM(FH.TOTAL_ORDER) AS TOTAL_ORDER -- 총주문량을 나타내는 컬럼명은 TOTAL_ORDER로
FROM FIRST_HALF FH
    JOIN ICECREAM_INFO II
        ON FH.FLAVOR = II.FLAVOR
GROUP BY 1
ORDER BY 2 -- 총주문량이 작은 순서대로 조회

# 4. 즐겨찾기가 가장 많은 식당 정보 출력하기
WITH max_favorite_t AS (
SELECT 
    FOOD_TYPE,
    MAX(FAVORITES) AS FAVORITES
FROM REST_INFO
GROUP BY 1
)

SELECT
    -- 음식종류별로 즐겨찾기수가 가장 많은 식당의 음식 종류, ID, 식당 이름, 즐겨찾기수
    RI.FOOD_TYPE,
    RI.REST_ID,
    RI.REST_NAME,
    RI.FAVORITES
FROM REST_INFO RI
    JOIN max_favorite_t mft
        ON RI.FOOD_TYPE = mft.FOOD_TYPE
            AND RI.FAVORITES = mft.FAVORITES
ORDER BY RI.FOOD_TYPE DESC -- 음식 종류를 기준으로 내림차순

# 5. 고양이와 개는 몇 마리 있을까 
SELECT 
    ANIMAL_TYPE, 
    COUNT(ANIMAL_ID) AS ANIMAL_COUNT -- 동물수
    -- COUNT(1) -- 단순히 숫자를 카운트 하는 것이기 때문에 어떤 값이 들어와도 상관없음. 그래도 명목상, 의미 전달로는 특정 ID를 세는 것이기 때문에 가급적이면 고유하게 "지칭할 수 있는 값(가령, ID)"을 넣는게 좋다.
FROM ANIMAL_INS
GROUP BY 1
ORDER BY 1

# 6. 동명 동물 수 찾기
SELECT 
    NAME, 
    COUNT(ANIMAL_ID) -- 해당 이름이 쓰인 횟수
FROM 
    ANIMAL_INS
WHERE  -- 이름이 없는 동물은 집계에서 제외하며 (공백과'' vs. NULL 차이)
    (NAME != '' -- 1. 이름에 공백이 들어간 경우(EMPTY CASE) -- 오류에 해당
     OR NAME IS NOT NULL) -- 2. 이름자체값이 입력이 안된 경우(NULL CASE)
GROUP BY 
    NAME
HAVING -- 그룹바이의 조건을 사용하는 용도.
    COUNT(ANIMAL_ID) > 1 -- 두 번 이상 = 한 번 초과
ORDER BY
    NAME ASC -- # 결과는 이름 순으로 조회해주세요.


# 7. 입양 시각 구하기(1)
    # EXTRACT({추출하고자하는 날짜단위} FROM DATETIME) -> EXTRACT 추출할 날짜를 정하기.
    # HOUR : 시간추출. MONTH : 월. DAY : 일.
        # EXTRACT(MONTH FROM DATETIME) AS MONTH 
    -- # 날짜 표준에 대한 설명.
    # Q. 1년의 첫번째 주는 어떻게 정하는가?
    # A. 01 주 내 연도의 첫번째 목요일이 존재 (공식 ISO 정의) https://ko.wikipedia.org/wiki/ISO_8601

SELECT 
    EXTRACT(HOUR FROM DATETIME) as HOUR,
    COUNT(ANIMAL_ID)
FROM ANIMAL_OUTS
WHERE (EXTRACT(HOUR FROM DATETIME) >= 9 
    AND EXTRACT(HOUR FROM DATETIME) < 20)
GROUP BY HOUR
ORDER BY HOUR

# 8. 년, 월, 성별 별 상품 구매 회원 수 구하기
SELECT
    # 년, 월, 성별 별로 상품을 구매한 회원수를 집계
    EXTRACT(YEAR FROM OS.SALES_DATE) AS YEAR,
    EXTRACT(MONTH FROM OS.SALES_DATE) AS MONTH,
    UI.GENDER,
    COUNT(DISTINCT OS.USER_ID) AS USERS
FROM ONLINE_SALE OS -- 판매정보
    JOIN USER_INFO UI -- 유저정보
        ON OS.USER_ID = UI.USER_ID 
WHERE GENDER IN (0,1) -- 이때, 성별 정보가 없는 경우 결과에서 제외해주세요.
GROUP BY 1,2,3
ORDER BY 1,2,3
-- 결과는 년, 월, 성별을 기준으로 오름차순 정렬해주세요.


# 9.입양 시각 구하기(2)
WITH dummy_hour_t AS ( -- 1. 0~23시 더미데이터.
SELECT 
    ROW_NUMBER() OVER(PARTITION BY '') -1 AS HOUR
FROM ANIMAL_OUTS 
LIMIT 24
), animal_out_t AS ( -- 2. 시간대별 입양된 동물의 수. (7~16시. 새벽시간에, 늦은밤 데이터X)
SELECT 
    HOUR(DATETIME) as HOUR,
    COUNT(*) as ANIMAL_COUNT
FROM ANIMAL_OUTS
GROUP BY
    1
)

SELECT 
    dht.HOUR as dummy_hour,
    IFNULL(ANIMAL_COUNT,0) AS ANIMAL_COUNT
FROM dummy_hour_t dht -- 1. 0~23시 더미데이터.(큰)
    LEFT JOIN animal_out_t ao -- 2. 7~19시. 시간대별 입양된 동물의 수.(새벽시간에, 늦은밤 데이터X)
        ON dht.HOUR = ao.HOUR -- 시간으로 연결.
GROUP BY 1,2
ORDER BY 1,2

# 10. 가격대 별 상품 개수 구하기
SELECT
    -- 만원 단위의 가격대 별로 상품 개수를 출력
    FLOOR(PRICE / 10000) * 10000 AS PRICE_GROUP,
    COUNT(PRODUCT_ID) AS PRODUCTS
FROM PRODUCT
GROUP BY 1
ORDER BY 1 # 결과는 가격대를 기준으로 오름차순 정렬해주세요.

