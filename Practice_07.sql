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
