## Project 1 SQL Q's

1. Unique users

```sql 
select 
	count(distinct user_id)  as users
from femi.stg_users; 
```
**A:** `130 unique users`

2. Average orders/hour

``` sql
with hourly_orders as (
	select 
        date_trunc('hour', created_at) as order_hour,
		count(*) as orders
	from femi.stg_orders
    where created_at is not null
    group by 1
) 
select  
	avg(orders) as avg_hourly_orders
from hourly_orders;
```
**A:** `8.125 orders/hour on average`

3. Average time to deliver an order

```sql
select 
    avg(
        extract(epoch from delivered_at - created_at)
        )/3600 as avg_delivery_hours
from femi.stg_orders
where delivered_at is not null
    and created_at is not null;
```
**A:** `94.22 hours from order to delivery on average`

4. Customers making 1, 2 or 3+ purchases

``` sql
with user_orders as (
    select 
        user_id, 
        count(distinct order_id) as orders
    from femi.stg_orders
    group by 1
)
select 
    case when orders >= 3 then '3+' else orders::varchar end as times_ordered, 
    count(distinct user_id) as num_users
from user_orders
group by 1
order by 1;
```
**A:** 
    ```1 order - 25,
    2 orders - 22,
    3+ orders - 81
    ```

5. Average unique hourly sessions

``` sql
with hourly_sessions as (
	select 
        date_trunc('hour', created_at) as session_hour,
		count(distinct session_id) as unique_sessions
	from femi.stg_events
    where created_at is not null
    group by 1
) 
select  
	avg(unique_sessions) as avg_hourly_sessions
from hourly_sessions;
```
**A:** `7.27 unique sessions/hour on average`