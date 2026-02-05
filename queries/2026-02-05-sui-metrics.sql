-- Sui Daily Active Addresses and Transaction Volume
WITH 
daily_transactions AS (
  SELECT 
    DATE_TRUNC('day', block_time) AS day,
    COUNT(DISTINCT tx_hash) AS total_transactions,
    COUNT(DISTINCT from_address) AS unique_addresses,
    SUM(tx_gas_fee) AS total_gas_fees
  FROM sui.transactions
  GROUP BY 1
  ORDER BY 1 DESC
  LIMIT 30
),

daily_volume AS (
  SELECT 
    DATE_TRUNC('day', block_time) AS day,
    SUM(amount) AS total_transfer_volume
  FROM sui.transfers
  GROUP BY 1
  ORDER BY 1 DESC
  LIMIT 30
)

SELECT 
  dt.day,
  dt.total_transactions,
  dt.unique_addresses,
  dt.total_gas_fees,
  dv.total_transfer_volume,
  ROUND(dt.total_gas_fees / dt.total_transactions, 4) AS avg_gas_per_tx,
  ROUND(dv.total_transfer_volume / dt.unique_addresses, 2) AS avg_volume_per_user
FROM daily_transactions dt
JOIN daily_volume dv ON dt.day = dv.day
ORDER BY dt.day DESC;

-- Top Performing Sui Smart Contracts by Daily Transaction Count
SELECT 
  contract_address,
  COUNT(tx_hash) AS total_transactions,
  AVG(tx_gas_fee) AS avg_gas_fee,
  COUNT(DISTINCT from_address) AS unique_users
FROM sui.transactions
WHERE block_time >= NOW() - INTERVAL '30 days'
GROUP BY contract_address
ORDER BY total_transactions DESC
LIMIT 10;

-- Sui zkLogin Adoption Metrics
SELECT 
  DATE_TRUNC('day', block_time) AS day,
  COUNT(DISTINCT from_address) AS zklogin_users,
  ROUND(
    100.0 * COUNT(DISTINCT from_address) / 
    (SELECT COUNT(DISTINCT from_address) FROM sui.transactions),
    2
  ) AS zklogin_adoption_percentage
FROM sui.transactions
WHERE from_address LIKE '%zklogin%'
GROUP BY 1
ORDER BY 1 DESC
LIMIT 30;