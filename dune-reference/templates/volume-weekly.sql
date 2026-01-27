-- Weekly Volume Query Template
-- Usage: Replace {TABLE}, {PROJECT}, and {DAYS} with actual values
-- Note: Dune SQL uses DAY not WEEK in INTERVAL syntax
--
-- For Solana DEX: TABLE = dex_solana.trades
-- For EVM DEX: TABLE = dex.trades, add WHERE blockchain = '{CHAIN}'

-- Basic weekly volume with week-over-week comparison
-- Use INTERVAL in days: 12 weeks = 84 days, 8 weeks = 56 days, 4 weeks = 28 days
SELECT
    DATE_TRUNC('week', block_date) AS week_start,
    SUM(amount_usd) AS weekly_volume,
    COUNT(*) AS trade_count,
    COUNT(DISTINCT trader_id) AS unique_traders,
    AVG(amount_usd) AS avg_trade_size
FROM {TABLE}
WHERE project = '{PROJECT}'
    AND block_date >= CURRENT_DATE - INTERVAL '{DAYS}' DAY
GROUP BY DATE_TRUNC('week', block_date)
ORDER BY week_start DESC;

-- ============================================
-- With week-over-week growth calculation
-- ============================================
-- WITH weekly_data AS (
--     SELECT
--         DATE_TRUNC('week', block_date) AS week_start,
--         SUM(amount_usd) AS weekly_volume
--     FROM {TABLE}
--     WHERE project = '{PROJECT}'
--         AND block_date >= CURRENT_DATE - INTERVAL '{DAYS}' DAY
--     GROUP BY DATE_TRUNC('week', block_date)
-- )
-- SELECT
--     week_start,
--     weekly_volume,
--     LAG(weekly_volume) OVER (ORDER BY week_start) AS prev_week_volume,
--     ROUND(
--         (weekly_volume - LAG(weekly_volume) OVER (ORDER BY week_start))
--         / NULLIF(LAG(weekly_volume) OVER (ORDER BY week_start), 0) * 100,
--         2
--     ) AS wow_growth_pct
-- FROM weekly_data
-- ORDER BY week_start DESC;

-- ============================================
-- EXAMPLE: Meteora 12-week volume (84 days)
-- ============================================
-- SELECT
--     DATE_TRUNC('week', block_date) AS week_start,
--     SUM(amount_usd) AS weekly_volume,
--     COUNT(*) AS trade_count,
--     COUNT(DISTINCT trader_id) AS unique_traders
-- FROM dex_solana.trades
-- WHERE project = 'meteora'
--     AND block_date >= CURRENT_DATE - INTERVAL '84' DAY
-- GROUP BY DATE_TRUNC('week', block_date)
-- ORDER BY week_start DESC;
