-- https://school.programmers.co.kr/learn/courses/30/parts/17047

# 자동차 대여 기록 별 대여 금액 구하기 https://school.programmers.co.kr/learn/courses/30/lessons/151141 
WITH base_t AS (
SELECT 
    RH.HISTORY_ID,
    C.DAILY_FEE,
    C.CAR_TYPE,
    DATEDIFF(END_DATE, START_DATE)+1 AS RENT_DURATION, -- 당일 예약도 되나?? 값이 0 인 것은 무엇일까?    
    CASE
        WHEN DATEDIFF(END_DATE, START_DATE) BETWEEN 7 AND 29 THEN '7일 이상'
        WHEN DATEDIFF(END_DATE, START_DATE) BETWEEN 30 AND 89 THEN '30일 이상'
        WHEN DATEDIFF(END_DATE, START_DATE) >= 90 THEN '90일 이상'
        ELSE NULL -- '7일 미만'
    END AS DURATION_TYPE,
    C.DAILY_FEE * DATEDIFF(END_DATE, START_DATE) AS FEE -- 일일대여금액 * 대여일수
    -- 대여 기록 별로 대여 금액(컬럼명: FEE)을 구하여 대여 기록 ID와 대여 금액 리스트를 출력
    -- 대여 기록 ID가 2인 경우, 일일 대여 금액 26,000원에 2일을 곱하면 총 대여 금액은 52,000원
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY AS RH -- 대여정보 HISTORY_ID(PK), CAR_ID(FK)
    JOIN CAR_RENTAL_COMPANY_CAR AS C -- 차량정보 CAR_ID(PK)
        ON RH.CAR_ID = C.CAR_ID
WHERE C.CAR_TYPE = '트럭' -- 자동차 종류가 '트럭'
)
SELECT
    bt.HISTORY_ID,
    # bt.DAILY_FEE,
    # bt.RENT_DURATION,
    # bt.DURATION_TYPE,
    # dp.DISCOUNT_RATE,
    bt.RENT_DURATION * ROUND(bt.DAILY_FEE * (100 - COALESCE(dp.DISCOUNT_RATE, 0))/100,0) AS FEE -- 대여일수 * (일일대여금액*(100-할인율)/100)
FROM base_t bt
    LEFT JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN AS DP -- CAR_TYPE(PK) > 여기에선 LEFT JOIN (7일 미만인 경우 할인 적용을 못받으므로)
    ON bt.CAR_TYPE = DP.CAR_TYPE -- 대여기간에 따른 할인율 동적 적용. e.g. 7일 이상 > 5%
        AND bt.DURATION_TYPE = DP.DURATION_TYPE
ORDER BY FEE DESC, bt.HISTORY_ID DESC -- 1. 대여 금액을 기준으로 내림차순 정렬하고, 2. 대여 기록 ID를 기준으로 내림차순 정렬


# 대여 기록이 존재하는 자동차 리스트 구하기 https://school.programmers.co.kr/learn/courses/30/lessons/157341
SELECT
    DISTINCT -- 자동차 ID 리스트는 중복이 없어야 하며 : DISTINCT
    C.CAR_ID
FROM CAR_RENTAL_COMPANY_CAR AS C -- CAR_ID(PK)
    JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY AS RH -- CAR_ID(FK)
        ON C.CAR_ID = RH.CAR_ID
WHERE C.CAR_TYPE = '세단' -- 테이블에서 자동차 종류가 '세단'인 자동차들 중 
AND MONTH(RH.START_DATE) = 10
# AND RH.START_DATE BETWEEN '2022-10-01' AND '2022-10-31' -- 10월에 대여를 시작한 기록이 있는 (혹은 MONTH(RH.START_DATE) = 10)
ORDER BY 
    C.CAR_ID DESC -- 자동차 ID를 기준으로 내림차순 정렬

# 자동차 평균 대여 기간 구하기 https://school.programmers.co.kr/learn/courses/30/lessons/157342
SELECT 
    *
FROM 
    (
    SELECT
        -- 자동차 ID와 평균 대여 기간(컬럼명: AVERAGE_DURATION) 리스트를 출력
        -- 평균 대여 기간은 소수점 두번째 자리에서 반올림
        CAR_ID,
        ROUND(AVG(DATEDIFF(END_DATE, START_DATE)+1),1) AS AVERAGE_DURATION
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY 
    WHERE 1=1
        -- 평균 대여 기간이 7일 이상인
    GROUP BY 1
    ) t
WHERE AVERAGE_DURATION >= 7 -- 평균 대여 기간이 7일 이상인
ORDER BY 
    AVERAGE_DURATION DESC, CAR_ID DESC -- 평균 대여 기간을 기준으로 내림차순, 자동차 ID를 기준으로 내림차순 정렬


# 1. 취소되지 않은 진료 예약 조회하기
SELECT
    -- 진료예약번호, 환자이름, 환자번호, 진료과코드, 의사이름, 진료예약일시
    A.APNT_NO,
    P.PT_NAME,
    P.PT_NO,
    D.MCDP_CD,
    D.DR_NAME,
    A.APNT_YMD
FROM APPOINTMENT A 
    LEFT JOIN DOCTOR D
        ON A.MDDR_ID = D.DR_ID
    LEFT JOIN PATIENT P
        ON A.PT_NO = P.PT_NO
WHERE 1=1
AND DATE_FORMAT(A.APNT_YMD, '%Y-%m-%d') = '2022-04-13'  -- 2022년 4월 13일 취소되지 않은 흉부외과(CS) 진료 예약
AND A.APNT_CNCL_YN = 'N'
AND D.MCDP_CD = 'CS'
ORDER BY A.APNT_YMD -- 진료예약일시를 기준으로 오름차순 정렬해주세요.

# 2. 조건별로 분류하여 주문상태 출력하기
SELECT
    # 주문 ID, 제품 ID, 출고일자, 출고여부
    ORDER_ID,
    PRODUCT_ID,
    DATE_FORMAT(OUT_DATE, '%Y-%m-%d') AS OUT_DATE,
    CASE
        WHEN OUT_DATE IS NULL THEN '출고미정' 
        WHEN OUT_DATE <= '2022-05-01' THEN '출고완료'
        ELSE '출고대기'
    END AS 출고여부
FROM FOOD_ORDER
WHERE 1=1
# AND  --  출고여부는 5월 1일까지 출고완료로 이 후 날짜는 출고 대기로 미정이면 출고미정으로 출력해주시고
ORDER BY 
    ORDER_ID # 주문 ID를 기준으로 오름차순

# 3. 루시와 엘라 찾기
-- 코드를 입력하세요
SELECT ANIMAL_ID, NAME, SEX_UPON_INTAKE
FROM ANIMAL_INS
WHERE NAME IN ('Lucy', 'Ella', 'Pickle', 'Rogan', 'Sabrina', 'Mitty')

# 4. 이름에 el이 들어가는 동물 찾기
-- 코드를 입력하세요
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE NAME LIKE '%el%'
AND ANIMAL_TYPE = 'Dog'
ORDER BY NAME

# 5. 중성화 여부 파악하기
-- 코드를 입력하세요
SELECT ANIMAL_ID, NAME, 
CASE 
    WHEN SEX_UPON_INTAKE like 'Neutered%' or SEX_UPON_INTAKE like 'Spayed%' then 'O'
    ELSE 'X'
END as NE
FROM ANIMAL_INS
ORDER BY ANIMAL_ID


# 6. 오랜 기간 보호한 동물(2)
-- 코드를 입력하세요
SELECT I.ANIMAL_ID, I.NAME
# , DATEDIFF(O.DATETIME,I.DATETIME) as diff
FROM ANIMAL_INS I
    JOIN ANIMAL_OUTS O
    ON I.ANIMAL_ID = O.ANIMAL_ID
ORDER BY DATEDIFF(O.DATETIME,I.DATETIME) desc
LIMIT 2


# 7. 카테고리 별 상품 개수 구하기
SELECT
    SUBSTRING(PRODUCT_CODE,1,2) AS CATEGORY,
    COUNT(PRODUCT_ID) AS PRODUCTS
FROM PRODUCT
GROUP BY 1
ORDER BY 1

# 8. DATETIME에서 DATE로 형 변환
-- 코드를 입력하세요
SELECT 
    DATETIME, -- 날짜+시간
    DATE_FORMAT(DATETIME, "%Y-%M-%D") -- 날짜
FROM ANIMAL_INS




