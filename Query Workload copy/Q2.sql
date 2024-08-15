/*
The following query looks for users that frequently make large token transactions, 
in which a they send between 0.5 and 0.75 percent of the total supply in a single 
transaction
*/
SELECT t.from_address, tokens.symbol, COUNT(*)
FROM Token_Transactions t_t, Transactions t, Tokens tokens
WHERE t_t.token_address = tokens.address
AND t.hash = t_t.transaction_hash
AND t_t.value >= (tokens.total_supply * 0.5)
AND t_t.value <= (tokens.total_supply * 0.75)
GROUP BY t.from_address, tokens.symbol, tokens.total_supply
ORDER BY DESC COUNT(*);