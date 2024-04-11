--------1-----------
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING ordernumber::integer,
ALTER COLUMN quantityordered TYPE integer USING quantityordered::integer,
ALTER COLUMN priceeach TYPE numeric USING priceeach::numeric,
ALTER COLUMN orderlinenumber TYPE integer USING orderlinenumber::integer,
ALTER COLUMN sales TYPE numeric USING sales::numeric,
ALTER COLUMN orderdate TYPE timestamp USING orderdate::timestamp,
ALTER COLUMN msrp TYPE integer USING msrp::integer;
--------2----------
SELECT ordernumber FROM public.sales_dataset_rfm_prj
WHERE ORDERNUMBER is null or QUANTITYORDERED is null or
PRICEEACH is null or ORDERLINENUMBER is null or SALES is null or 
ORDERDATE is null;
--------3----------
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN contactlastname VARCHAR(50),
ADD COLUMN contactfirstname VARCHAR(50);
