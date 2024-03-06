--Ex1:
select name from city
where countrycode='USA' and population > 120000;

--Ex2:
select * from city
where countrycode = 'JPN';

--Ex3:
select city, state from station;

--Ex4:
select distinct city from station
where city like 'A%' or city like 'E%' or city like 'I%' or city like 'O%' or city like 'U%';

--Ex5:
select distinct city from station
where city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u';

--Ex6:
select distinct city from station
where not (city like 'A%' or city like 'E%' or city like 'I%' or city like 'O%' or city like 'U%');

--Ex7:
select name from employee
order by name;

--Ex8:
select name from employee
where salary > 2000 and months <10;

--Ex9:
select product_id from products
where low_fats = 'Y' and recyclable = 'Y';

--Ex10:
select name from customer
where referee_id is null or referee_id <> 2;

--Ex11:
select name, population, area from world
where population >= 25000000 or area >= 3000000;

--Ex12:
select distinct author_id as 'id' from views
where author_id = viewer_id
order by author_id;

--Ex13:
select part, assembly_step from parts_assembly
where finish_date is null;

--Ex14:
