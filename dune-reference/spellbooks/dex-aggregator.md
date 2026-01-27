# DEX Aggregator Tables - Dune Schema Documentation

## Current Status: NEEDS VERIFICATION

DEX aggregator data covers protocols like Jupiter (Solana), 1inch (EVM), and others that route trades through multiple underlying DEXs.

**Important:** The exact table names need verification in Dune's data explorer. Possible table structures:
- `dex_aggregator.trades` (multi-chain with blockchain filter)
- `dex_aggregator_solana.trades` (Solana-specific)
- `jupiter_solana.trades` (protocol-specific namespace)

---

## dex_aggregator_solana.trades (Unverified)

**Full Path:** `dex_aggregator_solana.trades` (needs verification)
**Category:** DEX Aggregator Trading
**Description:** Trades executed through DEX aggregators on Solana
**Supported Protocols:** Jupiter, and potentially others

**Key Distinction from dex_solana.trades:**
- `dex_solana.trades` contains trades at the underlying DEX level (raydium, orca, etc.)
- `dex_aggregator_solana.trades` contains the aggregator-level view (jupiter routing through multiple DEXs)
- A single Jupiter swap may result in multiple entries in `dex_solana.trades` but one entry in `dex_aggregator_solana.trades`

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| blockchain | string | Always "solana" |
| project | string | Aggregator name (e.g., 'jupiter') |
| version | integer | Protocol version |
| block_month | date | Month (for partitioning) |
| block_date | date | Date of transaction |
| block_time | timestamp | Exact time |
| block_slot | long | Solana block slot number |
| trade_source | string | Source identifier |
| token_bought_symbol | string | Symbol of token received |
| token_sold_symbol | string | Symbol of token sent |
| token_pair | string | Token pair (e.g., SOL/USDC) |
| token_bought_amount | double | Amount received (normalized) |
| token_sold_amount | double | Amount sent (normalized) |
| token_bought_amount_raw | uint256 | Raw amount received |
| token_sold_amount_raw | uint256 | Raw amount sent |
| amount_usd | double | Trade value in USD |
| fee_usd | double | Fee amount in USD |
| token_bought_mint_address | string | Mint address of token received |
| token_sold_mint_address | string | Mint address of token sent |
| trader_id | string | User wallet address |
| tx_id | string | Transaction signature |

---

## Example Queries (Unverified)

**Jupiter weekly volume:**
```sql
-- Table name needs verification
SELECT
  DATE_TRUNC('week', block_date) AS week,
  SUM(amount_usd) AS weekly_volume,
  COUNT(*) AS trade_count,
  COUNT(DISTINCT trader_id) AS unique_traders
FROM dex_aggregator_solana.trades
WHERE project = 'jupiter'
  AND block_date >= CURRENT_DATE - INTERVAL '84' DAY  -- 12 weeks
GROUP BY DATE_TRUNC('week', block_date)
ORDER BY week DESC
```

**Alternative if table is multi-chain:**
```sql
-- If using unified dex_aggregator.trades table
SELECT
  DATE_TRUNC('week', block_date) AS week,
  SUM(amount_usd) AS weekly_volume,
  COUNT(*) AS trade_count
FROM dex_aggregator.trades
WHERE blockchain = 'solana'
  AND project = 'jupiter'
  AND block_date >= CURRENT_DATE - INTERVAL '84' DAY  -- 12 weeks
GROUP BY DATE_TRUNC('week', block_date)
ORDER BY week DESC
```

**Daily Jupiter volume:**
```sql
SELECT
  block_date,
  SUM(amount_usd) AS daily_volume,
  COUNT(DISTINCT trader_id) AS unique_traders
FROM dex_aggregator_solana.trades
WHERE project = 'jupiter'
  AND block_date >= CURRENT_DATE - INTERVAL '30' DAY
GROUP BY block_date
ORDER BY block_date DESC
```

---

## Verification Steps

To confirm the correct table structure in Dune:

1. **Check available tables:**
   ```sql
   SHOW TABLES LIKE '%aggregator%'
   ```

2. **Explore Jupiter-specific tables:**
   ```sql
   SHOW TABLES LIKE '%jupiter%'
   ```

3. **Check table schema:**
   ```sql
   DESCRIBE dex_aggregator_solana.trades
   ```

4. **Sample data check:**
   ```sql
   SELECT *
   FROM dex_aggregator_solana.trades
   WHERE block_date = CURRENT_DATE - INTERVAL '1' DAY
   LIMIT 10
   ```

---

## Related Tables

| Table | Description |
|-------|-------------|
| dex_solana.trades | Underlying DEX trades (raydium, orca, etc.) |
| dex_aggregator_solana.trades | Aggregator-level trades (jupiter) |
| dex.trades | Multi-chain DEX trades (EVM chains) |
| dex_aggregator.trades | Multi-chain aggregator trades (EVM chains) |

---

## DEX vs Aggregator Relationship

```
User Swap Request (e.g., 100 USDC -> SOL via Jupiter)
        │
        ▼
┌─────────────────────────────────────────────────┐
│  Jupiter Aggregator                             │
│  (1 entry in dex_aggregator_solana.trades)      │
└─────────────────────────────────────────────────┘
        │
        ▼ Routes to best prices across DEXs
        │
┌───────┴───────┬───────────────┐
▼               ▼               ▼
Raydium         Orca            Meteora
(50 USDC)       (30 USDC)       (20 USDC)
│               │               │
└───────────────┴───────────────┘
        │
        ▼
(3 entries in dex_solana.trades)
```

*Last updated: January 2025*
*Status: Schema needs verification in Dune*
