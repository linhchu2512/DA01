--Ex1:
With twt_transaction AS
(
SELECT 
extract(year from transaction_date) as year,
product_id,
sum (spend) as curr_year_spend
FROM user_transactions
group by product_id, year
)
SELECT year, product_id, curr_year_spend,
lag(curr_year_spend) over(partition by product_id order by year) as prev_year_spend,
round(100*(curr_year_spend-lag(curr_year_spend) over(partition by product_id order by year))/lag(curr_year_spend) over(partition by product_id order by year),2) as yoy_rate
from twt_transaction

--Ex2:
with twt_monthly_card_issue AS
(
SELECT issue_month,issue_year,
card_name,issued_amount,
rank () over(partition by card_name order by issue_year,issue_month)
FROM monthly_cards_issued)
select card_name, issued_amount
from twt_monthly_card_issue
where rank = 1
order by issued_amount desc;
--Ex3:
with twt_transactions as 
(
SELECT *,
rank () over (partition by user_id order by transaction_date)
FROM transactions
)
select user_id, spend, transaction_date
from twt_transactions
where rank = 3;

--Ex4:
with twt_transactions AS
(
SELECT 
transaction_date,
user_id,
count (product_id) over(partition by user_id order by transaction_date desc) as purchase_count,
rank () over(partition by user_id order by transaction_date desc)
FROM user_transactions
)
select distinct transaction_date, user_id,purchase_count
from twt_transactions
where rank = 1;

--Ex5:
