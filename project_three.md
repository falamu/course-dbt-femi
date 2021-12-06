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

    product_name     |       conversion       
---------------------+------------------------
 Monstera            | 0.44642857142857142857
 Peace Lily          | 0.42857142857142857143
 Alocasia Polly      | 0.36842105263157894737
 Money Tree          | 0.41666666666666666667
 Jade Plant          | 0.44680851063829787234
 Calathea Makoyana   | 0.44262295081967213115
 String of pearls    | 0.44705882352941176471
 Aloe Vera           | 0.44927536231884057971
 Birds Nest Fern     | 0.44444444444444444444
 ZZ Plant            | 0.42857142857142857143
 Ponytail Palm       | 0.42424242424242424242
 Spider Plant        | 0.40322580645161290323
 Ficus               | 0.42424242424242424242
 Orchid              | 0.47826086956521739130
 Fiddle Leaf Fig     | 0.48148148148148148148
 Rubber Plant        | 0.39705882352941176471
 Devil's Ivy         | 0.32786885245901639344
 Bamboo              | 0.44871794871794871795
 Dragon Tree         | 0.40845070422535211268
 Boston Fern         | 0.42622950819672131148

 