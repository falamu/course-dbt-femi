{% snapshot orders_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='order_id',
      strategy='check',
      check_cols=[
            'tracking_id', 'shipping_service', 'estimated_delivery_at', 
            'delivered_at', 'status'
        ]
    )
  }}

  SELECT * 
  FROM {{ source('source', 'orders') }}

{% endsnapshot %}