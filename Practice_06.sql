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
