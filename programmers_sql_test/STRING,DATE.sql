-- https://school.programmers.co.kr/learn/courses/30/parts/17047

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




