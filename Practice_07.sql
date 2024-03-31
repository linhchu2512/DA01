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
with cte AS
(
SELECT *,
lag (tweet_count) over (partition by user_id order by tweet_date) as lag1,
lag (tweet_count,2) over (partition by user_id order by tweet_date) as lag2
FROM tweets
)
select user_id, tweet_date,
case 
when lag1 is not null and lag2 is not null then round((tweet_count+lag1+lag2)/3.0,2)
when lag1 is not null and lag2 is null then round((tweet_count+lag1)/2.0,2)
when lag1 is null and lag2 is not null then round((tweet_count+lag2)/2.0,2)
else round(tweet_count,2)
end as rolling_avg_3d
from cte;

--Ex6:
with payments as 
(
SELECT merchant_id,
transaction_timestamp - lag(transaction_timestamp)
over (partition by merchant_id, credit_card_id,amount
order by transaction_timestamp) as time_difference
from transactions
)
select count(merchant_id) as payment_count
from payments
where time_difference <= '00:10:00';

--Ex7:
with cte as 
(
select category, product,
sum(spend) as total_spend,
rank () over(partition by category order by sum(spend) desc) as rank
from product_spend
where extract(year from transaction_date) =2022
group by category, product
order by category, total_spend desc
)
select category, product, total_spend
from cte 
where rank <=2;

--Ex8:
with cte AS
(
SELECT a.artist_name,
count(*),
dense_rank() over(order by count(*) desc) as artist_rank
FROM global_song_rank as g
join songs as s on g.song_id = s.song_id
join artists as a on s.artist_id = a.artist_id
where rank <= 10
group by(a.artist_name)
order by count(*) desc
)
select artist_name,artist_rank
from cte
where artist_rank<=5;
