{% snapshot products_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='product_id',
      strategy='check',
      check_cols=['product_name', 'price', 'quantity']
    )
  }}

  SELECT * 
  FROM {{ source('source', 'products') }}

{% endsnapshot %}