# 폐쇄할 따릉이 정류소 찾기 1
SELECT 
  station_id,
  name
FROM 
(
  SELECT 
    station_id,
    name,
    COUNT(*) AS station_count
  FROM
  (
    SELECT 
      t1.station_id,
      t1.name,
      t2.station_id as t2_id,
      t2.name as t2_name,
      t1.updated_at,
      t1.type,
      t2.updated_at,
      t2.type,
      2 * 6356 * ASIN( SQRT( POW(SIN( (RADIANS(t1.lat)-RADIANS(t2.lat))/2 ),2) + COS( RADIANS(t1.lat) )*COS( RADIANS(t2.lat) )*POW(SIN( (RADIANS(t1.lng)-RADIANS(t2.lng))/2 ), 2) )) as distance_station
    FROM station t1
      CROSS JOIN station t2
    WHERE 1=1
    -- AND t1.station_id = 127
    AND t1.updated_at < t2.updated_at
  )
  WHERE distance_station <= 0.3
  AND distance_station > 0
  GROUP BY 1,2
)
WHERE station_count >= 5