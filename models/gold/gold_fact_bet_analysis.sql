WITH bets AS (
    SELECT 
        date_parsed AS date_key,
        SAFE_CAST(players AS STRING) AS player_id,
        ROUND(bet_amount_usd, 2) AS bet_amount_usd,
        ROUND(profit_usd, 2) AS profit_usd
    FROM {{ ref('silver_bet_data') }}
),
exchange_rates AS (
    SELECT 
        date_key,   
        ROUND(exchange_rate_brl, 4) AS exchange_rate_on_date
    FROM {{ ref('gold_dim_currency') }}
),
latest_exchange AS (
    SELECT exchange_rate_brl AS exchange_rate_today 
    FROM {{ ref('gold_dim_currency') }}
    ORDER BY date_key DESC 
    LIMIT 1
),
joined AS (
    SELECT
        bets.date_key,
        players.player_id,
        bets.bet_amount_usd,
        bets.profit_usd,
        rates.exchange_rate_on_date,
        ROUND(bets.bet_amount_usd * rates.exchange_rate_on_date, 2) AS bet_amount_brl_on_date,
        ROUND(bets.profit_usd * rates.exchange_rate_on_date, 2) AS profit_brl_on_date,
        latest_exchange.exchange_rate_today,
        ROUND(bets.bet_amount_usd * latest_exchange.exchange_rate_today, 2) AS bet_amount_brl_today,
        ROUND(bets.profit_usd * latest_exchange.exchange_rate_today, 2) AS profit_brl_today
    FROM bets
    LEFT JOIN {{ ref('gold_dim_players') }} players ON bets.player_id = players.player_id
    LEFT JOIN exchange_rates rates ON bets.date_key = rates.date_key
    CROSS JOIN latest_exchange
)
SELECT * FROM joined
