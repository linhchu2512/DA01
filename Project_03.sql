----1. Doanh thu theo từng ProductLine, Year  và DealSize?
select PRODUCTLINE, YEAR_ID, DEALSIZE, 
sum (sales) as REVENUE
from public.sales_dataset_rfm_prj_clean
where status = 'Shipped'
group by PRODUCTLINE, YEAR_ID, DEALSIZE

----2. Đâu là tháng có bán tốt nhất mỗi năm?
with cte as (
select MONTH_ID, year_id,
sum (sales) as REVENUE,
count (distinct ordernumber) as order_number,
dense_rank () over (partition by year_id order by sum (sales) desc ) as rank
from public.sales_dataset_rfm_prj_clean
where status = 'Shipped'
group by MONTH_ID, year_id)
select MONTH_ID, year_id, REVENUE, order_number
from cte
where rank = 1

----3. Product line nào được bán nhiều ở tháng 11?
select MONTH_ID, PRODUCTLINE,
sum (sales) as REVENUE, 
count (ordernumber) as ORDER_NUMBER
from public.sales_dataset_rfm_prj_clean
where month_id = 11 and status = 'Shipped'
group by MONTH_ID, PRODUCTLINE
order by revenue desc
limit 1

--> Classic Cars

----4. Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm?
with cte as (
select YEAR_ID, PRODUCTLINE,
sum (sales) as REVENUE,
rank () over (partition by year_id order by sum (sales) desc ) as rank
from public.sales_dataset_rfm_prj_clean
where status = 'Shipped' and country = 'UK'
group by YEAR_ID, PRODUCTLINE)
select *
from cte
where rank = 1

----5. Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
--Tính giá trị RFM
With cte as
(select customername,
current_date - max (orderdate) as R,
count (distinct ordernumber) as F,
sum (sales) as M
from public.sales_dataset_rfm_prj_clean
group by customername),
--Phân nhóm theo RFM
cte1 as
(select customername,
 ntile (5) over (order by R desc) as R_score,
 ntile (5) over (order by F) as F_score,
 ntile (5) over (order by M) as M_score
 from cte),
cte2 as
(select customername,
cast (R_score as varchar)||cast (F_score as varchar)||cast (M_score as varchar) as RFM_score
from cte1)
select a.customername, a.RFM_score
from cte2 as a
join public.segment_score as b on a.RFM_score = b.scores
where segment = 'Champions'
order by rfm_score desc
