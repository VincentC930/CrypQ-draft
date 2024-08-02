/*
The following query captures large transactions conducted by users with sig-
nificant balances, which may be of interest to those analyzing trends and patterns
in the Ethereum ecosystem by observing the behavior of major stakeholders

More specifically, Q1 returns the number of token transactions in which between 10^9 
and 10^10 of a token (excluding those with “US” in the name) were sent to an ERC20 
contract by a user account who has an Ether balance over 25 × 1015 and has transacted 
between 2.1 and 4.2 millions times in the past (Transactions.nonce records the total 
number of transactions sent so far from a specific address)
*/
SELECT COUNT(*)
FROM Transactions t, Tokens, Token_Transactions t_t, Contracts c, Addresses a
WHERE t.hash = t_t.transaction_hash
AND t_t.token_address = tokens.address
AND t.to_address = c.address
AND t.from_address = a.address
AND t.nonce BETWEEN 2100000 AND 4200000
AND t_t.value BETWEEN 1000000000 AND 10000000000
AND tokens.name NOT LIKE '%US%'
AND c.is_erc20 = TRUE
AND a.eth_balance > 25000000000000000;