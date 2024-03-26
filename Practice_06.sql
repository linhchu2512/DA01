--Ex1:
with job_count as
(select company_id, title, description, count(job_id) as job_count
from job_listings
group by company_id, title, description)
select count(distinct company_id) as duplicate_companies
from job_count
where job_count > 1;

--Ex2:

--Ex3:
with call_records as (
SELECT policy_holder_id, 
count (case_id) as call_count
FROM callers
group by policy_holder_id
having call_count >= 3
)
select count (policy_holder_id) as member_count
from call_records;

--Ex4:
SELECT pages.page_id FROM pages
left join page_likes on pages.page_id = page_likes.page_id
where page_likes.liked_date is null
order by pages.page_id asc;

--Ex5:
SELECT
extract (month from cur_mth.envent_date) as month,
count (distinct cur_mth.user_id) as monthly_active_users
from user_actions as cur_mth
where exists (
select last_mth.user_id
from user_actions as last_mth
where last_mth.user_id = cur_mth.user_id
and extract (month from last_mth.event_date) =
extract (month from cur_mth.event_date - interval '1 month'))
and extract (month from cur_mth.event_date) = 7
and extract (year from cur_mth.event_date) = 2022
group by extract (month from cur_mth.event_date);

--Ex6:
select
to_char (trans_date, 'yyyy-mm') as month,country,
count (id) as trans_count,
sum (case when state = 'approved' then 1 else 0 end) as approved_count,
sum (amount) as trans_total_amount,
sum (case when state = 'approved' then amount else 0 end) as approved_total_amount
from transactions
group by month,country;

--Ex7:
with first_year as (
  select product_id, min (year) as first_year
  from sales
  group by product_id)
select a.product_id, first_year.first_year, a.quantity,a.price
from sales as a
on a.product_id = first_year.product_id
and a.year = first_year.first_year;

--Ex8:
select customer_id from customer
group by customer_id
having count (distinct product_key) = (select count (product_key) from product);

--Ex9:
select employee_id from employees
where manager_id not in (select employee_id from employees) and
salary < 30000
order by employee_id;

--Ex10:
with job_count as
(select company_id, title, description, count(job_id) as job_count
from job_listings
group by company_id, title, description)
select count(distinct company_id) as duplicate_companies
from job_count
where job_count > 1;

--Ex11:
select table1.results from
  (select u.name as results
from MovieRating as mr join users as u
  on u.user_id = mr.user_id
group by mr.user_id, u.name
order by count(mr.user_id) desc, u.name
limit 1) as table1
union all
  select table2.results
(select m.title as results
  from MovieRating as mr join movie as m
  on m.movie_id = mr.movie_id
  where extract (year from created_date) = 2020
  and extract (month from created_date) = 2
  group by mr.movie_id,m.title
  order by avg(cast(mr.rating as decimal)) desc, m.title
  limit 1) as table2;

--Ex12
with cte as
(select requester_id as id from RequestAccepted
  union all accepter_id as id from RequestAccepted)
select id, count(*) as num from cte
group by id
order by num desc
limit 1;
