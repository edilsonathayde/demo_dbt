
WITH source_data AS 
(
    SELECT 
        SAFE_CAST(Date AS STRING) AS raw_date,  
        SAFE_CAST(Players AS INT64) AS players,
        SAFE_CAST(Bet_Amount AS FLOAT64) AS bet_amount_usd,
        SAFE_CAST(Profit AS FLOAT64) AS profit_usd
    FROM 
        {{ref('bronze_bet_data')}}
)

SELECT 
    PARSE_DATE('%m/%d/%Y', raw_date) AS date_parsed, 
    players,
    bet_amount_usd,
    profit_usd
FROM source_data
