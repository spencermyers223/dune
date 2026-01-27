# Dune Core Spellbook Tables

## tokens.transfers

**Category:** Asset Tracking  
**Full Path:** `tokens.transfers`  
**Description:** Transfers of all kinds of fungible tokens across all EVM-compatible networks on Dune. For a unified view including non-EVM chains, use `tokens_multichain.transfers` instead.

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| unique_key | varchar | Unique identifier for the transfer |
| blockchain | varchar | Blockchain network identifier |
| block_month | date | Month of block |
| block_date | date | Date of block |
| block_time | timestamp(3) with time zone | Exact time of block |
| block_number | bigint | Block number |
| tx_hash | varbinary | Transaction hash |
| evt_index | bigint | Event index within transaction |
| trace_address | array(bigint) | Trace address path |
| token_standard | varchar | Token standard (ERC20, ERC721, etc.) |
| tx_from | varbinary | Transaction sender address |
| tx_to | varbinary | Transaction recipient address |
| tx_index | bigint | Transaction index in block |
| from | varbinary | Token transfer sender address |
| to | varbinary | Token transfer recipient address |
| contract_address | varbinary | Token contract address |
| symbol | varchar | Token symbol |
| amount_raw | uint256 | Raw token amount (with decimals) |
| amount | double | Normalized token amount |
| price_usd | double | USD price at time of transfer |
| amount_usd | double | USD value of transfer |

**GitHub:** https://github.com/duneanalytics/spellbook/tree/main/dbt_subprojects/tokens/models/transfers_and_balances/tokens_transfers.sql

---

## dex.trades

**Category:** Trading / DEX  
**Full Path:** `dex.trades`  
**Description:** Detailed data on trades executed via decentralized exchanges (DEXs). Contains one or many trades per transaction.

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| blockchain | string | Blockchain network |
| project | string | DEX project name |
| version | string | Contract version |
| block_month | date | Month of block |
| block_date | date | Date of block |
| block_time | timestamp | Time of block |
| block_number | long | Block number |
| token_bought_symbol | string | Symbol of token received |
| token_sold_symbol | string | Symbol of token sent |
| token_pair | string | Token pair (e.g., ETH/USDC) |
| token_bought_amount | double | Amount of token received |
| token_sold_amount | double | Amount of token sent |
| token_bought_amount_raw | uint256 | Raw amount of token received |
| token_sold_amount_raw | uint256 | Raw amount of token sent |
| amount_usd | double | Trade value in USD |
| token_bought_address | binary | Contract address of token received |
| token_sold_address | binary | Contract address of token sent |
| taker | binary | Address executing the trade |
| maker | binary | Address providing liquidity |
| project_contract_address | binary | DEX contract address |
| tx_hash | binary | Transaction hash |
| tx_from | binary | Transaction sender |
| tx_to | binary | Transaction recipient |
| evt_index | long | Event index in transaction |

**Key Metrics:**
- DEX trading volume across multiple chains
- Token swap analytics
- Liquidity provider insights
- Trading pair analysis

**GitHub:** https://github.com/duneanalytics/spellbook/tree/main/dbt_subprojects/dex/models/trades/dex_trades.sql

---

## dex.pools

**Category:** Trading / Liquidity Pools  
**Full Path:** `dex.pools`  
**Description:** DEX pools on all chains across all contracts and versions. Provides core pool metadata for liquidity pools.

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| blockchain | string | Blockchain network |
| project | string | DEX protocol name |
| version | string | Contract version |
| pool | binary | Pool contract address |
| fee | decimal(38,) | Pool fee tier (e.g., 0.30%) |
| token0 | binary | First token in pair contract address |
| token1 | binary | Second token in pair contract address |
| creation_block_time | timestamp | When pool was created |
| creation_block_number | long | Block number when pool was created |
| contract_address | binary | Pool contract address |

**Key Metrics:**
- Pool TVL calculations (requires joining with price data)
- Liquidity provider composition
- Pool creation timeline
- Fee tier analysis

---

## Available Spellbook Categories

| Category | Table Count | Description |
|----------|-------------|-------------|
| tokens | +55 tables | Token transfer and balance data |
| dex | +46 tables | Decentralized exchange data (multi-chain) |
| dex_solana | - | Solana-specific DEX data |
| prices | +56 tables | Token price data |
| nft | +22 tables | NFT market data |
| erc20 | +9 tables | ERC20-specific data |
| erc721 | - | ERC721 (NFT) specific data |
| dex_aggregator | +8 tables | DEX aggregator data (see [dex-aggregator.md](dex-aggregator.md)) |
| labels | +16 tables | Address labels and classifications |
| staking | - | Staking protocol data |
| evms | +52 tables | Multi-chain EVM data |
| gas | +52 tables | Gas price and usage data |
| contracts | - | Contract information |

---

## Data Type Reference

| Type | Description |
|------|-------------|
| string / varchar | Text data |
| binary / varbinary | Byte data (addresses, hashes) |
| date | Date type |
| timestamp | DateTime type with timezone |
| long / bigint | Large integer (block numbers) |
| double | Floating point number |
| uint256 | 256-bit unsigned integer |
| decimal(38,) | High-precision decimal |
| array(type) | Array data type |
