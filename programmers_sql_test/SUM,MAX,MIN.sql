# https://school.programmers.co.kr/learn/courses/30/parts/17043

# 1. 가장 비싼 상품 구하기
-- 코드를 입력하세요
SELECT
    MAX(PRICE) AS MAX_PRICE
FROM PRODUCT

# 2. 가격이 제일 비싼 식품의 정보 출력하기
-- 코드를 입력하세요
SELECT 
   PRODUCT_ID, 
   PRODUCT_NAME, 
   PRODUCT_CD,
   CATEGORY, 
   PRICE
FROM FOOD_PRODUCT
ORDER BY PRICE DESC -- 1. 가격 높은 순으로 정렬
LIMIT 1 -- 2. 한 개만 출력.
--  "식품 ID, 식품 이름, 식품 코드, 식품분류, 식품 가격"

# 3. 최댓값 구하기
SELECT MAX(DATETIME)
FROM ANIMAL_INS

# 4. 최솟값 구하기
SELECT MIN(DATETIME)
FROM ANIMAL_INS

# 5. 동물 수 구하기
SELECT COUNT(ANIMAL_ID)
FROM ANIMAL_INS

# 6. 중복 제거하기
SELECT COUNT(DISTINCT NAME)
FROM ANIMAL_INS
