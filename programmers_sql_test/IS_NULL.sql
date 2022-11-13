-- https://school.programmers.co.kr/learn/courses/30/parts/17045

# 1. 경기도에 위치한 식품창고 목록 출력하기
SELECT
    # 창고의 ID, 이름, 주소, 냉동시설 여부
    WAREHOUSE_ID,
    WAREHOUSE_NAME,
    ADDRESS,
    (CASE WHEN FREEZER_YN IS NULL THEN 'N' ELSE FREEZER_YN END) AS FREEZER_YN -- 냉동시설 여부가 NULL인 경우, 'N'으로 출력
FROM FOOD_WAREHOUSE
WHERE 1=1
AND SUBSTRING(TLNO,1,3)='031' -- 경기도
ORDER BY 1
-- 창고 ID를 기준으로 오름차순

# 2. 이름이 없는 동물의 아이디
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NULL -- 이름이 없는 채로 들어온 동물
ORDER BY ANIMAL_ID ASC


# 3. 이름이 있는 동물의 아이디
-- 코드를 입력하세요
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NOT NULL -- 이름이 있는
ORDER BY ANIMAL_ID ASC -- ID는 오름차순 정렬되어야 합니다.


# 4. NULL 처리하기
-- 코드를 입력하세요
SELECT 
    ANIMAL_TYPE,	
    # NAME, -- [NULL]
    IFNULL(NAME, "No name"), 
    SEX_UPON_INTAKE
FROM ANIMAL_INS

# 5. 나이 정보가 없는 회원 수 구하기
SELECT
    COUNT(USER_ID) AS USERS
FROM USER_INFO
WHERE AGE IS NULL -- 나이 정보가 없는 회원이 몇 명



