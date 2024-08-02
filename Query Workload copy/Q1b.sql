/*
The following query looks for the Ethereum balances of users who transacted over X tokens
to a erc_20 contract.

Replace X with an integer within the range of token transaction values in your selected
window
*/
SELECT a.address, a.eth_balance, c.address, tokens.symbol, t_t.value
FROM Addresses a, Transactions t, Token_Transactions t_t, Tokens tokens, Contracts c
WHERE a.address = t.from_address 
AND t.to_address = c.address
AND t.hash = t_t.transaction_hash
AND t_t.token_address = tokens.address
AND c.is_erc20 = TRUE
AND t_t.value > X;
