WITH players AS (
    SELECT DISTINCT
        SAFE_CAST(players AS STRING) AS player_id
    FROM {{ ref('silver_bet_data') }}
)
SELECT
    player_id
FROM players