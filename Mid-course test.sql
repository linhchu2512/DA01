--Ex1:
select distinct replacement_cost from film
order by replacement_cost asc;

--Ex2:
select 
sum(case when replacement_cost between 9.99 and 19.99 then 1 else 0 end) as low,
sum(case when replacement_cost between 20 and 24.99 then 1 else 0 end) as medium,
sum(case when replacement_cost between 25 and 29.99 then 1 else 0 end) as high
from film;

--Ex3:
select film.title as film_title,film.length,category.name as category_name
from film join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
where category.name in ('Drama','Sports')
order by length desc;

--Ex4:
select category.name,count(film.title) as quantity
from film join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
group by category.name
order by count(film.title) desc;

--Ex5:
select a.first_name ||' '|| a.last_name as name_actor, count (fa.film_id)
from actor as a join film_actor as fa on a.actor_id = fa.actor_id
group by name_actor
order by count (fa.film_id) desc;

--Ex6:
select ad.address_id, ad.address, cus.customer_id
from address as ad left join customer as cus
on ad.address_id = cus.address_id
where cus.customer_id is null
order by address_id;

--Ex7:
select ci.city, sum(p.amount) as amount
from city as ci join address as a on ci.city_id = a.city_id
join customer as cus on cus.address_id = a.address_id
join payment as p on p.customer_id = cus.customer_id
group by ci.city
order by amount desc;
