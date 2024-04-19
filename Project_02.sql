/*Ecommerce Dataset: Exploratory Data Analysis (EDA) and Cohort Analysis in SQL
--Tổng quan về dữ liệu
TheLook là một trang web thương mại điện tử về quần áo. Tập dữ liệu chứa thông tin về customers, products, orders, logistics, web events , digital marketing campaigns.
--Các bảng:
distribution_centers: ghi lại tên kinh độ, vĩ độ của các trung tâm pp
events: ghi lại các sự kiện
inventory_items: ghi lại thông tin các item tồn kho (id, tên, brand, cost, giá bán)
order_items : ghi lại danh sách các mặt hàng đã mua trong mỗi order ID..
orders : ghi lại tất cả các đơn hàng mà khách hàng đã đặt
products : ghi lại chi tiết các sản phẩm được bán trên The Look, bao gồm price, brand, & product categories
users: toàn bộ thông tin người dùng */

--I. Ad-hoc tasks
----1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
----Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
select 
extract (year from b.delivered_at) ||'-'|| extract (month from b.delivered_at) as month_year,
count (distinct a.user_id) as total_user,
count (a.order_id) as total_orders
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.order_id = b.order_id
where extract (year from b.delivered_at) ||'-'|| extract (month from b.delivered_at) between '2019-01-01' and '2022-05-01'
and b.status = 'Complete'
group by 1
order by 1
  
/* Nhận xét: số lượng người dùng cũng như số lượng đơn hàng có sự tăng qua từng tháng và từng năm, đặc biệt tăng mạnh vào 3 tháng cuối năm (10-12). 
=> có thể thấy được nhu cầu tiêu dùng các tháng cuối năm tăng mạnh do có các chương trình giảm giá/khuyến mãi cuối năm (black friday,...) */

----2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
----Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng ( Từ 1/2019-4/2022)
select 
extract (year from created_at) ||'-'|| extract (month from created_at) as month_year,
count (distinct user_id) as distinct_users,
round (sum (sale_price)/count(distinct order_id),2) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where extract (year from created_at) ||'-'|| extract (month from created_at) between '2019-01-01' and '2022-05-01'
group by 1
order by 1

/* Nhận xét: số lượng người dùng tăng trưởng qua từng tháng và năm, giá trị đơn hàng trung bình cũng không có biến động lớn */

----3. Nhóm khách hàng theo độ tuổi
----Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
--Cách 1:
--KH nam nhỏ tuổi nhất
with young_old_age as
(select * from (select first_name,last_name,gender,
(select min(age) from bigquery-public-data.thelook_ecommerce.users) as age
from bigquery-public-data.thelook_ecommerce.users
where gender = 'M'
and created_at between '2019-01-01'and '2022-05-01'
and age in (select min(age) from bigquery-public-data.thelook_ecommerce.users))
  
union all
--KH nam lớn tuổi nhất
select * from (select first_name,last_name,gender,
(select max(age) from bigquery-public-data.thelook_ecommerce.users) as age
from bigquery-public-data.thelook_ecommerce.users
where gender = 'M'
and created_at between '2019-01-01'and '2022-05-01'
and age in (select max(age) from bigquery-public-data.thelook_ecommerce.users))
  
union all
--KH nữ nhỏ tuổi nhất
select * from (select first_name,last_name,gender,
(select min(age) from bigquery-public-data.thelook_ecommerce.users) as age
from bigquery-public-data.thelook_ecommerce.users
where gender = 'F'
and created_at between '2019-01-01'and '2022-05-01'
and age in (select min(age) from bigquery-public-data.thelook_ecommerce.users))

union all
--KH nữ lớn tuổi nhất
select * from (select first_name,last_name,gender,
(select max(age) from bigquery-public-data.thelook_ecommerce.users) as age
from bigquery-public-data.thelook_ecommerce.users
where gender = 'F'
and created_at between '2019-01-01'and '2022-05-01'
and age in (select max(age) from bigquery-public-data.thelook_ecommerce.users))),
--gắn tag
young_old_age_tag as (
select *,
   case when age = (select min(age) from young_old_age where gender = 'M') then 'youngest'
        when age = (select min(age) from young_old_age where gender = 'F') then 'youngest'
        when age = (select max(age) from young_old_age where gender = 'M') then 'oldest'
        when age = (select max(age) from young_old_age where gender = 'F') then 'oldest'
   end as tag
from young_old_age
)
--đếm số KH lớn tuổi và nhỏ tuổi nhất
select gender, tag, age, count (*) as user_count 
from young_old_age_tag
group by gender, tag, age;

--Cách 2:
with young_old_age as
(select first_name, last_name, gender,
min (age) over (partition by gender) as age
from bigquery-public-data.thelook_ecommerce.users 
where created_at between '2019-01-01'and '2022-05-01'
and age in (select min(age) from bigquery-public-data.thelook_ecommerce.users)
union all
select first_name, last_name, gender,
max (age) over (partition by gender) as age
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-01-01'and '2022-05-01'
and age in (select max (age) from bigquery-public-data.thelook_ecommerce.users)),
young_old_age_tag as (
select *,
   case when age in (select min(age) from young_old_age where gender = 'M') then 'youngest'
        when age in (select min(age) from young_old_age where gender = 'F') then 'youngest'
        else 'oldest'
   end as tag
from young_old_age
)
select gender, tag, age, count (*) as user_count 
from young_old_age_tag
group by gender, tag, age;

/* Nhận xét:
- Giới tính nữ: trẻ nhất là 12 tuổi (524 người dùng), già nhất là 70 tuổi (544 người dùng)
- Giới tính nam: trẻ nhất là 12 tuổi (535 người dùng), già nhất là 70 tuổi (501 người dùng)
*/

----4.Top 5 sản phẩm mỗi tháng.
----Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm).