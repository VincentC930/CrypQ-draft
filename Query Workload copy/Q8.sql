/*
The following query finds all cycles where: 
address A transacted to address B
address B transacted to address C
address C transacted to address A
Order them by how often this trio of addresses transacted to one another in a cycle of length 3
Output the 3 addresses along with this count
*/
WITH Transaction_One AS (
    SELECT from_address, to_address, hash
    FROM Transactions
),
Transaction_Two AS (
    SELECT from_address, to_address, hash
    FROM Transactions
),
Transaction_Three AS (
    SELECT from_address, to_address, hash
    FROM Transactions
)
SELECT t_one.from_address AS address_one, t_two.from_address AS address_two, t_three.from_address AS address_three, COUNT(*)
FROM Transaction_One t_one, Transaction_Two t_two, Transaction_Three t_three
WHERE t_one.to_address = t_two.from_address
AND t_two.to_address = t_three.from_address
AND t_three.to_address = t_one.from_address
AND t_one.to_address <> t_two.to_address
AND t_two.to_address <> t_three.to_address
AND t_three.to_address <> t_one.to_address
AND t_one.hash <> t_two.hash
AND t_two.hash <> t_three.hash
AND t_three.hash <> t_one.hash
AND t_one.to_address < t_two.to_address
AND t_two.to_address < t_three.to_address
GROUP BY t_one.from_address, t_two.from_address, t_three.from_address
ORDER BY COUNT(*) DESC;