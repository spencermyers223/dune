-- TVL / Lending Protocol Query Template
-- Usage: For lending protocols on EVM chains via lending spellbook
--
-- Note: Solana lending protocols (Kamino, Solend, MarginFi) may not be in
-- the lending spellbook - check protocol-specific YAMLs

-- Current total deposits by protocol
SELECT
    project,
    blockchain,
    SUM(amount_usd) AS total_deposits
FROM lending.supply
WHERE blockchain = '{CHAIN}'
    AND block_time >= CURRENT_DATE - INTERVAL '1' DAY
GROUP BY project, blockchain
ORDER BY total_deposits DESC;

-- ============================================
-- Daily deposits over time
-- ============================================
-- SELECT
--     DATE_TRUNC('day', block_time) AS day,
--     project,
--     SUM(amount_usd) AS daily_deposits
-- FROM lending.supply
-- WHERE project = '{PROJECT}'
--     AND blockchain = '{CHAIN}'
--     AND block_time >= CURRENT_DATE - INTERVAL '30' DAY
-- GROUP BY DATE_TRUNC('day', block_time), project
-- ORDER BY day DESC;

-- ============================================
-- Borrow volume by protocol
-- ============================================
-- SELECT
--     project,
--     blockchain,
--     SUM(amount_usd) AS total_borrows
-- FROM lending.borrow
-- WHERE blockchain = '{CHAIN}'
--     AND block_time >= CURRENT_DATE - INTERVAL '7' DAY
-- GROUP BY project, blockchain
-- ORDER BY total_borrows DESC;

-- ============================================
-- Utilization rate (borrows / deposits)
-- ============================================
-- WITH deposits AS (
--     SELECT
--         project,
--         SUM(amount_usd) AS total_deposits
--     FROM lending.supply
--     WHERE blockchain = '{CHAIN}'
--         AND block_time >= CURRENT_DATE - INTERVAL '1' DAY
--     GROUP BY project
-- ),
-- borrows AS (
--     SELECT
--         project,
--         SUM(amount_usd) AS total_borrows
--     FROM lending.borrow
--     WHERE blockchain = '{CHAIN}'
--         AND block_time >= CURRENT_DATE - INTERVAL '1' DAY
--     GROUP BY project
-- )
-- SELECT
--     d.project,
--     d.total_deposits,
--     COALESCE(b.total_borrows, 0) AS total_borrows,
--     ROUND(COALESCE(b.total_borrows, 0) / NULLIF(d.total_deposits, 0) * 100, 2) AS utilization_pct
-- FROM deposits d
-- LEFT JOIN borrows b ON d.project = b.project
-- ORDER BY d.total_deposits DESC;

-- ============================================
-- EXAMPLE: Aave deposits on Ethereum
-- ============================================
-- SELECT
--     DATE_TRUNC('day', block_time) AS day,
--     SUM(amount_usd) AS daily_deposits
-- FROM lending.supply
-- WHERE project = 'aave'
--     AND blockchain = 'ethereum'
--     AND block_time >= CURRENT_DATE - INTERVAL '30' DAY
-- GROUP BY DATE_TRUNC('day', block_time)
-- ORDER BY day DESC;

-- ============================================
-- NOTE: For Solana lending (Kamino, Solend, MarginFi)
-- These may not be in the lending spellbook.
-- Check the protocol-specific YAML for alternative approaches.
-- ============================================
