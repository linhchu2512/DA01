--Ex1:
select name from students
where marks > 75
order by right (name,3), id;

--Ex2:
select user_id, 
concat(upper (left (name,1), lower (right (name, length (name)-1))) as name
from users
order by user_id;

--Ex3:
