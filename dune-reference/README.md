# Dune Reference Documentation

Local knowledge base for Claude Code to write accurate Dune Analytics queries.

## Folder Structure

```
/dune-reference/
├── CLAUDE.md              # Usage instructions and query workflow
├── README.md              # This file - overview and status
│
├── chains/                # Chain-level configs (YAML)
│   ├── solana.yaml        # Solana namespace patterns
│   └── sui.yaml           # Sui gaps documented
│
├── templates/             # SQL query templates
│   ├── volume-daily.sql
│   ├── volume-weekly.sql
│   ├── unique-users.sql
│   ├── tvl-lending.sql
│   ├── top-pairs.sql
│   └── token-transfers.sql
│
├── schemas/               # Chain-specific table schemas + protocol configs
│   ├── solana.md          # dex_solana.trades, price_hour
│   ├── sui.md             # Documents no coverage
│   ├── ethereum.md        # EVM tables
│   └── protocols/         # Protocol-specific configs (YAML)
│       ├── _template.yaml # Template for new protocols
│       ├── solana/        # Solana protocol configs
│       └── sui/           # Sui protocol configs (no coverage)
│
└── spellbooks/            # Cross-chain abstraction tables
    ├── core-tables.md     # dex.trades, tokens.transfers
    ├── lending.md         # lending.supply, lending.borrow
    ├── prices.md          # prices.usd, .day, .hour
    └── dex-aggregator.md
```

## How to Use

When writing Dune queries:

1. **Check protocol YAML first**: `schemas/protocols/{chain}/{protocol}.yaml`
2. **Check chain config**: `chains/{chain}.yaml`
3. **Use SQL templates**: `templates/{metric}.sql`
4. **Reference schemas if needed**: `schemas/{chain}.md`

See `CLAUDE.md` for detailed workflow instructions.

## Protocol Coverage

### Solana - Strong Support

| Protocol | Type | Status | Project Filter |
|----------|------|--------|----------------|
| Raydium | DEX | Verified | `'raydium'` |
| Orca | DEX | Verified | `'whirlpool'` (NOT 'orca') |
| Meteora | DEX | Verified | `'meteora'` |
| Phoenix | DEX | Verified | `'phoenix'` |
| pump.fun | DEX | Verified | `'pumpdotfun'` |
| Jupiter | Aggregator | **No Coverage** | Use API |
| Marinade | Staking | Unverified | TBD |
| Jito | MEV/Staking | Unverified | TBD |
| Kamino | Lending | Unverified | TBD |

### Sui - No Coverage

| Protocol | Type | Status | Alternative |
|----------|------|--------|-------------|
| Cetus | DEX | **No Coverage** | Cetus API |
| Bluefin | Perps | **No Coverage** | Bluefin API |
| Navi | Lending | **No Coverage** | Navi API |

### Ethereum/EVM - Strong Support

| Table | Coverage |
|-------|----------|
| dex.trades | Full |
| lending.supply/borrow | Full |
| tokens.transfers | Full |
| prices.usd | Full |

## Coverage Checklist

### Core Infrastructure
- [x] Protocol YAML template
- [x] Chain config files
- [x] SQL query templates

### Schemas
- [x] Solana chain schemas (dex_solana.trades, price_hour, bot_trades)
- [x] Ethereum chain schemas (evms.*, ethereum.*, token transfers)
- [x] SUI chain schemas (LIMITED - documented gap)

### Spellbooks
- [x] Core spellbooks (dex.trades, tokens.transfers, dex.pools)
- [x] Prices tables (prices.usd, prices.day, prices.hour, prices.latest)
- [x] Lending tables (lending.supply, lending.borrow, lending.flashloans)

### Protocols
- [x] Solana DEXs (Raydium, Orca, Meteora, Phoenix, pump.fun)
- [x] Jupiter (documented as no coverage)
- [x] Solana DeFi (Marinade, Jito, Kamino - unverified)
- [x] Sui protocols (Cetus, Bluefin, Navi - no coverage)

### Templates
- [x] Daily volume query
- [x] Weekly volume query
- [x] Unique users query
- [x] TVL/Lending query
- [x] Top pairs query
- [x] Token transfers query

## Verification Approach

Since maintenance is manual (fix when queries break):

1. Each protocol YAML has `status: verified | unverified | no-coverage`
2. Each YAML has `last_verified: "YYYY-MM-DD"`
3. When a query fails:
   - Update the relevant YAML
   - Change status to `verified` with new date
   - Document the fix in gotchas

## Adding New Protocols

1. Copy `schemas/protocols/_template.yaml`
2. Rename to `schemas/protocols/{chain}/{protocol-name}.yaml`
3. Fill in all fields
4. Test queries and update status
5. Add to this README's protocol table

## Data Sources

- All schemas extracted from Dune Analytics data explorer
- Protocol YAMLs based on spellbook documentation
- GitHub references: https://github.com/duneanalytics/spellbook

## Key Gotchas

1. **Orca = whirlpool**: Use `project = 'whirlpool'` not `'orca'`
2. **Jupiter not in Dune**: Use Jupiter API for aggregator data
3. **All lowercase**: Project names are always lowercase
4. **Sui has no coverage**: Use protocol APIs directly
5. **raydium_launchlab separate**: Include both for total Raydium volume
6. **INTERVAL syntax**: Use DAY only (e.g., `INTERVAL '84' DAY` for 12 weeks)

## Last Updated

- Structure created: 2025-01-17
- Solana protocols: 2025-01-17
- Sui protocols: 2025-01-17
