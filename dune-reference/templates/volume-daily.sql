-- Daily Volume Query Template
-- Usage: Replace {TABLE}, {PROJECT}, and {DAYS} with actual values
--
-- For Solana DEX: TABLE = dex_solana.trades, PROJECT = 'raydium', etc.
-- For EVM DEX: TABLE = dex.trades, add WHERE blockchain = '{CHAIN}'

-- Basic daily volume
SELECT
    block_date,
    SUM(amount_usd) AS daily_volume,
    COUNT(*) AS trade_count,
    COUNT(DISTINCT trader_id) AS unique_traders
FROM {TABLE}
WHERE project = '{PROJECT}'
    AND block_date >= CURRENT_DATE - INTERVAL '{DAYS}' DAY
GROUP BY block_date
ORDER BY block_date DESC;

-- ============================================
-- EXAMPLE: Raydium 30-day daily volume
-- ============================================
-- SELECT
--     block_date,
--     SUM(amount_usd) AS daily_volume,
--     COUNT(*) AS trade_count,
--     COUNT(DISTINCT trader_id) AS unique_traders
-- FROM dex_solana.trades
-- WHERE project = 'raydium'
--     AND block_date >= CURRENT_DATE - INTERVAL '30' DAY
-- GROUP BY block_date
-- ORDER BY block_date DESC;

-- ============================================
-- EXAMPLE: Uniswap on Ethereum 30-day volume
-- ============================================
-- SELECT
--     block_date,
--     SUM(amount_usd) AS daily_volume,
--     COUNT(*) AS trade_count,
--     COUNT(DISTINCT taker) AS unique_traders
-- FROM dex.trades
-- WHERE project = 'uniswap'
--     AND blockchain = 'ethereum'
--     AND block_date >= CURRENT_DATE - INTERVAL '30' DAY
-- GROUP BY block_date
-- ORDER BY block_date DESC;
