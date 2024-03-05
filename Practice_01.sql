--Ex1:
select name from city
where countrycode='USA' and population > 120000;

--Ex2:
select * from city
where countrycode = 'JPN';

--Ex3:
select city, state from station;

--Ex4:
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
where referee_id is null or referee_id = 2;

--Ex11:
select name, population, area from world
where population >= 25000000 and area >= 3000000;

--Ex12:



