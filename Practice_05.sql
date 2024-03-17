--Ex1:
select a.continent, round(avg(b.population),0) from country as a 
inner join city as b on b.countrycode = a.code
group by a.continent;

--Ex2:
SELECT round(cast(count(t.signup_action)/count(distinct e.email_id)) as decimal),2) as activation_rate
FROM emails as e left join texts as t 
on e.email_id = t.email_id
and t.signup_action = 'Confirmed';

--Ex3:
SELECT age.age_bucket,
round (100*cast (sum(case when act.activity_type = 'open' then act.time_spent else 0 end)/sum (act.time_spent) as decimal),2) as open_perc,
round (100*cast (sum(case when act.activity_type = 'send' then act.time_spent else 0 end)/sum (act.time_spent) as decimal),2) as send_perc
from activities as act JOIN age_breakdown as age
on age.user_id = act.user_id
where act.activity_type in ('open','send')
group by age.age_bucket;
