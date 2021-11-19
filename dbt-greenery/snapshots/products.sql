{% snapshot products_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='product_id',
      strategy='check',
      check_cols=['name', 'price', 'quantity']
    )
  }}

  SELECT * 
  FROM {{ source('staging', 'products') }}

{% endsnapshot %}