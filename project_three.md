## Questions 

1. Overall conversion rate 

I defined conversion rate as the # of sessions with a checkout/total # of sessions 

``` sql
SELECT 
  1.0* COUNT(*) FILTER (WHERE session_has_checkout)/COUNT(distinct session_id) as conversion_rate
FROM femi.fact_sessions;
```

**A:** 40.8%


1b. Conversion rate by product

I defined conversion as the # of orders with a product/total # of sessions that interacted with a product (had _any_ event ex. pageview, add to cart, etc)

```sql
SELECT 
  product_name, 
  1.0*SUM(daily_orders_containing_product)/ SUM(daily_sessions) as conversion
FROM femi.fact_daily_product_page_performance
JOIN femi.dim_products USING (product_id)
GROUP BY 1;
```

![](/dbt-greenery/imgs/product_performance.png)