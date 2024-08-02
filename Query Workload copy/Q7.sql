/*
This query explores relationships between Ethereum balances, transaction nonces, 
and token values by categorizing each attribute into defined buckets. It then 
groups the data to show patterns and counts within these categories, 
highlighting how these attributes relate and vary across different ranges.

More buckets may be added

E1-E4 should be replaced by integers that fall in the range of eth_balances that exist 
within your chosen window

N1-N4 should be replaced by integers that fall in the range of nonce values that exist
within your chosen window

T1-T4 should be replaced by integers that fall in the range of values of token transactions
that exist within your chosen window
*/
SELECT COUNT(*) as count,
    CASE 
        WHEN a.eth_balance BETWEEN E1 AND E2 THEN 'EthBalanceBucket1'
        WHEN a.eth_balance BETWEEN E3 AND E4 THEN 'EthBalanceBucket2'
        ELSE 'Other'
    END as eth_balance_bucket,
    CASE 
        WHEN t.nonce BETWEEN N1 AND N2 THEN 'NonceBucket1'
        WHEN t.nonce BETWEEN N3 AND N4 THEN 'NonceBucket2'
        ELSE 'Other'
    END as nonce_bucket,
    CASE 
        WHEN t_t.value BETWEEN T1 AND T2 THEN 'TokenTransactionValueBucket1'
        WHEN t_t.value BETWEEN T3 AND T4 THEN 'TokenTransactionValueBucket2'
        ELSE 'Other'
    END as token_value_bucket
FROM Addresses a, Transactions t, Token_Transactions t_t
WHERE t.from_address = a.address
AND t.hash = t_t.transaction_hash
GROUP BY eth_balance_bucket, nonce_bucket, token_value_bucket;
