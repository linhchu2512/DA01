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
select sender_id,
count(message_id) as message_count
from messages
where extract(month from sent_date)=8
and extract(year from sent_date)=2022
group by sender_id
order by message_count DESC
limit 2;

--Ex6:
select tweet_id from tweets
where length(content)>15;
