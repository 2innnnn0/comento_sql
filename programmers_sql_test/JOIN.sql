-- https://school.programmers.co.kr/learn/courses/30/parts/17046

# 1. 5월 식품들의 총매출 조회하기
SELECT 
    # 식품 ID, 식품 이름, 총매출
    FO.PRODUCT_ID,
    FP.PRODUCT_NAME,
    SUM(FP.PRICE * FO.AMOUNT) AS TOTAL_SALES -- 총매출 : 가격*판매량
FROM 
    # FOOD_PRODUCT와 FOOD_ORDER
    FOOD_ORDER FO -- 주문
    JOIN FOOD_PRODUCT FP -- 상품(메타정보)
        ON FO.PRODUCT_ID = FP.PRODUCT_ID
WHERE 
    DATE_FORMAT(FO.PRODUCE_DATE, '%Y-%m') = '2022-05' # "생산일자가 2022년 5월인 식품"
GROUP BY 
    FO.PRODUCT_ID,
    FP.PRODUCT_NAME
ORDER BY
    TOTAL_SALES DESC, # 1. 총매출을 기준으로 내림차순 정렬해주시고 
    FO.PRODUCT_ID ASC # 2. 총매출이 같다면 식품 ID를 기준으로 오름차순 정렬해주세요


# 2. 주문량이 많은 아이스크림들 조회하기
SELECT FLAVOR
FROM
(
    SELECT
        FH.FLAVOR,
        SUM(FH.TOTAL_ORDER + J.TOTAL_ORDER) AS TOTAL_ORDER
    FROM FIRST_HALF FH -- 1. 1~6 아이스크림.
        JOIN JULY J -- 2. 7월. 
            ON FH.FLAVOR = J.FLAVOR -- 연결고리 (VLOOKUP key)
    GROUP BY 1
) t
ORDER BY TOTAL_ORDER DESC
LIMIT 3 -- 상위 3개의 맛을

# 3. 그룹별 조건에 맞는 식당 목록 출력하기
-- FLOW
    --  리뷰를 가장 많이 작성한 회원의 리뷰들 -> 회원별 리뷰의 갯수를 알아야 함. -> 많이 쓴 사람을 고르기 -> minjea985@naver.com.
WITH review_best_t AS (
    SELECT MEMBER_ID
    FROM 
    (
        SELECT
            MEMBER_ID,
            COUNT(REVIEW_ID) AS REVIEW_COUNT
        FROM REST_REVIEW
        GROUP BY 
            MEMBER_ID
        ORDER BY
            2 DESC
        LIMIT 1
    ) t -- Every derived table must have its own alias
)
-- 2. 회원 이름, 리뷰 텍스트, 리뷰 작성일
SELECT 
    MP.MEMBER_NAME,
    RR.REVIEW_TEXT,
    DATE_FORMAT(RR.REVIEW_DATE, '%Y-%m-%d') AS REVIEW_DATE -- 2) REVIEW_DATE의 데이트 포맷이 예시와 동일해야 정답처리 됩니다.
FROM REST_REVIEW RR -- 1. 리뷰 테이블
    JOIN MEMBER_PROFILE MP -- 2. 유저 테이블
        ON RR.MEMBER_ID = MP.MEMBER_ID
WHERE RR.MEMBER_ID IN (SELECT MEMBER_ID FROM review_best_t)   -- 1) 동적dynamic으로 적용될 수 있도록 변경해줘야 함.

ORDER BY 
    REVIEW_DATE ASC,
    REVIEW_TEXT ASC

# 4. 없어진 기록 찾기


SELECT 
    OUTS.ANIMAL_ID AS out_animal_id, -- 나간 동물ID
    OUTS.NAME
FROM ANIMAL_OUTS OUTS -- 있고.(얘가 큰 상황)
    LEFT JOIN ANIMAL_INS INS -- 데이터가 일부 없음.
        ON OUTS.ANIMAL_ID = INS.ANIMAL_ID
WHERE INS.ANIMAL_ID IS NULL -- 들어온 동물ID 값이 없는 경우.



# 5. 있었는데요 없었습니다
-- 코드를 입력하세요
SELECT 
    I.ANIMAL_ID, 
    I.NAME
FROM ANIMAL_INS I #(큰덩어리) 보호시작일
    JOIN ANIMAL_OUTS O #(작은덩어리) 입양일
        ON I.ANIMAL_ID = O.ANIMAL_ID # 연결고리
WHERE I.DATETIME > O.DATETIME  # 보호시작일 > 입양일 (예외케이스)
ORDER BY I.DATETIME , O.DATETIME

# 6. 오랜 기간 보호한 동물(1)
-- 코드를 입력하세요
SELECT 
    # I.ANIMAL_ID, -- 고유한ID값.(UNIQUE)
    I.NAME, -- 중복이 가능.(jane, jane, jane.. 중복 되는 케이스.)
    I.DATETIME -- 가장 오래된 애들을 알 수 있는 정보.(가장 작은 값들만 뽑아야함.)
FROM ANIMAL_INS I -- (큰덩어리) 1.보호소들어온애들 
    LEFT JOIN ANIMAL_OUTS O -- (작은덩어리) 2.입양간애들
        ON I.ANIMAL_ID = O.ANIMAL_ID -- 1,2의 연결고리.
WHERE O.ANIMAL_ID IS NULL -- 입양을 못 간 동물(1번에있는데, 2번에는없는애)
ORDER BY I.DATETIME ASC -- 보호시작일 순.
LIMIT 3

# 7. 보호소에서 중성화한 동물
SELECT 
    I.ANIMAL_ID,
    I.ANIMAL_TYPE,
    I.NAME
FROM ANIMAL_INS I -- (큰덩어리) 1. 보호소 들어온.
    LEFT JOIN ANIMAL_OUTS O -- (작은덩어리) 2. 보호소 나간.
        ON I.ANIMAL_ID = O.ANIMAL_ID
WHERE (I.SEX_UPON_INTAKE NOT IN ('Spayed Female', 'Neutered Male') -- 보호소에 "들어올" 당시에는 중성화 되지 않았지만, 
        AND O.SEX_UPON_OUTCOME IN ('Spayed Female', 'Neutered Male'))-- 보호소를 "나갈" 당시에는 중성화된 
ORDER BY I.ANIMAL_ID -- 아이디 순으로 조회하는

# 8. 상품 별 오프라인 매출 구하기
SELECT 
    -- 상품코드 별 매출액(판매가 * 판매량) 합계
    P.PRODUCT_CODE,
    SUM(P.PRICE * OS.SALES_AMOUNT) AS SALES
FROM OFFLINE_SALE OS
    JOIN PRODUCT P
        ON OS.PRODUCT_ID = P.PRODUCT_ID
GROUP BY 1
ORDER BY 
    SALES DESC,
    PRODUCT_CODE ASC

# 9. 상품을 구매한 회원 비율 구하기
WITH total_joined_t AS ( # 2021년에 가입한 전체 회원
SELECT 
    # COUNT(DISTINCT USER_ID) AS TOTAL_USERS -- 158
    USER_ID,
    COUNT(USER_ID) OVER() AS TOTAL_USERS
FROM USER_INFO UI -- 전체 유저 정보.
WHERE 1=1
AND EXTRACT(YEAR FROM UI.JOINED) = 2021 -- 2021년에 가입한 전체 회원
)

SELECT
    # 년, 월 별로
    # 상품을 구매한 회원수와 상품을 구매한 회원의 비율(=2021년에 가입한 회원 중 상품을 구매한 회원수 / 2021년에 가입한 전체 회원 수)
   EXTRACT(YEAR FROM OS.SALES_DATE) AS YEAR, -- OS.SALES_DATE
   EXTRACT(MONTH FROM OS.SALES_DATE) AS MONTH,
   COUNT(DISTINCT OS.USER_ID) AS PUCHASED_USERS,
   ROUND(COUNT(DISTINCT OS.USER_ID) / 158 ,1) AS PUCHASED_RATIO -- 상품을 구매한 회원의 비율은 소수점 두번째자리에서 반올림하고, 
FROM total_joined_t UI -- USER_INFO UI -- 전체 유저 정보.
    LEFT JOIN ONLINE_SALE OS -- 구매한 유저 정보.
        ON UI.USER_ID = OS.USER_ID
WHERE 1=1
AND EXTRACT(YEAR FROM OS.SALES_DATE) IS NOT NULL
GROUP BY 1,2
ORDER BY 
    YEAR ASC,
    MONTH ASC


