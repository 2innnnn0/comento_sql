-- github_copilot_맛보기.sql
-- 1. Github계정 만들기
-- 2. Github Copilot을 마켓플레이스에서 다운로드 받기. https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
-- 3. 활성화 하려면 Github 로그인 한 후 Copilot 구독하기. 
-- 4. 기본적으로 설치 후에는 자동으로 적용됨.
-- 5. 해피 Coding!


# 1. "과일"이라는 테이블에서 "빨간색" 사과를 조회하는 쿼리문 작성하기.
SELECT * FROM 과일 WHERE 색상 = '빨간색' AND 이름 = '사과';

# SELECT 문제 연습
1. rental_history에서 bike_id만 선택해서 출력해보세요. (1000개만)
SELECT bike_id FROM rental_history LIMIT 1000;

2. rental_history에서 bike_id와 rent_at을 선택해서 출력해보세요. (1000개만)
SELECT bike_id, rent_at FROM rental_history LIMIT 1000;

3. rental_history에서 distance 선택해서 출력해보세요. (1000개만)
SELECT distance FROM rental_history LIMIT 1000;


# WHERE 문제 연습
1. rental_history에서 rent_station_id이 101인 bike_id만 선택해서 출력해보세요.
SELECT bike_id FROM rental_history WHERE rent_station_id = 101;

2. rental_history에서 rent_station_id이 101인 곳의 bike_id와 rent_at을 선택해서 출력해보세요.
SELECT bike_id, rent_at FROM rental_history WHERE rent_station_id = 101;

3. rental_history에서 distance가 10만m 이상 bike_id와 distance 선택해서 출력해보세요.
SELECT bike_id, distance FROM rental_history WHERE distance >= 100000;


# 다음 쿼리문을 해석해보기
SELECT 
  bike_id
FROM rental_history
WHERE rent_station_id = 111


SELECT 
  *
FROM station
WHERE station_id = 101