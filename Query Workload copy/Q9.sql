/*
The following query looks for the longest cycle that exists where address A transacts to
address B ... until address A eventually is transacted to
*/
WITH RECURSIVE Transaction_Path AS (
    SELECT from_address, to_address, ARRAY[from_address, to_address]::VARCHAR[] AS path, 
    from_address AS start_address, to_address AS current_address, 1 AS path_length
    FROM Transactions

    UNION ALL

    SELECT tp.from_address, t.to_address, tp.path || t.to_address, tp.start_address,
    t.to_address, tp.path_length + 1
    FROM Transaction_Path tp, Transactions t
    WHERE tp.current_address = t.from_address
    AND NOT t.to_address = ANY(tp.path)
)
SELECT start_address, current_address, path, path_length
FROM Transaction_Path
WHERE start_address = current_address
ORDER BY path_length DESC
LIMIT 1;