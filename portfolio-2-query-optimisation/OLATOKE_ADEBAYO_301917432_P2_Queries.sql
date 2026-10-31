-- Show related order_items, orders, customers, products records (up to 20).
SELECT t0."id" AS "order_items_id",
       t0."quantity" AS "order_items_quantity",
       t1."id" AS "orders_id",
       t1."order_date" AS "orders_order_date",
       t2."id" AS "customers_id",
       t2."email" AS "customers_email",
       t3."id" AS "products_id",
       t3."sku" AS "products_sku"
FROM portfolio."order_items" t0
JOIN portfolio."orders" t1 ON t0."order_id" = t1."id"
JOIN portfolio."customers" t2 ON t1."customer_id" = t2."id"
JOIN portfolio."products" t3 ON t0."product_id" = t3."id"
ORDER BY t0."id", t1."id", t2."id", t3."id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."id" AS "order_items_id",
       t0."quantity" AS "order_items_quantity",
       t1."id" AS "orders_id",
       t1."order_date" AS "orders_order_date",
       t2."id" AS "customers_id",
       t2."email" AS "customers_email",
       t3."id" AS "products_id",
       t3."sku" AS "products_sku"
FROM portfolio."order_items" t0
JOIN portfolio."orders" t1 ON t0."order_id" = t1."id"
JOIN portfolio."customers" t2 ON t1."customer_id" = t2."id"
JOIN portfolio."products" t3 ON t0."product_id" = t3."id"
ORDER BY t0."id", t1."id", t2."id", t3."id"
LIMIT 20;

-- Find orders records where order_date matches "2026-03-01" (up to 20).
SELECT * FROM portfolio."orders"
WHERE "order_date" IS NOT DISTINCT FROM '2026-03-01'
ORDER BY "id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."orders"
WHERE "order_date" IS NOT DISTINCT FROM '2026-03-01'
ORDER BY "id"
LIMIT 20;

-- Count order_items records for each order_id (up to 20 groups).
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_items"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_items"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;
