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