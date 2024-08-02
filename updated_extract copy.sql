CREATE OR REPLACE TABLE crypto_ethereum_slice.recent_blocks AS SELECT *
FROM `bigquery-public-data.crypto_ethereum.blocks` ORDER BY timestamp DESC
LIMIT 1000;

-- according to:
-- https://www.4byte.directory/event-signatures/?bytes_signature=0x7fcf532c15f0a6db0bd6d0e038bea71d30d808c7d98cb3bf7268a95bf5081b65&sort=id
-- withdrawals will always have signature: 0x7fcf532c15f0a6db0bd6d0e038bea71d30d808c7d98cb3bf7268a95bf5081b65
-- this is at topic[0]
CREATE OR REPLACE TABLE crypto_ethereum_slice.recent_withdrawals AS
SELECT
  logs.block_hash,
  logs.log_index,
  logs.topics[SAFE_OFFSET(1)] AS withdrawal,
  logs.data
FROM
  `bigquery-public-data.crypto_ethereum.logs` AS logs
WHERE logs.topics[SAFE_OFFSET(0)] = '0x7fcf532c15f0a6db0bd6d0e038bea71d30d808c7d98cb3bf7268a95bf5081b65'
AND logs.block_hash IN (SELECT recent_blocks.hash FROM crypto_ethereum_slice.recent_blocks);


CREATE OR REPLACE TABLE crypto_ethereum_slice.recent_transactions AS
SELECT Transactions.*
FROM `bigquery-public-data.crypto_ethereum.transactions` AS Transactions
WHERE block_hash IN (SELECT recent_blocks.hash FROM crypto_ethereum_slice.recent_blocks);

CREATE OR REPLACE TABLE crypto_ethereum_slice.recent_contracts AS
SELECT Contracts.*
FROM `bigquery-public-data.crypto_ethereum.contracts` AS Contracts
WHERE address IN (SELECT from_address FROM crypto_ethereum_slice.recent_transactions)
   OR address IN (SELECT to_address FROM crypto_ethereum_slice.recent_transactions)
   OR block_hash IN (SELECT recent_blocks.hash FROM crypto_ethereum_slice.recent_blocks);

CREATE OR REPLACE TABLE crypto_ethereum_slice.recent_addresses AS
SELECT Addresses.*
FROM `bigquery-public-data.crypto_ethereum.balances` AS Addresses
WHERE address IN (SELECT from_address FROM crypto_ethereum_slice.recent_transactions)
   OR address IN (SELECT to_address FROM crypto_ethereum_slice.recent_transactions)
   OR address IN (SELECT miner FROM crypto_ethereum_slice.recent_blocks)
   OR address IN (SELECT address FROM crypto_ethereum_slice.recent_contracts)
   OR address IN (SELECT address FROM crypto_ethereum_slice.recent_withdrawals);

CREATE OR REPLACE TABLE crypto_ethereum_slice.recent_token_transactions AS
SELECT Token_Transactions.*
FROM `bigquery-public-data.crypto_ethereum.token_transfers` AS Token_Transactions
WHERE transaction_hash IN (SELECT recent_transactions.hash FROM crypto_ethereum_slice.recent_transactions);

CREATE OR REPLACE TABLE crypto_ethereum_slice.recent_tokens AS
SELECT Tokens.*
FROM `bigquery-public-data.crypto_ethereum.tokens` AS Tokens
WHERE address IN (SELECT token_address FROM crypto_ethereum_slice.recent_token_transactions)
   OR block_hash IN (SELECT recent_blocks.hash FROM crypto_ethereum_slice.recent_blocks);