/*
The following query looks for the longest cycle that exists where address A transacts to
address B ... until address A eventually is transacted to
*/
-- original longes path query
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

-- modified for longest temporal path:
WITH RECURSIVE Transaction_Chain AS (
    SELECT t.from_address, t.to_address, ARRAY[t.from_address, t.to_address]::VARCHAR[] AS path, t.from_address AS start_address, t.to_address AS current_address, 1 AS path_length, b.number AS block_number
    FROM Transactions t, Blocks b
    Where t.block_hash = b.hash

    UNION ALL

    SELECT tp.from_address, t.to_address, tp.path || t.to_address, tp.start_address, t.to_address, tp.path_length + 1, b.number
    FROM Transaction_Chain tp, Transactions t, Blocks b
    WHERE t.from_address = tp.current_address
    AND t.block_hash = b.hash
    AND b.number > tp.block_number
    AND NOT t.to_address = ANY(tp.path)
)
SELECT start_address, current_address AS end_address, path, path_length
FROM Transaction_Chain
ORDER BY path_length DESC
LIMIT 1;

-- modified for longest temporal path out of those that show up 100 times or more
WITH RECURSIVE Transaction_Chain AS (
    SELECT t.from_address, t.to_address, ARRAY[t.from_address, t.to_address]::VARCHAR[] AS path, 1 AS path_length, b.number AS block_number
    FROM Transactions t, Blocks b
    WHERE t.block_hash = b.hash

    UNION ALL

    SELECT tp.from_address, t.to_address, tp.path || t.to_address, tp.path_length + 1, b.number
    FROM Transaction_Chain tp, Transactions t, Blocks b
    WHERE tp.current_address = t.from_address
    AND b.hash = t.block_hash
    AND NOT t.to_address = ANY(tp.path)
)
SELECT array_to_string(path, '->') AS path_string, COUNT(*) AS occurrence_count
FROM Transaction_Chain
GROUP BY path_string
HAVING COUNT(*) >= 100
ORDER BY occurrence_count DESC, LENGTH(path_string) DESC
LIMIT 1;