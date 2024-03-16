--Ex1:
select a.continent, round(avg(b.population),0) from country as a 
inner join city as b on b.countrycode = a.code
group by a.continent;

--Ex2:
SELECT round(cast(count(t.signup_action)/count(distinct e.email_id)) as decimal),2) as activation_rate
FROM emails as e left join texts as t 
on e.email_id = t.email_id
and t.signup_action = 'Coònirmed';
