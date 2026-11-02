# SwiftCart Nigeria: E-commerce Management System — SQL queries

## 1. Show related order_items, orders, customers, products records (up to 20).

```sql
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
```

| order_items_id | order_items_quantity | orders_id | orders_order_date | customers_id | customers_email | products_id | products_sku |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4 | 2 | 3 | 2026-03-01 | 1 | amina@example.test | 2 | SC-100 |
| 8 | 1 | 7 | 2026-03-04 | 5 | tunde@example.test | 6 | SC-200 |

## 2. Find orders records where order_date matches "2026-03-01" (up to 20).

```sql
SELECT * FROM portfolio."orders"
WHERE "order_date" IS NOT DISTINCT FROM '2026-03-01'
ORDER BY "id"
LIMIT 20;
```

| id | customer_id | order_date | status |
| --- | --- | --- | --- |
| 3 | 1 | 2026-03-01 | placed |

## 3. Count order_items records for each order_id (up to 20 groups).

```sql
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_items"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;
```

| order_id | record_count |
| --- | --- |
| 3 | 1 |
| 7 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.812 | 0.808, 0.823, 0.812 | Sort → Seq Scan | 112 |
| After index | 0.185 | 0.185, 0.212, 0.148 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.812 ms to 0.185 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.789..0.791 rows=20 loops=1)
  Seq Scan on orders (actual time=0.013..0.759 rows=20 loops=1)
Planning Time: 0.295 ms
Execution Time: 0.808 ms
```

### Before index, run 2

```text
Sort (actual time=0.802..0.804 rows=20 loops=1)
  Seq Scan on orders (actual time=0.013..0.771 rows=20 loops=1)
Planning Time: 0.302 ms
Execution Time: 0.823 ms
```

### Before index, run 3

```text
Sort (actual time=0.792..0.794 rows=20 loops=1)
  Seq Scan on orders (actual time=0.013..0.76 rows=20 loops=1)
Planning Time: 0.298 ms
Execution Time: 0.812 ms
```

### After index, run 1

```text
Sort (actual time=0.132..0.134 rows=20 loops=1)
  Bitmap Heap Scan on orders (actual time=0.031..0.093 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=20 loops=1)
Planning Time: 0.567 ms
Execution Time: 0.185 ms
```

### After index, run 2

```text
Sort (actual time=0.162..0.165 rows=20 loops=1)
  Bitmap Heap Scan on orders (actual time=0.032..0.1 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=20 loops=1)
Planning Time: 0.623 ms
Execution Time: 0.212 ms
```

### After index, run 3

```text
Sort (actual time=0.109..0.11 rows=20 loops=1)
  Bitmap Heap Scan on orders (actual time=0.024..0.076 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.012..0.013 rows=20 loops=1)
Planning Time: 0.513 ms
Execution Time: 0.148 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run OLATOKE_ADEBAYO_301917432_P2_Queries.sql, then OLATOKE_ADEBAYO_301917432_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/OLATOKE_ADEBAYO_301917432_P2_QueryResults.png) · [Index comparison](screenshots/OLATOKE_ADEBAYO_301917432_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html). Supports the explanation of query execution plans and performance measurements.
- [Neon Documentation](https://neon.com/docs). Documents the Neon platform used to host and execute the PostgreSQL database for this project.
