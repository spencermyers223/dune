-- Unique Users Query Template
-- Usage: Replace {TABLE}, {PROJECT}, and time parameters
--
-- For Solana: user column is trader_id
-- For EVM: user column is taker or tx_from depending on table

-- Basic unique users count
SELECT
    COUNT(DISTINCT trader_id) AS unique_traders
FROM {TABLE}
WHERE project = '{PROJECT}'
    AND block_date >= CURRENT_DATE - INTERVAL '{DAYS}' DAY;

-- ============================================
-- Daily Active Users (DAU) over time
-- ============================================
-- SELECT
--     block_date,
--     COUNT(DISTINCT trader_id) AS daily_active_users
-- FROM {TABLE}
-- WHERE project = '{PROJECT}'
--     AND block_date >= CURRENT_DATE - INTERVAL '30' DAY
-- GROUP BY block_date
-- ORDER BY block_date DESC;

-- ============================================
-- User retention cohort analysis
-- ============================================
-- WITH first_trade AS (
--     SELECT
--         trader_id,
--         MIN(block_date) AS first_trade_date
--     FROM {TABLE}
--     WHERE project = '{PROJECT}'
--     GROUP BY trader_id
-- ),
-- user_activity AS (
--     SELECT
--         t.trader_id,
--         f.first_trade_date,
--         t.block_date
--     FROM {TABLE} t
--     JOIN first_trade f ON t.trader_id = f.trader_id
--     WHERE t.project = '{PROJECT}'
-- )
-- SELECT
--     first_trade_date AS cohort_week,
--     COUNT(DISTINCT trader_id) AS new_users,
--     COUNT(DISTINCT CASE WHEN block_date > first_trade_date THEN trader_id END) AS returned
-- FROM user_activity
-- WHERE first_trade_date >= CURRENT_DATE - INTERVAL '56' DAY  -- 8 weeks
-- GROUP BY first_trade_date
-- ORDER BY cohort_week DESC;

-- ============================================
-- New vs returning users
-- ============================================
-- WITH first_trade AS (
--     SELECT
--         trader_id,
--         MIN(block_date) AS first_trade_date
--     FROM {TABLE}
--     WHERE project = '{PROJECT}'
--     GROUP BY trader_id
-- )
-- SELECT
--     t.block_date,
--     COUNT(DISTINCT CASE WHEN t.block_date = f.first_trade_date THEN t.trader_id END) AS new_users,
--     COUNT(DISTINCT CASE WHEN t.block_date > f.first_trade_date THEN t.trader_id END) AS returning_users
-- FROM {TABLE} t
-- JOIN first_trade f ON t.trader_id = f.trader_id
-- WHERE t.project = '{PROJECT}'
--     AND t.block_date >= CURRENT_DATE - INTERVAL '30' DAY
-- GROUP BY t.block_date
-- ORDER BY t.block_date DESC;

-- ============================================
-- EXAMPLE: Raydium 7-day unique traders
-- ============================================
-- SELECT
--     COUNT(DISTINCT trader_id) AS unique_traders
-- FROM dex_solana.trades
-- WHERE project = 'raydium'
--     AND block_date >= CURRENT_DATE - INTERVAL '7' DAY;
