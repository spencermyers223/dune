# Dune Price Tables

## prices.usd

**Category:** Prices  
**Full Path:** `prices.usd`  
**Description:** Token prices in USD with minute-level granularity

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| minute | timestamp | Time of price snapshot (minute granularity) |
| blockchain | varchar | Blockchain network identifier |
| contract_address | varbinary | Token contract address |
| decimals | integer | Token decimal places |
| symbol | varchar | Token symbol (e.g., ETH, USDC) |
| price | double | USD price of token at given timestamp |

**Key Use Cases:**
- Real-time price lookups
- Computing USD values of transfers and trades
- Price history analysis at minute-level granularity
- Token valuation across multiple blockchains

---

## prices.day

**Category:** Prices  
**Full Path:** `prices.day`  
**Related Tables:** +54 by blockchain/protocol

Same columns as `prices.usd` but aggregated to daily snapshots. Use for historical price trends.

---

## prices.hour

**Category:** Prices  
**Full Path:** `prices.hour`  
**Related Tables:** +54 by blockchain/protocol

Same columns as `prices.usd` but aggregated to hourly snapshots.

---

## prices.latest

**Category:** Prices  
**Full Path:** `prices.latest`  
**Related Tables:** +54 by blockchain/protocol

Most recent price snapshot for any token. No timestamp filtering needed.

---

## Common Join Pattern

```sql
-- Join trades with prices
SELECT 
  t.blockchain,
  t.token_bought_symbol,
  t.token_bought_amount,
  p.price,
  t.token_bought_amount * p.price as usd_value
FROM dex.trades t
LEFT JOIN prices.usd p 
  ON t.blockchain = p.blockchain
  AND t.token_bought_address = p.contract_address
  AND date_trunc('minute', t.block_time) = p.minute
```
