--Ex1:
with job_count as
(select company_id, title, description, count(job_id) as job_count
from job_listings
group by company_id, title, description)
select count(distinct company_id) as duplicate_companies
from job_count
where job_count > 1;

--Ex2:
