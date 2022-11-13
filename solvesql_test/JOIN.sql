# 1. 두 테이블 결합하기
-- 위 테이블 중 events 테이블과 records 테이블을 활용해 올림픽 골프 종목에 참가한 선수의 ID를 모두 조회하는 쿼리를 작성해주세요.
-- DISTINCT : 중복을 제거하는 용도
SELECT DISTINCT r.athlete_id
FROM events e
  JOIN records r
    ON e.id = r.event_id -- 연결고리.
WHERE e.sport = 'Golf' -- 올림픽 골프 종목.

# 2. 복수 국적 메달 수상한 선수 찾기
-- 'Chen Jing'
SELECT name
FROM
(
  SELECT
    a.id,
    a.name,
    COUNT(DISTINCT r.team_id) AS team_count
  FROM records r
    JOIN athletes a
    ON r.athlete_id = a.id
    JOIN games g
      ON r.game_id = g.id
  WHERE g.year >= 2000
  AND r.medal IS NOT NULL 
  -- AND a.name = 'Chen Jing'
  GROUP BY 1,2
  HAVING COUNT(DISTINCT r.team_id) >= 2
)
ORDER BY 1

# 3. 쇼핑몰의 일일 매출액
-- 두 테이블을 이용해 "2018년 1월 1일" 이후 쇼핑몰의 "일별 매출액"을 계산하는 쿼리를 작성해주세요.
SELECT 
  DATE(order_purchase_timestamp) as dt,
  ROUND(SUM(payment_value),2) AS revenue_daily
FROM olist_orders_dataset od -- 1. 주문.
  JOIN olist_order_payments_dataset pd -- 2. 결제수단. 
    ON od.order_id = pd.order_id -- 3. 연결고리 "주문ID"
WHERE DATE(order_purchase_timestamp) >= '2018-01-01'
GROUP BY 1
ORDER BY 1

# 4. 쇼핑몰의 일일 매출액과 ARPPU
SELECT 
  DATE(order_purchase_timestamp) as dt,
  COUNT(DISTINCT customer_id) AS pu,
  ROUND(SUM(payment_value),2) AS revenue_daily,
  ROUND(SUM(payment_value) / COUNT(DISTINCT customer_id), 2) AS arppu -- 결제 고객 1인 당 평균 결제 금액 = (전체 매출액 / 결제 고객 수)
FROM olist_orders_dataset od
  JOIN olist_order_payments_dataset pd
    ON od.order_id = pd.order_id
WHERE DATE(order_purchase_timestamp) >= '2018-01-01'
GROUP BY 1
ORDER BY 1

# 5. 멘토링 짝꿍 리스트
WITH mentor_t AS (
SELECT 
  employee_id,
  name,
  manager_id,
  department
FROM employees
WHERE julianday('2021-12-31') - julianday(join_date) > (365*2)
), mentee_t AS (
SELECT 
  employee_id,
  name,
  manager_id,
  department
FROM employees
WHERE julianday('2021-12-31') - julianday(join_date) <= (30*2)
)

SELECT 
  mentee.employee_id AS mentee_id,
  mentee.name AS mentee_name,
  mentor.employee_id AS mentor_id,
  mentor.name AS mentor_name
FROM mentor_t mentor
  JOIN mentee_t mentee
    ON mentor.department != mentee.department
ORDER BY 1 

# 6. 작품이 없는 작가 찾기
SELECT 
  a.artist_id,
  a.name
FROM artists a
  LEFT JOIN artworks_artists aa
    ON a.artist_id= aa.artist_id
  LEFT JOIN artworks aw
    ON aa.artwork_id = aw.artwork_id
WHERE 1=1 
AND a.death_year IS NOT NULL -- 사망
GROUP BY 1,2
HAVING COUNT(aw.artwork_id) = 0 

