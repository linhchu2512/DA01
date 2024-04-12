--1-Chuyển đổi kiểu dữ liệu phù hợp cho các trường:
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING ordernumber::integer,
ALTER COLUMN quantityordered TYPE integer USING quantityordered::integer,
ALTER COLUMN priceeach TYPE numeric USING priceeach::numeric,
ALTER COLUMN orderlinenumber TYPE integer USING orderlinenumber::integer,
ALTER COLUMN sales TYPE numeric USING sales::numeric,
ALTER COLUMN orderdate TYPE timestamp USING orderdate::timestamp,
ALTER COLUMN msrp TYPE integer USING msrp::integer;
--2-Check NULL/BLANK:
SELECT ordernumber FROM public.sales_dataset_rfm_prj
WHERE ORDERNUMBER is null or QUANTITYORDERED is null or
PRICEEACH is null or ORDERLINENUMBER is null or SALES is null or 
ORDERDATE is null;
--3-Thêm cột:
--Thêm cột
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN contactlastname VARCHAR(50),
ADD COLUMN contactfirstname VARCHAR(50);
--Điền thông tin vào cột mới tách từ contactfullname + viết hoa chữ cái đầu
--Cách 1:
UPDATE public.sales_dataset_rfm_prj
SET
   contactlastname = upper(left(left(contactfullname,position('-' in contactfullname)-1),1))
                     ||
                     lower(right(left(contactfullname,position('-' in contactfullname)-1),length(left(contactfullname,position('-' in contactfullname)-1))-1)),
   contactfirstname = upper(left(right(contactfullname,length(contactfullname)-position('-' in contactfullname)),1))
                      ||
                      lower(right(right(contactfullname,length(contactfullname)-position('-' in contactfullname)),length(right(contactfullname,length(contactfullname)-position('-' in contactfullname)))-1));
--Cách 2:
UPDATE public.sales_dataset_rfm_prj
SET
   contactlastname = left(contactfullname,position('-' in contactfullname)-1),
   contactfirstname = right(contactfullname,length(contactfullname)-position('-' in contactfullname));
UPDATE public.sales_dataset_rfm_prj
SET
   contactlastname = INITCAP(contactlastname),
   contactfirstname = INITCAP(contactfirstname);
--4-Thêm cột quar,month,year:
--Thêm cột
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN QTR_ID int,
ADD COLUMN MONTH_ID int,
ADD COLUMN YEAR_ID int;
--Điền thông tin
UPDATE public.sales_dataset_rfm_prj
SET
   QTR_ID = extract(quarter from orderdate),
   MONTH_ID = extract(month from orderdate),
   YEAR_ID = extract(year from orderdate);
--5-Tìm oulier cho cột quantityorder:
--Sử dụng Boxplot:
with cte as
(select Q1-1.5*IQR as min, Q3+1.5*IQR as max from
(select
  percentile_cont(0.25) within group (order by quantityordered) as Q1,
  percentile_cont(0.75) within group (order by quantityordered) as Q3,
  percentile_cont(0.75) within group (order by quantityordered)-percentile_cont(0.25) within group (order by quantityordered) as IQR
from public.sales_dataset_rfm_prj) as temp)
   
select quantityordered from public.sales_dataset_rfm_prj
where quantityordered < (select min from cte) or quantityordered > (select max from cte);
--Sử dụng Z-score:
with cte as
(
	select quantityordered,
	(select avg(quantityordered) from public.sales_dataset_rfm_prj) as avg,
	(select stddev(quantityordered) from public.sales_dataset_rfm_prj) as stddev
	from public.sales_dataset_rfm_prj
   )
   
select quantityordered, (quantityordered - avg)/stddev as z_score
from cte
where abs((quantityordered - avg)/stddev) > 3;
