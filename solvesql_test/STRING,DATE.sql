# 1. 최근 올림픽이 개최된 도시

select 
  year,
  UPPER(substring(city,1,3)) as city
from games
where year >= 2000
order by 1 desc 