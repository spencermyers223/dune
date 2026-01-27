-- Token Transfers Query Template
-- Usage: For tracking token flows and whale movements
--
-- For EVM: Use tokens.transfers spellbook
-- For Solana: Use raw token transfer tables

-- ============================================
-- EVM Token Transfers (tokens.transfers spellbook)
-- ============================================

-- Large transfers for a specific token
SELECT
    block_time,
    tx_hash,
    "from" AS sender,
    "to" AS receiver,
    amount,
    amount_usd
FROM tokens.transfers
WHERE blockchain = '{CHAIN}'
    AND contract_address = '{TOKEN_ADDRESS}'
    AND block_time >= CURRENT_DATE - INTERVAL '{DAYS}' DAY
    AND amount_usd >= {MIN_USD}
ORDER BY amount_usd DESC
LIMIT 100;

-- ============================================
-- Daily transfer volume for a token
-- ============================================
-- SELECT
--     DATE_TRUNC('day', block_time) AS day,
--     COUNT(*) AS transfer_count,
--     SUM(amount) AS total_amount,
--     SUM(amount_usd) AS total_usd,
--     COUNT(DISTINCT "from") AS unique_senders,
--     COUNT(DISTINCT "to") AS unique_receivers
-- FROM tokens.transfers
-- WHERE blockchain = '{CHAIN}'
--     AND contract_address = '{TOKEN_ADDRESS}'
--     AND block_time >= CURRENT_DATE - INTERVAL '30' DAY
-- GROUP BY DATE_TRUNC('day', block_time)
-- ORDER BY day DESC;

-- ============================================
-- Top token holders activity
-- ============================================
-- WITH transfers AS (
--     SELECT
--         "to" AS address,
--         SUM(amount) AS received
--     FROM tokens.transfers
--     WHERE blockchain = '{CHAIN}'
--         AND contract_address = '{TOKEN_ADDRESS}'
--         AND block_time >= CURRENT_DATE - INTERVAL '30' DAY
--     GROUP BY "to"
-- ),
-- sends AS (
--     SELECT
--         "from" AS address,
--         SUM(amount) AS sent
--     FROM tokens.transfers
--     WHERE blockchain = '{CHAIN}'
--         AND contract_address = '{TOKEN_ADDRESS}'
--         AND block_time >= CURRENT_DATE - INTERVAL '30' DAY
--     GROUP BY "from"
-- )
-- SELECT
--     COALESCE(t.address, s.address) AS address,
--     COALESCE(t.received, 0) AS received,
--     COALESCE(s.sent, 0) AS sent,
--     COALESCE(t.received, 0) - COALESCE(s.sent, 0) AS net_flow
-- FROM transfers t
-- FULL OUTER JOIN sends s ON t.address = s.address
-- ORDER BY ABS(COALESCE(t.received, 0) - COALESCE(s.sent, 0)) DESC
-- LIMIT 50;

-- ============================================
-- Whale alerts (large single transfers)
-- ============================================
-- SELECT
--     block_time,
--     tx_hash,
--     "from" AS sender,
--     "to" AS receiver,
--     amount,
--     amount_usd
-- FROM tokens.transfers
-- WHERE blockchain = '{CHAIN}'
--     AND contract_address = '{TOKEN_ADDRESS}'
--     AND amount_usd >= 1000000  -- $1M+ transfers
--     AND block_time >= CURRENT_DATE - INTERVAL '7' DAY
-- ORDER BY block_time DESC;

-- ============================================
-- EXAMPLE: USDC transfers > $100K on Ethereum
-- ============================================
-- SELECT
--     block_time,
--     tx_hash,
--     "from" AS sender,
--     "to" AS receiver,
--     amount,
--     amount_usd
-- FROM tokens.transfers
-- WHERE blockchain = 'ethereum'
--     AND contract_address = '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'  -- USDC
--     AND block_time >= CURRENT_DATE - INTERVAL '1' DAY
--     AND amount_usd >= 100000
-- ORDER BY amount_usd DESC
-- LIMIT 100;

-- ============================================
-- NOTE: For Solana token transfers, check the
-- solana.token_transfers or protocol-specific tables.
-- Solana uses different column names and mint addresses.
-- ============================================
