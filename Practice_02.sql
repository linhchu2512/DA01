--Ex1:
select distinct city from station
where id%2 = 0;

--Ex2:
select count (CITY) - count (distinct CITY)
from station;

--Ex4:
SELECT ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences)AS decimal),1) AS mean
FROM items_per_order;

--Ex5:
SELECT distinct candidate_id
FROM candidates
Where skill in ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
having count(skill = 3)
order by candidate_id;

--Ex6:
