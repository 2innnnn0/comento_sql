# 1. 데이터 그룹으로 묶기
-- "콰르텟별 X평균" 을 구하는 SQL 작성.
-- 힌트
  -- 1. FROM points
  -- 2. SELECT {}, AVG(X)
  -- 3. GROUP BY {}

-- "콰르텟별 X평균, Y평균, X표본분산, Y표본분사" 을 구하는 SQL 작성.
-- 계산된 값은 소수점 아래 셋째 자리에서 반올림 해야 합니다.
SELECT -- 2.
  quartet, -- 콰르텟 (1,2,3,4 로마자)
  AVG(x) AS x_mean, -- x 평균
  ROUND(VARIANCE(x),2) AS x_var,
  ROUND(AVG(y),2) AS y_mean, -- y 평균
  ROUND(VARIANCE(y),2) AS y_var
FROM points -- 1.
GROUP BY -- 3.
  quartet

# 2. 할부는 몇 개월로 해드릴까요
SELECT
  payment_installments, -- 3. 할부 개월 수 "별" 
  -- 5. 집계할 녀석들.
  COUNT(DISTINCT order_id) AS order_count, -- (고유한Unique)주문 수
  MIN(payment_value) AS min_value, -- 최소결제금액
  MAX(payment_value) AS max_value, -- 최대 결제 금액
  AVG(payment_value) AS avg_value -- 평균 결제 금액
FROM olist_order_payments_dataset -- 1.
WHERE payment_type = 'credit_card' -- 2. 신용카드로 주문한 내역(조건)
GROUP BY 
  payment_installments -- 4. 할부 개월 수 "별"
  
  
--
-- order_id | 결제방법 | 결제금액
-- 101 | 카드(1) | 10000
-- 101 | 포인트(2) | 2500
-- 101 | 쿠폰(3) | 3500

-- COUNT(order_id) -- 3 중복값을 허용.
-- COUNT(DISTINCT order_id) -- 1 중복값을 제거.

# 3. 레스토랑 웨이터의 팁 분석
SELECT 
  -- 2. 집계그룹
  day, -- 요일별
  time, -- 시간대별
  -- 3. 집계대상
  ROUND(AVG(tip),2) AS avg_tip, -- 평균 팁
  ROUND(AVG(size),2) AS avg_size -- 평균 일행수
FROM tips -- 1.
GROUP BY -- 2. 집계그룹(SET)
  day, -- 요일별
  time -- 시간대별
ORDER BY 
  day ASC, 
  time ASC -- 4. 정렬(결과 데이터가 요일, 시간대의 알파벳 순으로 정렬)


# 4. 일별 블로그 방문자 수 집계
SELECT
  event_date_kst AS dt,
  COUNT(DISTINCT user_pseudo_id) AS users
FROM ga
WHERE event_date_kst between '2021-08-02' AND '2021-08-09'
GROUP BY 1
ORDER BY 1

# 5. 우리 플랫폼에 정착한 판매자 1
SELECT 
  seller_id, -- 판매자(집계기준)
  COUNT(DISTINCT order_id) as orders -- 주문수(판매수)(집계값)
FROM olist_order_items_dataset -- 1. 
GROUP BY
  1 -- 인덱싱 (무엇으로 집계{묶을것}를 할 것 인지)
HAVING COUNT(DISTINCT order_id) >= 100
-- 컨벤션 : "가독성"(쉽게읽기)을 위해서 쓰는 것

# 6. 최고의 근무일을 찾아라
-- 요일별로 팁 총액을 집계하고 팁이 가장 많았던 요일과 그날의 팁 총액을 출력하는 쿼리를 작성해주세요.

SELECT 
  day, 
  sum(tip) as tip_daily
FROM tips
GROUP BY day
ORDER BY tip_daily DESC
LIMIT 1


# 7. 버뮤다 삼각지대에 들어가버린 택배
SELECT 
  DATE(order_delivered_carrier_date) AS order_delivered_carrier_date,
  COUNT(distinct order_id) AS orders
FROM olist_orders_dataset
WHERE order_delivered_carrier_date IS NOT null
AND order_delivered_customer_date IS NULL
AND DATE(order_delivered_carrier_date) BETWEEN '2017-01-01' AND '2017-01-31'
GROUP BY 1
ORDER BY 1

# 8. 점검이 필요한 자전거 찾기
-- 1달에 주행 거리가 50km 이상인 자전거가 정기점검 대상에 포함됩니다.
-- 2021년 2월 정기점검 대상 자전거를 추출하려고 합니다. 
-- rental_history 테이블을 사용해 2021년 1월 한 달간 총 주행 거리가 50km 이상인 자전거의 ID를 출력하는 쿼리를 작성해주세요.

SELECT
  bike_id -- 자전거의 ID "별" -- 2. (집계그룹)
FROM rental_history -- 1.
WHERE DATE(rent_at) BETWEEN DATE('2021-01-01') AND DATE('2021-01-31') -- 4. 2021년 1월 한 달간
GROUP BY
  bike_id -- 자전거의 ID "별"
HAVING SUM(distance) > 50000 -- 6. 50km(50000m) 이상 -> 24대가 결과로 나옴.
-- HAVING 조건인데, 집계GROUP를 한 값에 대한 조건.

# 9. 지역별 주문의 특징
SELECT 
  region AS "Region", 
  COUNT(DISTINCT CASE WHEN category= 'Furniture' THEN order_id END) AS Furniture,
  COUNT(DISTINCT CASE WHEN category= 'Office Supplies' THEN order_id END) AS "Office Supplies",
  COUNT(DISTINCT CASE WHEN category= 'Technology' THEN order_id END) AS Technology
FROM records
GROUP BY 1
ORDER BY 1 


# 10. 가구 판매의 비중이 높았던 날 찾기
-- 반올림하여 소수점 둘째자리까지만 출력해주세요. Furniture 카테고리의 주문 비율이 높은 것부터 보여주도록 정렬하고, 비율이 같다면 날짜 순으로 정렬해주세요.
SELECT 
  order_date,
  furniture, -- ‘Furniture’ 카테고리 주문수
  ROUND((furniture*1.0 / order_count*1.0)*100, 2) AS furniture_pct
FROM 
  ( 
    -- 일별 주문수
    SELECT 
      order_date,
      COUNT(DISTINCT order_id) AS order_count,  -- 고유한DISTINCT 주문정보 
      COUNT(DISTINCT CASE WHEN category='Furniture' THEN order_id END) AS furniture -- ‘Furniture’ 카테고리 주문수
    FROM records
    GROUP BY 
      1
  )
WHERE order_count >= 10
AND (furniture*1.0 / order_count*1.0)*100 >= 40
-- Furniture 카테고리의 주문 비율이 높은 것부터 보여주도록 정렬하고, 비율이 같다면 날짜 순으로 정렬해주세요.
ORDER BY furniture_pct DESC, order_date
