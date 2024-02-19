EXPLAIN ANALYZE SELECT
    t0."id",
    t0."capacity",
    t0."restaurant_id",
    t0."inserted_at",
    t0."updated_at"
FROM
    "tables" AS t0
WHERE (t0."restaurant_id" = 1)
    AND (NOT (t0."id" = ANY ('{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}')));
