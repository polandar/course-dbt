with dim_users as (
    select
        users.user_id,
        users.address_id as user_address_id,
        users.first_name,
        users.last_name,
        users.email,
        users.phone_number,
        users.created_at_utc,
        users.updated_at_utc,
        addresses.address_id,
        addresses.full_address,
        addresses.zipcode,
        addresses.state_name,
        addresses.country
    from {{ ref('stg_users') }} users
    left join {{ ref('stg_addresses') }} addresses 
    on users.address_id = addresses.address_id
)

select * from dim_users