## Part One 

1. User repeat rate
``` sql
with repeat_users as (
  select 
    user_id, count(*)
  from femi.stg_orders
  group by 1
  having count(*) > 1
)
select (1.0*count(distinct ru.user_id))/count(distinct stg.user_id)
from femi.stg_orders stg
left join repeat_users ru 
on stg.user_id =ru.user_id;
```
**A:** 80.5%

2. Good indicators of user who will likely purchase again?
- Frequent visits to the website
- History of past purchases 
- Order multiple products 

Not likely to purchase again: 
- Single order with long time gap since the order was placed 
- Haven't visited the site since they placed an order 
- Frequently on the help page
- Don't check out the product pages 

If I had more data: 
- Do they try new products when they launch? 
- Returns - what is the return rate, who makes returns, etc
- Referrals - who makes referrals to other customers?


3. Why did you organize your marts models this way?
For the core metrics, things like users, products and orders will be relevant across broad areas of the business. MArketing might be more interested in specific user behaviour or session level behaviour which could help target certain customers or better converting regions for advertising. The product team will be interested in the performance of each product, so having a product pageviews fact table, or a daily product performance table will be helpful for them.

Le ~✨dag✨~
![](/dbt-greenery/imgs/dbt-dag.png)

## Part Two 

Lots of expected non-null fields had nulls - examples are event timestamps, order created_at dates. For a lot of these I worked around it by either changing the logic (ex for orders filtering only for cases where created at was available) or removing the null check (for things like pageviews there might be intermittent upstream issues with web tracking so 100% reliabilty might not be feasible). 

I would ensure the checks are consistently passing by running them with each build (for any update to the schema/models, run the full test suite). Would set thresholds/ranges for field values to catch bad data that may not be found through the basic tests (ex using great expectations to enhance coverage). 