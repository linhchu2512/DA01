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
SELECT user_id,
date(max(post_date)) - date(min(post_date)) as days_between
FROM posts
where post_date between '2021-01-01' and '2022-01-01'
group by user_id
having count(post_id) >= 2;

--Ex7:
SELECT card_name, max (issued_amount)-min (issued_amount) as Difference
FROM monthly_cards_issued
group by card_name
order by Difference desc;

--Ex8:
SELECT manufacturer,
count (drug) as drug_count,
abs(sum (cogs-total_sales)) as total_loss
FROM pharmacy_sales
where total_sales - cogs < 0
group by manufacturer
order by total_loss desc;

--Ex9:
select * from cinema
where id%2=1 and description <> 'boring'
order by rating desc;

--Ex10:
select teacher_id,
count (distinct subject_id) as cnt
from teacher
group by teacher_id;

--Ex11:
select user_id,
count (follower_id) as followers_count
from followers
group by user_id
order by user_id;

--Ex12:
select class from courses
group by class
having count (student) >= 5;
