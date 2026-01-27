# CLAUDE.md - Dune Reference Documentation

## Purpose

This folder contains schema documentation for Dune Analytics, enabling Claude to write accurate SQL queries for blockchain data analysis. It serves Nomad Research's need for on-chain metrics in investment research, Discord bot data feeds, and X/Twitter content.

## How to Use This Reference

When asked to write a Dune query, follow this workflow:

### Step 1: Check Protocol YAML (Most Important)
```
schemas/protocols/{chain}/{protocol}.yaml
```
- Get the correct table name
- Get exact project filter value (always lowercase)
- Read gotchas to avoid common mistakes
- Use provided common_queries as starting point

### Step 2: Check Chain Config
```
chains/{chain}.yaml
```
- Understand namespace patterns (e.g., `dex_solana` vs `dex.trades`)
- Know chain-specific column names
- See known project values

### Step 3: Use SQL Templates
```
templates/{metric}.sql
```
- Start with template for the metric type
- Adapt with protocol-specific values from Step 1

### Step 4: Reference Schema Details (If Needed)
```
schemas/{chain}.md
```
- For detailed column information
- For complex joins
- For raw table structures

## Folder Structure

```
/dune-reference/
├── CLAUDE.md              # This file - usage instructions
├── README.md              # Coverage checklist and overview
│
├── chains/                # Chain-level configs
│   ├── solana.yaml        # Solana patterns, known projects
│   └── sui.yaml           # Documents lack of coverage
│
├── templates/             # SQL query templates
│   ├── volume-daily.sql
│   ├── volume-weekly.sql
│   ├── unique-users.sql
│   ├── tvl-lending.sql
│   ├── top-pairs.sql
│   └── token-transfers.sql
│
├── schemas/               # Detailed table schemas + protocol configs
│   ├── solana.md          # dex_solana.trades columns
│   ├── sui.md             # Documents no coverage
│   ├── ethereum.md        # EVM tables
│   └── protocols/         # Protocol-specific configs (CHECK FIRST)
│       ├── _template.yaml # Template for adding new protocols
│       ├── solana/        # raydium, orca, meteora, phoenix, etc.
│       └── sui/           # cetus, bluefin, navi (no coverage)
│
└── spellbooks/            # Cross-chain abstraction tables
    ├── core-tables.md     # dex.trades, tokens.transfers
    ├── lending.md         # lending.supply, lending.borrow
    ├── prices.md          # prices.usd, .day, .hour
    └── dex-aggregator.md
```

## Quick Reference: Common Gotchas

### Dune SQL Syntax
- **INTERVAL uses DAY only**: Use `INTERVAL '84' DAY` not `INTERVAL '12' WEEK`
- **Convert weeks to days**: 12 weeks = 84 days, 8 weeks = 56 days, 4 weeks = 28 days

### Solana DEX Queries
- **All project names are lowercase**: `'raydium'` not `'Raydium'`
- **Orca uses 'whirlpool'**: `WHERE project = 'whirlpool'` NOT `'orca'`
- **Jupiter is NOT in Dune**: Use their API instead
- **User column is `trader_id`**: Not `user` or `trader`
- **raydium_launchlab is separate**: Include both for total Raydium volume

### Sui Queries
- **SUI HAS NO DUNE COVERAGE**: Do not attempt queries
- **Use protocol APIs**: Cetus, Bluefin, Navi all have APIs

### EVM Queries
- **Add blockchain filter**: `WHERE blockchain = 'ethereum'`
- **User column is `taker` or `tx_from`**: Depends on table

## Example Query Workflow

**User asks:** "Write a query for Raydium daily volume"

**Step 1:** Check `schemas/protocols/solana/raydium.yaml`
- Table: `dex_solana.trades`
- Filter: `project = 'raydium'`
- Note: raydium_launchlab is separate

**Step 2:** Check `chains/solana.yaml`
- No blockchain filter needed
- Confirmed project is lowercase

**Step 3:** Use `templates/volume-daily.sql` as base

**Result:**
```sql
SELECT
    block_date,
    SUM(amount_usd) AS daily_volume,
    COUNT(*) AS trade_count,
    COUNT(DISTINCT trader_id) AS unique_traders
FROM dex_solana.trades
WHERE project = 'raydium'
    AND block_date >= CURRENT_DATE - INTERVAL '30' DAY
GROUP BY block_date
ORDER BY block_date DESC
```

## Verification Status

Each protocol YAML has a `status` field:
- `verified`: Queries confirmed working
- `unverified`: Structure documented but not confirmed
- `no-coverage`: Protocol NOT in Dune

When a query fails:
1. Update the relevant YAML with corrections
2. Change status to `verified` with new `last_verified` date
3. Add the issue to `gotchas`

## Context: Nomad Research

This reference supports:
- **Investment Research**: Protocol metrics for thesis development
- **Discord Bots**: Automated data feeds for community channels
- **X Content**: Data-driven posts with specific metrics
- **Dashboards**: Visual analytics for the #dune-dashboards channel

The goal is rapid, accurate query generation without manual schema lookup.

## Adding New Protocols

1. Copy `schemas/protocols/_template.yaml`
2. Rename to `schemas/protocols/{chain}/{protocol}.yaml`
3. Fill in table names, filter values, and gotchas
4. Add common queries
5. Set status to `unverified` until tested
6. Update README.md protocol list

## Key Patterns

### Querying by Protocol (Solana)
```sql
SELECT * FROM dex_solana.trades WHERE project = 'raydium'
```

### Querying by Protocol (EVM)
```sql
SELECT * FROM dex.trades WHERE project = 'uniswap' AND blockchain = 'ethereum'
```

### Price Joins
```sql
LEFT JOIN prices.usd p
  ON t.blockchain = p.blockchain
  AND t.token_address = p.contract_address
  AND date_trunc('minute', t.block_time) = p.minute
```

## Known Limitations

1. **SUI has no Dune coverage** - Use alternative APIs
2. **Jupiter (Solana aggregator) not in Dune** - Trades appear under underlying DEXs
3. **Project names are lowercase** - Use `'raydium'` not `'Raydium'`
4. **Orca = whirlpool** - The project value is `'whirlpool'` not `'orca'`
5. **Some lending protocols not in spellbook** - Solana lending may need APIs
6. **INTERVAL syntax** - Dune only supports DAY, not WEEK or HOUR in intervals
