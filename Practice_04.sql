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
SELECT round(100 * count (call_category)/count(*),1) as call_percentage
FROM callers
where call_category is null or call_category = 'n/a' ;

--Ex4:
select name from customer
where referee_id <> 2 or referee_id is null;

--Ex5:
select 
case when pclass = 1 then 'first_class'
when pclass = 2 then 'second_class'
when pclass = 3 then 'third_class'
end as category,
sum(case when survived = 1 then 1 else 0 end) as survivors,
sum(case when survived = 0 then 1 else 0 end) as non_survivors
from titanic
group by category;
