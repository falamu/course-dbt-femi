{% snapshot promos_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='promo_id',
      strategy='check',
      check_cols=['active']
    )
  }}

  SELECT * 
  FROM {{ source('staging', 'promos') }}

{% endsnapshot %}