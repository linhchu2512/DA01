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
UPDATE public.sales_dataset_rfm_prj
SET
   contactlastname = upper(left(left(contactfullname,position('-' in contactfullname)-1),1))
                     ||
                     lower(right(left(contactfullname,position('-' in contactfullname)-1),length(left(contactfullname,position('-' in contactfullname)-1))-1)),
   contactfirstname = upper(left(right(contactfullname,length(contactfullname)-position('-' in contactfullname)),1))
                      ||
                      lower(right(right(contactfullname,length(contactfullname)-position('-' in contactfullname)),length(right(contactfullname,length(contactfullname)-position('-' in contactfullname)))-1));
