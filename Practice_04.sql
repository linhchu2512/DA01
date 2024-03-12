--Ex1:
SELECT
sum(case when device_type='laptop' then 1 else 0 end) as laptop_views,
sum(case when device_type in ('phone','tablet')then 1 else 0 end) as mobile_views
from viewership;

--Ex2:
select
case when x+y>z and y+z>x and x+z>y then 'Yes'
else 'No' end as triangle
from Triangle;

--Ex3:

--Ex4:
select name from customer
where referee_id <> 2 or referee_id is null;
