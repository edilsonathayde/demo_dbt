
SELECT
    exchange_date AS date_key,
    ROUND(exchange_rate_brl, 4) AS exchange_rate_brl
FROM {{ ref('silver_exchange_rate') }}
