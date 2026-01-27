# Dune Lending Tables

## lending.supply

**Category:** Lending  
**Full Path:** `lending.supply`  
**Description:** All lending supply (deposit) transactions across lending protocols

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| blockchain | string | Blockchain network |
| project | string | Lending protocol name (Aave, Compound, etc.) |
| version | string | Protocol version (v2, v3, etc.) |
| transaction_type | string | Type of supply action (Deposit, Mint, Supply) |
| symbol | string | Token symbol being supplied |
| token_address | binary | Token contract address |
| depositor | binary | Address making the deposit |
| on_behalf_of | binary | Beneficiary address (if different) |
| withdrawn_to | binary | Address receiving withdrawn tokens |
| liquidator | binary | Address performing liquidation |
| amount | double | Amount supplied (normalized) |
| amount_usd | double | USD value at transaction time |
| block_month | timestamp | Month of transaction (for partitioning) |
| block_time | timestamp | Exact timestamp |
| block_number | long | Block number |
| project_contract_address | binary | Main protocol contract address |
| tx_hash | binary | Transaction hash |
| evt_index | integer | Event log index |

**Supported Protocols:**
- Aave (v2, v3 across Ethereum, Polygon, Optimism, Arbitrum, Base, Avalanche, Fantom, Gnosis, Scroll, zkSync, Linea, Sonic)
- Compound (multiple chains)
- Celo, and others

**GitHub:** https://github.com/duneanalytics/spellbook/tree/main/dbt_subprojects/hourly_spellbook/models/_sector/lending/supply/lending_supply.sql

---

## lending.borrow

**Category:** Lending  
**Full Path:** `lending.borrow`  
**Description:** All lending borrow (loan initiation) transactions across lending protocols

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| blockchain | string | Blockchain network |
| project | string | Lending protocol name |
| version | string | Protocol version |
| transaction_type | string | Type of borrow action (Borrow, Flash Loan) |
| loan_type | string | Type of loan (Fixed, Variable) |
| symbol | string | Token symbol being borrowed |
| token_address | binary | Token contract address |
| borrower | binary | Address receiving borrowed tokens |
| on_behalf_of | binary | Beneficiary address (if different) |
| repayer | binary | Address that repaid the loan |
| liquidator | binary | Address performing liquidation |
| amount | double | Amount borrowed (normalized) |
| amount_usd | double | USD value at transaction time |
| block_month | timestamp | Month of transaction |
| block_time | timestamp | Exact timestamp |
| block_number | long | Block number |
| project_contract_address | binary | Main protocol contract address |
| tx_hash | binary | Transaction hash |
| evt_index | integer | Event log index |

**Key Metrics:**
- Total borrows by protocol and chain
- User borrow history and debt tracking
- Loan type distribution (fixed vs variable)
- Flash loan activity
- Liquidation events
- Borrow/Supply ratio analysis

---

## Other Lending Tables

| Table | Purpose |
|-------|---------|
| lending.flashloans | Flash loan events (+13 chains) |
| lending.info | Protocol metadata (+10 protocols) |
| lending.supply_scaled | Supply with scaled decimals (+11 chains) |

---

## Example Queries

**Weekly supply by protocol:**
```sql
SELECT 
  project,
  blockchain,
  SUM(amount_usd) as total_supply_usd
FROM lending.supply
WHERE block_time >= CURRENT_DATE - INTERVAL '7' DAY
GROUP BY project, blockchain
ORDER BY total_supply_usd DESC
```

**Protocol TVL (supply - borrows):**
```sql
WITH supply AS (
  SELECT project, SUM(amount_usd) as total_supply
  FROM lending.supply
  WHERE block_time >= CURRENT_DATE - INTERVAL '30' DAY
  GROUP BY project
),
borrows AS (
  SELECT project, SUM(amount_usd) as total_borrow
  FROM lending.borrow
  WHERE block_time >= CURRENT_DATE - INTERVAL '30' DAY
  GROUP BY project
)
SELECT 
  s.project,
  s.total_supply,
  b.total_borrow,
  s.total_supply - COALESCE(b.total_borrow, 0) as net_tvl
FROM supply s
LEFT JOIN borrows b ON s.project = b.project
ORDER BY net_tvl DESC
```
