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

--Ex4:
SELECT cus.customer_id
FROM customer_contracts as cus
join products as pro on cus.product_id = pro.product_id
group by cus.customer_id
having count(distinct pro.product_category) = (select count (distinct product_category) from products)
order by cus.customer_id;

--Ex5:
select e1.employee_id, e1.name,
count (e2.employee_id) as report_count, 
round (avg (e2.age),0) as average_age
from employees as e1 join employees as e2
on e1.employee_id = e2.reports_to
group by e1.employee_id
order by employee_id;

--Ex6:
select products.product_name, orders.product_id,
sum(orders.unit) from orders
left join products on products.product_id = orders.product_id
where month(orders.order_date) = 2 and year (orders.order_date) = 2020
group by orders.product_id
having sum(orders.unit) >= 100;
