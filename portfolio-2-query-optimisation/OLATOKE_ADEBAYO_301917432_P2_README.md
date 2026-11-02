# SwiftCart Nigeria: E-commerce Management System — Portfolio 2: Query Processing and Optimisation

## 1. Purpose

This portfolio demonstrates SQL query processing and query optimisation for the SwiftCart Nigeria e-commerce database. The queries use the Portfolio 1 PostgreSQL schema in the `portfolio` schema. The optimisation experiment uses a separate `query_lab` schema so that generated test data does not alter the case-study records.

## 2. SQL queries and results

### Query 1 — Join related order, customer and product records

This query joins `order_items`, `orders`, `customers` and `products` to show which customers placed orders and which products were included.

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

### Query 2 — Find orders for a selected date

This query filters orders to those placed on 1 March 2026.

```sql
SELECT * FROM portfolio."orders"
WHERE "order_date" IS NOT DISTINCT FROM '2026-03-01'
ORDER BY "id"
LIMIT 20;
```

| id | customer_id | order_date | status |
| --- | --- | --- | --- |
| 3 | 1 | 2026-03-01 | placed |

### Query 3 — Count order items per order

This query groups order items by order and counts the number of item records in each order.

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

The result tables above show the recorded sample output for the current Portfolio 1 sample data.

## 3. Execution plan evidence for the case-study queries

The query script `OLATOKE_ADEBAYO_301917432_P2_Queries.sql` includes an `EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)` statement immediately after each of the three queries. These statements ask PostgreSQL to execute each query and report its actual execution plan and runtime measurements.

To capture the plan evidence in Neon:

1. Open the Neon SQL Editor for the database containing the Portfolio 1 schema.
2. Run each query's corresponding `EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)` statement from the SQL script.
3. Save or copy the returned JSON plan output for each query.
4. Add the three outputs or clear screenshots to this portfolio folder so the assessor can inspect the actual plans.

**Important evidence note:** The SQL script contains all three plan commands. The detailed plan text currently reproduced in this README is for the separate before-and-after index experiment in Section 4. Do not treat that experiment's plan output as the execution plan for the three case-study queries. Actual plan output depends on the database contents, statistics and execution environment, so it must be captured from the database rather than filled in with estimated or invented values.

When reviewing each plan, check the scan method used for each table, the join method (where relevant), actual rows, planning time, execution time and buffer information. PostgreSQL's documentation explains how to read these plan nodes and the difference between estimated and actual measurements.

## 4. Indexing and optimisation experiment

### 4.1 Experiment design

The optimisation script creates a separate `query_lab` schema and a test table with an `order_date` column using the same data type as `portfolio.orders.order_date`. It inserts 20,000 generated test rows, runs `ANALYZE`, and measures the same selective date lookup three times before and after creating a B-tree index on `order_date`.

The generated rows are used only for the performance experiment. They are not represented as real SwiftCart customer orders, and the experiment does not modify the original Portfolio 1 tables.

### 4.2 Before-and-after results

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.812 | 0.808, 0.823, 0.812 | Sort → Seq Scan | 112 |
| After index | 0.185 | 0.185, 0.212, 0.148 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.812 ms to 0.185 ms, a reduction of approximately 77.2% for this particular test lookup and dataset. The indexed plan used `p2_filter_idx`. The query returned matching results in both phases.

An index can reduce the amount of table data that must be examined for a selective lookup. However, indexes also use storage and add work when rows are inserted, updated or deleted. The benefit therefore depends on the query pattern, table size, data distribution and database environment. These measurements should not be generalized to every SwiftCart query.

### 4.3 Recorded execution plans for the index experiment

#### Before index — run 1

```text
Sort (actual time=0.789..0.791 rows=20 loops=1)
  Seq Scan on orders (actual time=0.013..0.759 rows=20 loops=1)
Planning Time: 0.295 ms
Execution Time: 0.808 ms
```

#### Before index — run 2

```text
Sort (actual time=0.802..0.804 rows=20 loops=1)
  Seq Scan on orders (actual time=0.013..0.771 rows=20 loops=1)
Planning Time: 0.302 ms
Execution Time: 0.823 ms
```

#### Before index — run 3

```text
Sort (actual time=0.792..0.794 rows=20 loops=1)
  Seq Scan on orders (actual time=0.013..0.76 rows=20 loops=1)
Planning Time: 0.298 ms
Execution Time: 0.812 ms
```

#### After index — run 1

```text
Sort (actual time=0.132..0.134 rows=20 loops=1)
  Bitmap Heap Scan on orders (actual time=0.031..0.093 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=20 loops=1)
Planning Time: 0.567 ms
Execution Time: 0.185 ms
```

#### After index — run 2

```text
Sort (actual time=0.162..0.165 rows=20 loops=1)
  Bitmap Heap Scan on orders (actual time=0.032..0.1 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=20 loops=1)
Planning Time: 0.623 ms
Execution Time: 0.212 ms
```

#### After index — run 3

```text
Sort (actual time=0.109..0.11 rows=20 loops=1)
  Bitmap Heap Scan on orders (actual time=0.024..0.076 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.012..0.013 rows=20 loops=1)
Planning Time: 0.513 ms
Execution Time: 0.148 ms
```

## 5. Screenshots and supporting files

- [Query results screenshot](screenshots/OLATOKE_ADEBAYO_301917432_P2_QueryResults.png)
- [Index comparison screenshot](screenshots/OLATOKE_ADEBAYO_301917432_P2_IndexComparison.png)

Supporting SQL scripts:

- `OLATOKE_ADEBAYO_301917432_P2_Queries.sql` — the three case-study queries and their `EXPLAIN ANALYZE` commands.
- `OLATOKE_ADEBAYO_301917432_P2_Optimisation.sql` — the separate 20,000-row index experiment.

## 6. How to reproduce

Use a database containing the Portfolio 1 schema and sample data.

1. Run `OLATOKE_ADEBAYO_301917432_P2_Queries.sql` to reproduce the three case-study queries and obtain their execution plans.
2. Run `OLATOKE_ADEBAYO_301917432_P2_Optimisation.sql` to create the separate performance table, populate it, measure the lookup before indexing, create the B-tree index, and measure it again.
3. Compare the result sets and plan measurements. Record the environment and any differences in timings if the experiment is repeated.

The optimisation script creates the `query_lab` schema. If it has already been created in the database, use a clean test database or remove the previous lab schema before rerunning the script; do not drop or alter the Portfolio 1 `portfolio` schema.

## 7. References and tools used

1. PostgreSQL Global Development Group. (2026). *PostgreSQL 17 documentation: Using EXPLAIN*. https://www.postgresql.org/docs/17/using-explain.html  
   Used as the technical reference for understanding query plans, scan and join nodes, `EXPLAIN ANALYZE`, actual row counts and execution-time measurements.

2. Neon. (n.d.). *Query with Neon's SQL Editor*. https://neon.com/docs/get-started/query-with-neon-sql-editor  
   Used as the platform documentation for running SQL statements and inspecting query plans in the Neon SQL Editor.

3. OpenAI. (n.d.). *ChatGPT capabilities overview*. OpenAI Help Center. https://help.openai.com/en/articles/9260256-chatgpt-capabilities-overview  
   ChatGPT was used as an AI learning and documentation-support tool to better explain SQL and execution-plan concepts, review the portfolio structure, and help improve the README. AI assistance is acknowledged.

4. Neon. (n.d.). *Neon documentation*. https://neon.com/docs  
   General documentation for the PostgreSQL hosting platform used for this coursework.

5. SwiftCart Nigeria Portfolio 1 database schema and sample data. (2026). *Student's MIT8103 coursework implementation*.  
   The case-study tables and sample query outputs in this portfolio are based on the Portfolio 1 implementation.

## 8. AI-use and verification note

ChatGPT (OpenAI) assisted with learning explanations, reviewing the Portfolio 2 materials and improving this documentation. ChatGPT is not the source of the database execution results.
