/*
The following query returns the number of different tokens transacted between 
blocks X and Y

Replace X and Y with integers within the range of block numbers in your selected window
*/
SELECT COUNT(DISTINCT t_t.token_address)
FROM Blocks b, Transactions t, token_transactions t_t
WHERE b.hash = t.block_hash
AND t.hash = t_t.transaction_hash
AND b.number BETWEEN X AND Y;