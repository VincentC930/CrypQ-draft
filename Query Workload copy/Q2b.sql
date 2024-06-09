SELECT a.address, tokens.symbol, t_t.value, tokens.total_supply
FROM Token_Transactions t_t, Transactions t, Tokens tokens, Addresses a
WHERE t_t.token_address = tokens.address
AND t.hash = t_t.transaction_hash
AND (a.address = t.to_address OR a.address = t.from_address)
AND t_t.value >= (tokens.total_supply * 0.5)
AND t_t.value <= (tokens.total_supply * 0.75);