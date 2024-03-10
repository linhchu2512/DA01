--Ex1:
select name from students
where marks > 75
order by right (name,3), id;

--Ex2:
select user_id, 
concat(upper (left (name,1), lower (right (name, length (name)-1))) as name
from users
order by user_id;

--Ex3:
SELECT manufacturer,
concat('$',round(sum(total_sales)/1000000,0),' ','million') as sale
FROM pharmacy_sales
group by manufacturer
order by sum(total_sales) desc, manufacturer;

--Ex4:
SELECT extract (month from submit_date) as mth,
product_id as product,
round(cast((avg(stars)) as decimal),2) as avg_stars
FROM reviews
group by extract (month from submit_date), product_id
order by mth, product_id;

--Ex5:
