WITH dates AS (
    SELECT DISTINCT date_parsed AS date_key
    FROM {{ ref('silver_bet_data') }}
    
    UNION DISTINCT
    
    SELECT DISTINCT exchange_date AS date_key
    FROM {{ ref('silver_exchange_rate') }}
)

SELECT
    date_key,
    EXTRACT(YEAR FROM date_key) AS year,
    EXTRACT(MONTH FROM date_key) AS month,
    EXTRACT(DAY FROM date_key) AS day,
    EXTRACT(WEEK FROM date_key) AS week,
    FORMAT_DATE('%A', date_key) AS day_of_week
FROM dates 
