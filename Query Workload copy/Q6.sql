/*
The following query looks at transactions that involve more than 75% of a user's Ethereum
balance, where the user was willing to pay a priority gas fee that was higher than the average
that others paid within this block

A possible interpretation is that this looks at users who were in a hurry to transact the 
majority of their balance
*/
SELECT t1.hash
FROM Transactions t1, Addresses a
WHERE t1.from_address = a.address
AND t1.value >= (a.eth_balance * 0.75)
AND t1.max_priority_fee_per_gas >= (
	SELECT AVG(t2.max_priority_fee_per_gas)
	FROM Transactions t2, Blocks b
	WHERE t1.hash = t2.hash
	AND t2.block_hash = b.hash
);
