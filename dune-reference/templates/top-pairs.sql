-- Top Trading Pairs Query Template
-- Usage: Replace {TABLE}, {PROJECT}, and time parameters
--
-- For Solana: TABLE = dex_solana.trades
-- For EVM: TABLE = dex.trades, add blockchain filter

-- Top pairs by volume
SELECT
    token_pair,
    SUM(amount_usd) AS volume,
    COUNT(*) AS trade_count,
    COUNT(DISTINCT trader_id) AS unique_traders,
    AVG(amount_usd) AS avg_trade_size
FROM {TABLE}
WHERE project = '{PROJECT}'
    AND block_date >= CURRENT_DATE - INTERVAL '{DAYS}' DAY
GROUP BY token_pair
ORDER BY volume DESC
LIMIT 20;

-- ============================================
-- Top pairs with token details
-- ============================================
-- SELECT
--     token_bought_symbol,
--     token_sold_symbol,
--     token_pair,
--     SUM(amount_usd) AS volume,
--     COUNT(*) AS trade_count
-- FROM {TABLE}
-- WHERE project = '{PROJECT}'
--     AND block_date >= CURRENT_DATE - INTERVAL '7' DAY
-- GROUP BY token_bought_symbol, token_sold_symbol, token_pair
-- ORDER BY volume DESC
-- LIMIT 20;

-- ============================================
-- Pair volume trend over time
-- ============================================
-- SELECT
--     block_date,
--     token_pair,
--     SUM(amount_usd) AS daily_volume
-- FROM {TABLE}
-- WHERE project = '{PROJECT}'
--     AND token_pair = '{TOKEN_PAIR}'
--     AND block_date >= CURRENT_DATE - INTERVAL '30' DAY
-- GROUP BY block_date, token_pair
-- ORDER BY block_date DESC;

-- ============================================
-- New pairs (first seen recently)
-- ============================================
-- WITH pair_first_seen AS (
--     SELECT
--         token_pair,
--         MIN(block_date) AS first_trade_date
--     FROM {TABLE}
--     WHERE project = '{PROJECT}'
--     GROUP BY token_pair
-- )
-- SELECT
--     p.token_pair,
--     p.first_trade_date,
--     SUM(t.amount_usd) AS total_volume,
--     COUNT(*) AS trade_count
-- FROM pair_first_seen p
-- JOIN {TABLE} t ON p.token_pair = t.token_pair
-- WHERE p.first_trade_date >= CURRENT_DATE - INTERVAL '7' DAY
--     AND t.project = '{PROJECT}'
-- GROUP BY p.token_pair, p.first_trade_date
-- ORDER BY total_volume DESC
-- LIMIT 20;

-- ============================================
-- EXAMPLE: Raydium top pairs (7 days)
-- ============================================
-- SELECT
--     token_pair,
--     SUM(amount_usd) AS volume,
--     COUNT(*) AS trade_count,
--     COUNT(DISTINCT trader_id) AS unique_traders
-- FROM dex_solana.trades
-- WHERE project = 'raydium'
--     AND block_date >= CURRENT_DATE - INTERVAL '7' DAY
-- GROUP BY token_pair
-- ORDER BY volume DESC
-- LIMIT 20;
