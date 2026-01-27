# Ethereum Chain - Dune Schema Documentation

## Current Status: STRONG SUPPORT ✅

Ethereum has the deepest coverage in Dune. Data is split between:
- `ethereum.*` - Ethereum-specific metadata
- `evms.*` - Raw blockchain tables (works for all EVM chains including Ethereum)
- Cross-chain spellbooks (`dex.trades`, `lending.supply`) - filter with `WHERE blockchain = 'ethereum'`

---

## Ethereum-Specific Tables

### ethereum.contracts

**Full Path:** `ethereum.contracts`  
**Category:** Contract Metadata  
**Description:** Ethereum contract information and classification  
**Related Tables:** +52 across EVM chains

---

### ethereum.network_upgrades

**Full Path:** `ethereum.network_upgrades`  
**Category:** Protocol History  
**Description:** Ethereum hardforks and upgrades (Istanbul, Berlin, London, Shanghai, Dencun)

---

## Raw Blockchain Tables (evms namespace)

These tables cover ALL EVM chains. Filter with `WHERE blockchain = 'ethereum'` for Ethereum-only data.

### evms.transactions

**Full Path:** `evms.transactions`  
**Description:** All transactions on EVM chains

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| blockchain | string | Chain identifier |
| tx_hash | varbinary | Transaction hash |
| from_address | varbinary | Sender |
| to_address | varbinary | Recipient |
| value | uint256 | Transaction value (wei) |
| gas_price | uint256 | Gas price |
| gas_limit | uint256 | Gas limit |
| gas_used | uint256 | Actual gas used |
| block_number | bigint | Block number |
| block_time | timestamp | Block timestamp |
| nonce | bigint | Transaction nonce |
| type | string | Transaction type |

---

### evms.logs

**Full Path:** `evms.logs`  
**Description:** All event logs emitted by smart contracts

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| blockchain | string | Chain identifier |
| contract_address | varbinary | Emitting contract |
| topic0 | varbinary | Event signature hash |
| topic1 | varbinary | Indexed parameter 1 |
| topic2 | varbinary | Indexed parameter 2 |
| topic3 | varbinary | Indexed parameter 3 |
| data | varbinary | Non-indexed event data |
| block_number | bigint | Block number |
| block_time | timestamp | Block timestamp |
| tx_hash | varbinary | Transaction hash |
| log_index | integer | Log index in block |

---

### evms.logs_decoded

**Full Path:** `evms.logs_decoded`  
**Description:** Same as evms.logs but with decoded event names and parameters  
**Advantage:** Human-readable function names and parsed parameters

---

### evms.traces

**Full Path:** `evms.traces`  
**Description:** Internal transaction call traces

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| blockchain | string | Chain identifier |
| tx_hash | varbinary | Transaction hash |
| tx_index | integer | Transaction index |
| from_address | varbinary | Caller |
| to_address | varbinary | Callee |
| value | uint256 | Value transferred |
| gas_used | uint256 | Gas consumed |
| function_name | string | Called function |
| function_selector | varbinary | 4-byte selector |
| trace_address | array | Hierarchical call position |
| type | string | Call type (call, create, suicide) |
| success | boolean | Execution success |

---

### evms.traces_decoded

**Full Path:** `evms.traces_decoded`  
**Description:** Same as evms.traces but with decoded function calls  
**Advantage:** Parsed function signatures and input parameters

---

### evms.blocks

**Full Path:** `evms.blocks`  
**Description:** Block-level data

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| blockchain | string | Chain identifier |
| block_number | bigint | Block number |
| block_hash | varbinary | Block hash |
| block_time | timestamp | Block timestamp |
| miner_address | varbinary | Block producer |
| gas_limit | uint256 | Block gas limit |
| gas_used | uint256 | Total gas used |
| transaction_count | integer | Transactions in block |
| difficulty | uint256 | Mining difficulty |
| base_fee | uint256 | EIP-1559 base fee |

---

### evms.creation_traces

**Full Path:** `evms.creation_traces`  
**Description:** Smart contract deployment records

---

## Token Transfer Tables

### evms.erc20_transfers

**Full Path:** `evms.erc20_transfers`  
**Description:** All ERC-20 token transfers

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| blockchain | string | Chain identifier |
| contract_address | varbinary | Token contract |
| from_address | varbinary | Sender |
| to_address | varbinary | Recipient |
| value | uint256 | Raw amount |
| amount | double | Normalized amount |
| tx_hash | varbinary | Transaction hash |
| block_time | timestamp | Block timestamp |

---

### evms.erc20_approvals

**Full Path:** `evms.erc20_approvals`  
**Description:** ERC-20 approval events

---

### evms.erc721_transfers

**Full Path:** `evms.erc721_transfers`  
**Description:** NFT (ERC-721) transfers

---

### evms.erc1155_transferssingle / evms.erc1155_transfersbatch

**Full Path:** `evms.erc1155_transferssingle`, `evms.erc1155_transfersbatch`  
**Description:** Multi-token (ERC-1155) transfers

---

## Protocol-Specific Data

**Important:** Dune does NOT have separate Uniswap, Aave, or Lido tables for Ethereum. Instead, use the cross-chain spellbooks:

| Protocol | Table | Filter |
|----------|-------|--------|
| Uniswap | `dex.trades` | `WHERE project = 'uniswap' AND blockchain = 'ethereum'` |
| Aave | `lending.supply`, `lending.borrow` | `WHERE project = 'aave' AND blockchain = 'ethereum'` |
| Lido | `staking.*` | Check staking spellbook |

---

## Example Queries

**Recent Ethereum transactions:**
```sql
SELECT 
  tx_hash,
  from_address,
  to_address,
  value / 1e18 as eth_value,
  gas_used * gas_price / 1e18 as fee_eth,
  block_time
FROM evms.transactions
WHERE blockchain = 'ethereum'
  AND block_time >= CURRENT_DATE - INTERVAL '1' DAY
LIMIT 100
```

**ERC-20 transfer volume by token:**
```sql
SELECT 
  contract_address,
  COUNT(*) as transfer_count,
  SUM(amount) as total_volume
FROM evms.erc20_transfers
WHERE blockchain = 'ethereum'
  AND block_time >= CURRENT_DATE - INTERVAL '1' DAY
GROUP BY contract_address
ORDER BY transfer_count DESC
LIMIT 20
```

**Uniswap V3 volume on Ethereum:**
```sql
SELECT 
  block_date,
  SUM(amount_usd) as daily_volume,
  COUNT(*) as trades
FROM dex.trades
WHERE blockchain = 'ethereum'
  AND project = 'uniswap'
  AND version = '3'
  AND block_date >= CURRENT_DATE - INTERVAL '30' DAY
GROUP BY block_date
ORDER BY block_date DESC
```

**Decoded contract events:**
```sql
SELECT 
  function_name,
  COUNT(*) as event_count,
  block_time
FROM evms.logs_decoded
WHERE blockchain = 'ethereum'
  AND contract_address = 0x... -- your contract
  AND block_time >= CURRENT_DATE - INTERVAL '7' DAY
GROUP BY function_name, block_time
ORDER BY event_count DESC
```

---

## When to Use Raw vs Spellbook Tables

| Use Case | Table Type | Example |
|----------|------------|---------|
| Uniswap volume analysis | Spellbook | `dex.trades` |
| All events from a contract | Raw | `evms.logs_decoded` |
| Complete transaction execution | Raw | `evms.traces_decoded` |
| ERC-20 transfers only | Token-specific | `evms.erc20_transfers` |
| Custom protocol analysis | Raw | `evms.logs` + manual decoding |

*Last updated: January 2025*
