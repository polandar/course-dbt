## Answers for W3 questions

### What is our overall conversion rate?

Query:
```

  SELECT
  ROUND(
    CAST(
      COUNT(
        DISTINCT CASE WHEN checkout_events > 0 THEN session_id END
      ) AS NUMERIC
    )/
    CAST(
      COUNT(
        DISTINCT session_id
      ) AS NUMERIC
    ) * 100, 2
  ) AS overall_conversion_rate_pct

  FROM dbt_rolandas_g.fact_sessions
```

Answer:
```
62.46%
```

### What is our conversion rate by product?

Query:
```
SELECT
    product_name,
    product_conversion_rate as product_conversion_pct
FROM dbt_rolandas_g.fact_product_sessions
```

Answer:
| product_name | conversion_rate_pct |
|--|--|
|Bird of Paradise|55.00|
|Devil's Ivy|53.33|
|Dragon Tree|54.84|
|Pothos|39.34|
|Philodendron|51.61|
|Rubber Plant|59.26|
|Angel Wings Begonia|52.46|
|Pilea Peperomioides|52.54|
|Majesty Palm|56.72|
|Aloe Vera|55.38|
|Spider Plant|50.85|
|Bamboo|62.69|
|Alocasia Polly|52.94|
|Arrow Head|61.90|
|Pink Anthurium|50.00|
|Ficus|51.47|
|Jade Plant|52.17|
|ZZ Plant|55.56|
|Calathea Makoyana|60.38|
|Birds Nest Fern|51.28|
|Monstera|53.06|
|Cactus|58.18|
|Orchid|49.33|
|Money Tree|46.43|
|Ponytail Palm|42.86|
|Boston Fern|53.97|
|Peace Lily|53.03|
|Fiddle Leaf Fig|53.57|
|Snake Plant|46.58|
|String of pearls|68.75|


## Answers for W2 questions

### What is our user repeat rate?

```
WITH user_orders AS (
    SELECT
        user_id,
        COUNT(distinct order_id) AS orders
    FROM dbt_rolandas_g.fact_orders
    GROUP BY user_id
)

SELECT (
    COUNT(
        CASE
            WHEN orders > 1 THEN 1
            ELSE NULL END
    )::numeric / COUNT(user_id)) * 100
FROM user_orders;
```

Answer:
```
79.84%
```

### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Users who keep coming back, haave many sessions are more likely to convert better than those with fewer sessions.  Belonging to a particular cohort (age, address, time of order) can also influence whether a user is more likely to convert or not.  Another important factor is whether promos encourage or discourage purchasing.

It would be helpful to see more marketing data aboput the users, say numebr of emails they have received, whether they clicked on promos/emails, why they ended up on the website in the first place, etc.

### Explain the marts models you added. Why did you organize the models in the way you did?

**core**
* dim_users.sql: Combines users and addresses for more complete user information
* dim_products.sql: Combines products and line items for a fuller view
* fact_orders.sql: Combines orders and line items

I feel like the latter two could be combined into one but not sure

**marketing**
* fact_user_orders.sql: orders and users in one space

**product**
* fact_page_views.sql: shows all events on the website and the affected users

## Answers for W1 questions

### How many users do we have?

Query
```
select 
  count(distinct(user_id)) 
from dbt_rolandas_g.stg_users;
```

Answer
```
130
```

### How many orders do we receive per hour?

Query
```
with order_per_hr as
(
  select
    date_trunc('hour', created_at) as created_hr,
    count(distinct order_id) as no_of_orders
  from dbt_rolandas_g.stg_orders
  group by 1
)

select 
  avg(no_of_orders) 
from order_per_hr
```

Answer
```
7.52
```

### On average, how long does an order take from being placed to being delivered?

Query
```
select 
  avg(delivered_at-created_at)
from dbt_rolandas_g.stg_orders
where
  order_status = 'delivered'
```

Answer
```
3 days 21:24:12 (or ~93.4hrs)
```

### How many users have only made one purchase? Two purchases? Three+ purchases?

Query
```
with order_count_per_user as
(
  select 
    count(distinct order_id) as num_of_orders,
    user_id
  from dbt_rolandas_g.stg_orders
  group by user_id
)

select
  case 
    when num_of_orders < 3 
    then num_of_orders::varchar
    else '3 or more'
  end as num_of_orders,
  count(distinct user_id) as num_of_users
from order_count_per_user
group by 1
```

Answer
| # num_of_orders | # num_of_users |
|-------------|---------|
|1|25|
|2|28|
|3 or more|71|

### On average, how many unique sessions do we have per hour?

Query
```
with sessions_per_hr as
(
  select
    date_trunc('hour', created_at) as created_hr,
    count(distinct session_id) as unique_sessions
  from dbt_rolandas_g.stg_events
  group by 1
)

select 
  avg(unique_sessions) 
from sessions_per_hr
```

Answer
```
16.33
```