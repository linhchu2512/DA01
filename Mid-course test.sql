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
