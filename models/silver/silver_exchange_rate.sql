
WITH source AS 
( 
    SELECT 
        SAFE_CAST(date AS DATE) AS exchange_date, -- Garantindo formato DATE 
        base AS currency_origin, -- Moeda de origem 
        rates -- Mantendo rates como JSON 
    FROM 
        {{ref('bronze_exchange_rate')}}
)
,parsed AS 
(
    SELECT
        exchange_date, 
        currency_origin, 
        COALESCE( SAFE_CAST(JSON_VALUE(rates, "$.BRL") AS FLOAT64), 0) AS exchange_rate_brl 
    FROM 
        source
)

SELECT * FROM parsed 
