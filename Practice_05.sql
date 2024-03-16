--Ex1:
select a.continent, round(avg(b.population),0) from country as a 
inner join city as b on b.countrycode = a.code
group by a.continent;
