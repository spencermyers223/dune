# Solana Chain - Dune Schema Documentation

## Current Status: STRONG SUPPORT ✅

Solana has dedicated spellbook tables in the `dex_solana` namespace with coverage for major protocols.

---

## dex_solana.trades

**Full Path:** `dex_solana.trades`  
**Category:** Solana DEX Trading  
**Description:** All DEX trades on Solana across protocols  
**Supported Protocols:** raydium, orca, whirlpool, meteora, phoenix, pumpdotfun, and others

**Important Notes:**
- All project names are **lowercase** in queries
- **Jupiter is NOT in Dune** - Jupiter is an aggregator that routes through other DEXs. Jupiter trades appear under the underlying DEX (raydium, orca, etc.). There is no `jupiter_solana` or `dex_aggregator` table with Solana data. For Jupiter-specific volume, use their API directly.
- For Solana DEX volume, query `dex_solana.trades` and aggregate across all projects

**Known project values (as of Jan 2025):**
`aquifer`, `goonfi`, `humidifi`, `meteora`, `obric`, `pancakeswap`, `phoenix`, `pumpdotfun`, `pumpswap`, `raydium`, `raydium_launchlab`, `solfi`, `stabble`, `tessera`, `whirlpool`, `zerofi`

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| blockchain | string | Always "solana" |
| project | string | DEX protocol name (Raydium, Jupiter, Orca) |
| version | integer | Protocol version |
| version_name | string | Human-readable version name |
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
| fee_tier | double | Fee percentage |
| fee_usd | double | Fee amount in USD |
| token_bought_mint_address | string | Mint address of token received |
| token_sold_mint_address | string | Mint address of token sent |
| token_bought_vault | string | Token account for received token |
| token_sold_vault | string | Token account for sent token |
| project_program_id | string | DEX program ID |
| project_main_id | string | Main account ID for DEX |
| trader_id | string | User wallet address |
| tx_id | string | Transaction signature |
| outer_instruction_index | integer | Outer instruction index |
| inner_instruction_index | integer | Inner instruction index |
| tx_index | integer | Position in transaction |

**GitHub:** https://github.com/duneanalytics/spellbook/tree/main/dbt_subprojects/solana/models/_sector/dex/dex_solana_trades.sql

---

## dex_solana.price_hour

**Full Path:** `dex_solana.price_hour`  
**Category:** Solana DEX Pricing  
**Description:** Hourly token prices from Orca liquidity pools

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| contract_address | string | Token mint address |
| hour | timestamp | Hourly timestamp |
| symbol | string | Token symbol |
| decimals | long | Token decimal places |
| blockchain | string | "solana" |
| price | double | USD price for that hour |
| block_month | date | Month of price data |

---

## dex_solana.bot_trades

**Full Path:** `dex_solana.bot_trades`  
**Category:** Solana Bot Trading Activity  
**Description:** Bot-identified trades including MEV and arbitrage

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| block_time | timestamp(3) | Millisecond precision timestamp |
| block_date | date | Date |
| block_month | date | Month |
| bot | varchar | Bot identifier/address |
| blockchain | varchar | "solana" |
| amount_usd | double | Trade value in USD |
| type | varchar | Bot activity type (MEV, arbitrage) |
| token_bought_amount | double | Amount received |
| token_bought_symbol | varchar | Symbol received |
| token_bought_address | varchar | Mint address received |
| token_sold_amount | double | Amount sent |
| token_sold_symbol | varchar | Symbol sent |
| token_sold_address | varchar | Mint address sent |
| fee_usd | double | Fee in USD |
| fee_token_amount | double | Fee in token amount |
| fee_token_symbol | varchar | Fee token symbol |
| fee_token_address | varchar | Fee token mint |
| project | varchar | DEX protocol |
| version | integer | Protocol version |
| token_pair | varchar | Token pair |
| project_contract_address | varchar | DEX program address |
| user | varchar | Bot operator address |
| tx_id | varchar | Transaction signature |
| tx_index | integer | Transaction instruction index |
| outer_instruction_index | integer | Outer instruction index |
| inner_instruction_index | integer | Inner instruction index |
| is_last_trade_in_transaction | boolean | Final trade flag |

---

## Example Queries

**Weekly volume by DEX:**
```sql
SELECT 
  project,
  SUM(amount_usd) as total_volume,
  COUNT(*) as trade_count,
  AVG(amount_usd) as avg_trade_size
FROM dex_solana.trades
WHERE block_date >= CURRENT_DATE - INTERVAL '7' DAY
GROUP BY project
ORDER BY total_volume DESC
```

**Raydium daily volume:**
```sql
SELECT 
  block_date,
  SUM(amount_usd) as daily_volume,
  COUNT(DISTINCT trader_id) as unique_traders
FROM dex_solana.trades
WHERE project = 'raydium'
  AND block_date >= CURRENT_DATE - INTERVAL '30' DAY
GROUP BY block_date
ORDER BY block_date DESC
```

**Bot activity monitoring:**
```sql
SELECT 
  block_date,
  type,
  COUNT(*) as bot_trades,
  SUM(amount_usd) as bot_volume,
  COUNT(DISTINCT bot) as unique_bots
FROM dex_solana.bot_trades
WHERE block_date >= CURRENT_DATE - INTERVAL '7' DAY
GROUP BY block_date, type
ORDER BY block_date DESC
```

**Price lookup for trades:**
```sql
SELECT 
  t.block_date,
  t.token_bought_symbol,
  t.token_bought_amount,
  p.price as hourly_price,
  t.amount_usd
FROM dex_solana.trades t
LEFT JOIN dex_solana.price_hour p 
  ON date_trunc('hour', t.block_time) = p.hour
  AND t.token_bought_mint_address = p.contract_address
WHERE t.project = 'Raydium'
  AND t.block_date = CURRENT_DATE - INTERVAL '1' DAY
LIMIT 100
```

---

## Solana vs SUI Coverage Comparison

| Feature | Solana | SUI |
|---------|--------|-----|
| DEX Trade Tables | ✅ dex_solana.trades | ❌ None |
| Price Data | ✅ dex_solana.price_hour | ❌ None |
| Bot Detection | ✅ dex_solana.bot_trades | ❌ None |
| Protocols | Raydium, Jupiter, Orca | Not in Dune |

*Last updated: January 2025*
