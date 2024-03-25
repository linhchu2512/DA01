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
