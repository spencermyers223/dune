# SUI Chain - Dune Schema Documentation

## Current Status: RAW TABLES + COMMUNITY DATASETS ✅

SUI has raw blockchain tables and community datasets, but **no curated spellbooks**. Query protocol data via `sui.events` filtered by package ID.

---

## Quick Reference

### Key Tables
| Table | Use For |
|-------|---------|
| `sui.transactions` | DAU, tx counts, gas analysis |
| `sui.events` | Protocol activity (filter by `package`) |
| `sui.objects` | Token balances, NFTs, state |

### Protocol Package IDs
| Protocol | Package ID | Category |
|----------|------------|----------|
| DeepBook | `0xdee9` | Order Book DEX |
| Cetus | `0x1eabed72c53feb3805120a081dc15963c204dc8d091542592abaf7a35689b2fb` | AMM DEX |
| NAVI | `0xee0041239b89564ce870a7dec5ddc5d114367ab94a1137e90aa0633cb76518e0` | Lending |
| Scallop | `0xb03fa00e2d9f17d78a9d48bd94d8852abec68c19d55e819096b1e062e69bfad1` | Lending |

---

## Core SUI Blockchain Tables

### sui.transactions
Main transaction table - use for DAU, tx counts, gas analysis.

| Column | Type | Description |
|--------|------|-------------|
| `transaction_digest` | string | Unique hash identifier |
| `checkpoint` | decimal | Checkpoint sequence number |
| `epoch` | decimal | Epoch number |
| `timestamp_ms` | decimal | Unix timestamp in milliseconds |
| `date` | date | Date partition (use for filtering) |
| `sender` | binary | Address that initiated |
| `transaction_kind` | string | "ProgrammableTransaction", "ChangeEpoch", etc. |
| `execution_success` | boolean | Whether tx succeeded |
| `packages` | string | Packages involved |
| `move_calls` | decimal | Number of Move calls |
| `total_gas_cost` | bigint | Total gas spent |
| `created` | decimal | Objects created count |
| `mutated` | decimal | Objects mutated count |
| `deleted` | decimal | Objects deleted count |

⚠️ **NO VOLUME/VALUE DATA** - Use `sui.events` for trade data.

### sui.events
Contract events - filter by package for protocol-specific data.

| Column | Type | Description |
|--------|------|-------------|
| `transaction_digest` | string | Hash of tx that emitted event |
| `event_index` | decimal | Index within transaction |
| `checkpoint` | decimal | Checkpoint sequence number |
| `epoch` | decimal | Epoch number |
| `timestamp_ms` | decimal | Unix timestamp in milliseconds |
| `date` | date | Date partition |
| `sender` | binary | Sender address |
| `package` | binary | **Package ID that emitted** (use FROM_HEX) |
| `module` | string | Module name |
| `event_type` | string | Type of event (e.g., "SwapEvent") |
| `event_json` | string | JSON representation of event data |
| `bcs` | string | Binary Canonical Serialization |

### sui.objects
Object state - coins, NFTs, shared objects.

| Column | Type | Description |
|--------|------|-------------|
| `object_id` | binary | Unique object ID |
| `version` | decimal | Version number |
| `type_` | string | Object type (e.g., "0x2::coin::Coin<0x2::sui::SUI>") |
| `checkpoint` | decimal | Checkpoint sequence number |
| `timestamp_ms` | decimal | Unix timestamp |
| `date` | date | Date partition |
| `owner_type` | string | "AddressOwner", "ObjectOwner", "Shared", "Immutable" |
| `owner_address` | binary | Owner address |
| `object_status` | string | "Created", "Mutated", "Deleted" |
| `coin_type` | string | Type of coin (if coin object) |
| `coin_balance` | decimal | Balance (if coin object) |
| `object_json` | string | JSON representation |

---

## Protocol Package IDs (Verified)

### DEX / Trading
| Protocol | Package ID | Notes |
|----------|------------|-------|
| **DeepBook v3** | `0x000000000000000000000000000000000000000000000000000000000000dee9` | Native CLOB |
| **Cetus CLMM** | `0x1eabed72c53feb3805120a081dc15963c204dc8d091542592abaf7a35689b2fb` | Main pool contract |
| **Cetus Config** | `0x95b8d278b876cae22206131fb9724f701c9444515813042f54f0a426c9a3bc2f` | Config package |

### Lending
| Protocol | Package ID | Notes |
|----------|------------|-------|
| **NAVI Protocol** | `0xee0041239b89564ce870a7dec5ddc5d114367ab94a1137e90aa0633cb76518e0` | Latest protocol package |
| **NAVI Storage** | `0xbb4e2f4b6205c2e2a2db47aeb4f830796ec7c005f88537ee775986639bc442fe` | Storage object |
| **Scallop Core** | `0xb03fa00e2d9f17d78a9d48bd94d8852abec68c19d55e819096b1e062e69bfad1` | Protocol package |
| **Scallop Market** | `0xa7f41efe3b551c20ad6d6cea6ccd0fd68d2e2eaaacdca5e62d956209f6a51312` | Market object |

---

## Token Addresses

| Token | Coin Type |
|-------|-----------|
| SUI | `0x2::sui::SUI` |
| DEEP | `0xdeeb7a4662eec9f2f3def03fb937a663dddaa2e215b8078a284d026b7946c270::deep::DEEP` |
| CETUS | `0x06864a6f921804860930db6ddbe2e16acdf8504495ea7481637a1c8b9a8fe54b::cetus::CETUS` |
| NAVX | `0xa99b8952d4f7d947ea77fe0ecdcc9e5fc0bcab2841d6e2a5aa00c3044e5544b5::navx::NAVX` |
| SCA | `0x7016aae72cfc67f2fadf55769c0a7dd54291a583b63051a5ed71081cce836ac6::sca::SCA` |
| BUCK | `0xce7ff77a83ea0cb6fd39bd8748e2ec89a3f41e8efdc3f4eb123e0ca37b184db2::buck::BUCK` |
| WAL (Walrus) | `0x356a26eb9e012a68958082340d4c4116e7f55615cf27affcff209cf0ae544f59::wal::WAL` |
| IKA | `0x7262fb2f7a3a14c888c438a3cd9b912469a58cf60f367352c46584262e8299aa::ika::IKA` |
| SEND (Suilend) | `0xb45fcfcc2cc07ce0702cc2d229621e046c906ef14d9b25e8e4d25f6e8763fef7::send::SEND` |
| TURBOS | `0x5d1f47ea69bb0de31c313d7acf89b890dbb8991ea8e03c6c355171f84bb1ba4a::turbos::TURBOS` |
| haSUI | `0xbde4ba4c2e274a60ce15c1cfff9e5c42e41654ac8b6d906a57efa4bd3c29f47d::hasui::HASUI` |
| vSUI | `0x549e8b69270defbfafd4f94e17ec44cdbdd99820b33bda2278dea3b9a32d3f55::cert::CERT` |
| USDC (Native) | `0xdba34672e30cb065b1f93e3ab55318768fd6fef66c15942c9f7cb846e2f900e7::usdc::USDC` |
| USDT | `0xc060006111016b8a020ad5b33834984a437aaa7d3c74c18e09a95d48aceab08c::coin::COIN` |

---

## Query Examples

### Cetus Swap Activity
```sql
SELECT 
  DATE_TRUNC('day', FROM_UNIXTIME(timestamp_ms/1000)) as date,
  event_type,
  COUNT(*) as swap_count
FROM sui.events  
WHERE package = FROM_HEX('1eabed72c53feb3805120a081dc15963c204dc8d091542592abaf7a35689b2fb')
  AND event_type LIKE '%Swap%'
  AND date >= CURRENT_DATE - INTERVAL '7' DAY
GROUP BY 1, 2
ORDER BY 1 DESC
```

### DeepBook Order Activity
```sql
SELECT 
  DATE_TRUNC('day', FROM_UNIXTIME(timestamp_ms/1000)) as date,
  module,
  event_type,
  COUNT(*) as events
FROM sui.events
WHERE package = FROM_HEX('000000000000000000000000000000000000000000000000000000000000dee9')
  AND date >= CURRENT_DATE - INTERVAL '7' DAY
GROUP BY 1, 2, 3
ORDER BY 1 DESC, 4 DESC
```

### NAVI Lending Activity
```sql
SELECT 
  DATE_TRUNC('day', FROM_UNIXTIME(timestamp_ms/1000)) as date,
  module,
  event_type,
  COUNT(*) as events
FROM sui.events
WHERE package = FROM_HEX('ee0041239b89564ce870a7dec5ddc5d114367ab94a1137e90aa0633cb76518e0')
  AND date >= CURRENT_DATE - INTERVAL '7' DAY
GROUP BY 1, 2, 3
ORDER BY 1 DESC
```

### Daily Active Users
```sql
SELECT
  DATE_TRUNC('day', date) AS day,
  COUNT(*) AS tx_count,
  COUNT(DISTINCT sender) AS unique_users
FROM sui.transactions
WHERE date >= CURRENT_DATE - INTERVAL '30' DAY
GROUP BY 1
ORDER BY day DESC
```

### Token Holder Distribution
```sql
SELECT 
  coin_type,
  SUM(coin_balance) as total_balance,
  COUNT(*) as holder_count
FROM sui.objects
WHERE coin_type IS NOT NULL
  AND object_status = 'Created'
  AND owner_type = 'AddressOwner'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 20
```

---

## Important Notes

1. **Package IDs must use `FROM_HEX()`** for binary comparison
2. **Timestamps are in milliseconds** - use `FROM_UNIXTIME(timestamp_ms/1000)`
3. **No curated spellbooks** - no `dex_sui.trades` or `prices.usd`
4. **Filter by date first** - tables are partitioned by date

---

## Community Datasets

### Price Data
| Dataset | Notes |
|---------|-------|
| `dune.dourol.pyth_price_feed_txn_sui` | Pyth oracle price feeds (11.41 GB) |
| `dune.miladzm71.suipricetable` | SUI price table |

### Protocol Analytics
| Dataset | Notes |
|---------|-------|
| `dune.sc_research.sui_collateral_value` | Scallop collateral |
| `dune.sc_research.sui_deposit_value` | Scallop deposits |
| `dune.0xhipo.deepbook_market_info` | DeepBook market data |

---

## Comparison: SUI vs Solana

| Feature | Solana | SUI |
|---------|--------|-----|
| DEX trades | ✅ `dex_solana.trades` | ❌ Query `sui.events` |
| Price tables | ✅ `dex_solana.price_hour` | ⚠️ Community only |
| Protocol filter | `project = 'jupiter'` | `package = FROM_HEX('...')` |
| Raw tables | `solana.transactions` | `sui.transactions` |

---

## Alternative Data Sources

- **DefiLlama API**: `https://api.llama.fi/v2/historicalChainTvl/Sui`
- **Cetus API**: `https://api-sui.cetus.zone`
- **NAVI API**: `https://app.naviprotocol.io/api`
- **Scallop API**: `https://sui.apis.scallop.io`

*Last updated: February 2026*
