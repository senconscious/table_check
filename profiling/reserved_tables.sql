-- All reserved. Need to provide actual datetimes in tsrange
EXPLAIN ANALYZE SELECT DISTINCT
    t0."id"
FROM
    "tables" AS t0
    INNER JOIN "reservations" AS r1 ON (r1."table_id" = t0."id")
        AND tsrange(r1."start_at", r1."end_at", '[]') && tsrange('2024-02-20 00:00:00', '2024-02-20 23:59:59', '[]')
WHERE (t0."restaurant_id" = 1);

-- All not reserved. Need to provide actual datetimes in tsrange
EXPLAIN ANALYZE SELECT DISTINCT
    t0."id"
FROM
    "tables" AS t0
    INNER JOIN "reservations" AS r1 ON (r1."table_id" = t0."id")
        AND tsrange(r1."start_at", r1."end_at", '[]') && tsrange('2024-02-20 18:40:00', '2024-02-20 18:50:00', '[]')
WHERE (t0."restaurant_id" = 1);
