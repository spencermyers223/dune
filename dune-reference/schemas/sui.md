# SUI Chain - Dune Schema Documentation

## Current Status: RAW TABLES + COMMUNITY DATASETS ✅

SUI has raw blockchain tables and extensive community-created datasets, but **no curated spellbooks** like Ethereum/Solana. You'll need to use raw tables or community datasets for analysis.

---

## Core SUI Blockchain Tables (Raw Data)

| Table | Description |
|-------|-------------|
| `sui.transactions` | Raw transaction data |
| `sui.events` | Raw blockchain events |
| `sui.objects` | Sui objects/state |
| `sui.move_call` | Move function calls |
| `sui.checkpoints` | Sui checkpoints |
| `sui.transaction_objects` | Transaction-level object data |
| `sui.move_package` | Move package deployments |
| `sui.wrapped_object` | Wrapped object tracking |

**Note:** These are raw tables - you'll need to decode/parse them yourself, unlike the pre-built spellbooks for EVM chains.

---

## Protocol-Specific Data

### Bluefin (Perps DEX)
| Table/Dataset | Size | Creator |
|---------------|------|---------|
| `openblo... - bluefin_account_event_m...` | 1.48 GB | Community |
| `dsfasdf324234 - bluefin` | 11.09 KB | Community |
| `bluefin` (Sui object) | - | Native |

### DeepBook (Order Book DEX)
| Table/Dataset | Size | Creator |
|---------------|------|---------|
| `0xhipo - deepbook_pools_params` | 3.38 KB | Community |
| `sub_sui - deepbook_toxicity_new` | 4796 KB | Community |
| `0xhipo - deepbook_market_info` | 56 KB | Community |
| `deepbot - DeepBotRouterV1` | - | Native |

### Cetus (AMM DEX)
Limited Sui-specific tables. Most Cetus references are Ethereum-related.
- `ab_bcvs - cetusd` (token contract)

### Navi (Lending)
| Table/Dataset | Description |
|---------------|-------------|
| `navi` (Sui object) | Native protocol object |
| `navi - NAVI` | Token contract |

### Scallop (Lending)
| Table/Dataset | Description |
|---------------|-------------|
| `scallop` (Sui object) | Native protocol object |
| `scallop - ScallopChildToken` | Token contract |
| `sc_research - sui_collateral_value` | Community - collateral analytics |
| `sc_research - sui_deposit_value` | Community - deposit analytics |
| `sc_research - sui_staking` | Community - staking analytics |

---

## Community Datasets (Most Useful for Research)

### Price Data
| Dataset | Size | Notes |
|---------|------|-------|
| `dourol... - pyth_price_feed_txn_sui...` | 11.41 GB | Pyth oracle price feeds |
| `dourol_ - pyth_price_feed_updates_...` | 5.18 GB | Pyth price updates |
| `miladzm71 - suipricetable` | 19.52 KB | SUI price table |
| `index_... - sui_oracle_historical_pri...` | 3004 KB | Historical oracle prices |

### User & Wallet Analytics
| Dataset | Size | Creator |
|---------|------|---------|
| `goodheat - sui_wallet_data` | - | Wallet analytics |
| `goodheat - sui_new_user_info` | - | New user tracking |
| `eocene - sui_user` | - | User data |
| `eocene - sui_txs` | - | Transaction data |
| `pinkpunkbot - sui_txs` | - | Transaction data |

### Network Analytics
| Dataset | Creator | Notes |
|---------|---------|-------|
| `fourpillars - sui_network` | Four Pillars | Network metrics |
| `fourpillars - sui_validators` | Four Pillars | Validator data |
| `alicejessica - sui` | Community | 155 MB general dataset |

### Trading Analytics
| Dataset | Size | Notes |
|---------|------|-------|
| `sub_sui - sui_wash_trading` | 38.27 KB | Wash trading detection |
| `sub_sui - turbos_toxicity_new` | - | Turbos DEX toxicity |
| `okxweb3wallet - dex_sui_order_info` | 0.7 KB | DEX order data |

### Walrus (Decentralized Storage)
| Dataset | Notes |
|---------|-------|
| `walrus - walrus_encoded_data_volume...` | 4.35 KB |

---

## How to Query SUI Data

### sui.transactions columns (verified)
`transaction_digest`, `checkpoint`, `epoch`, `timestamp_ms`, `date`, `sender`

⚠️ **NO VOLUME/VALUE DATA**: sui.transactions does NOT contain transaction value, amount, or volume columns. For volume metrics:
- Use **DefiLlama API**: `https://api.llama.fi/v2/historicalChainTvl/Sui`
- Decode **sui.events** transfer amounts (complex, protocol-specific)
- Use **community datasets** for protocol-specific volume

### Daily Transaction Count
```sql
SELECT 
  COUNT(*) as tx_count,
  DATE_TRUNC('day', date) as day
FROM sui.transactions
WHERE date >= CURRENT_DATE - INTERVAL '7' DAY
GROUP BY DATE_TRUNC('day', date)
ORDER BY day DESC
```

### Raw Events
```sql
SELECT *
FROM sui.events
LIMIT 100
```

### Community Dataset (check exact table name in explorer)
```sql
-- Example: Price data from Pyth
SELECT *
FROM dune.dourol.pyth_price_feed_txn_sui
LIMIT 100
```

**Important:** Community table names use format `dune.creator_name.table_name`. Verify exact names in Dune's data explorer.

---

## Comparison: SUI vs Other Chains

| Feature | Ethereum | Solana | SUI |
|---------|----------|--------|-----|
| Curated spellbooks | ✅ Full | ✅ Strong | ❌ None |
| Raw blockchain tables | ✅ evms.* | ✅ Limited | ✅ sui.* |
| DEX trades abstraction | ✅ dex.trades | ✅ dex_solana.trades | ❌ Use community |
| Price tables | ✅ prices.usd | ✅ dex_solana.price_hour | ⚠️ Community only |
| Community datasets | ✅ Many | ✅ Some | ✅ 50+ datasets |

---

## Recommended Approach for SUI Research

1. **For quick metrics:** Search Dune for existing community dashboards
2. **For protocol-specific data:** Check community datasets (Bluefin, DeepBook, Scallop)
3. **For price data:** Use Pyth oracle datasets
4. **For custom analysis:** Query raw `sui.*` tables and decode yourself
5. **For real-time data:** Consider protocol APIs as supplement

---

## Alternative Data Sources (When Dune Falls Short)

For data not available in Dune:
- **DefiLlama API** - TVL and volume data (`https://api.llama.fi/v2/historicalChainTvl/Sui`)
- **Bluefin API** - Real-time perps data, trading volume
- **Cetus GraphQL** - AMM pool data, swap volume
- **Navi Protocol API** - Lending metrics
- **SuiScan / SuiVision** - Block explorers
- **Mysten Labs indexers** - Official SUI data

**Note:** Volume data is NOT available in sui.transactions. Use the APIs above for transaction value metrics.

*Last updated: January 2025*
