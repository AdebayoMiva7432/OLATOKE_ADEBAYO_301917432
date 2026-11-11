# MIT 8103 Advanced Database Systems

**SwiftCart Nigeria: E-commerce Management System** · ADEBAYO OLATOKE · Student ID 301917432

## Case study

My case study is SwiftCart Nigeria: E-commerce Management System. It focuses on designing a database for an online business where customers can browse and order products. The database stores information about customers, products, orders and order items in four separate tables: `customers`, `products`, `orders` and `order_items`.

The database supports creating orders and their product lines, committing or rolling back transactions, joining order lines to orders, customers and products to inspect purchases, filtering orders by date and status, and aggregating sales by product. I also benchmarked the same order-date range lookup on 20,000 synthetic orders with and without a B-tree index, then compared the query plans and recorded the measurements.

## Portfolio 1: Database Design and Modelling

I organised the relational design into four tables. Primary keys identify records, foreign keys preserve relationships, and check constraints enforce the stated business rules. For example, an order item's quantity must be greater than zero. The normalisation examples show the sample data in first, second and third normal forms (1NF, 2NF and 3NF). All 30 deliberately invalid inserts were rejected, and the valid sample rows remained unchanged. These tests demonstrate how constraints help validate the database design.

![SwiftCart Nigeria: E-commerce Management System ER diagram](images/OLATOKE_ADEBAYO_301917432_ERDiagram.png)

*Figure 1. Tables, keys and relationships. PK: primary key; FK: foreign key; UK: unique key.*

<!-- PAGE BREAK -->

## Portfolio 2: Query Processing and Optimisation

I ran three SQL queries against the sample records. The join returned two rows and included `amina@example.test` with order `SC-100`. For the index comparison, I used 20,000 separate performance-test rows. The median lookup time changed from 0.812 ms to 0.185 ms. Both phases returned the same records, and the measured plan used the new index. These timings apply to this lookup and test environment.

## Portfolio 3: Transactions and Concurrency

I used a temporary counter on `order_items` to test COMMIT, ROLLBACK and READ COMMITTED isolation. The uncommitted update remained hidden from the other session, and ROLLBACK restored the earlier committed value. Without locking, two increments left the counter at 2. With SELECT FOR UPDATE, Session B waited for Session A, and the final value was 3. The helper was confined to this exercise; the case study's original business fields remained unchanged.

## Portfolio 4: NoSQL and Advanced Data Models

I used an `order_events` collection for the case study's event documents. MongoDB inserted four sample events and returned the expected results for four queries. Validation rejected an invalid date type and a duplicate event ID. Embedded snapshots keep related details with an event, while the `details` field can differ by event type. These are fictional events; PostgreSQL continues to enforce its relational rules.

## Repository and evidence

[GitHub repository](https://github.com/AdebayoMiva7432/OLATOKE_ADEBAYO_301917432)

The portfolio folders contain the SQL and JavaScript files, explanations, query plans, result tables and screenshots.

<!-- PAGE BREAK -->

## Portfolio 5: Distributed and Cloud Database Exercise

I proposed three MongoDB replica-set members across separate failure zones. The discussion covers primary elections, majority acknowledgement, secondary lag and sharding trade-offs for `order_events`. Replication supports availability, while backups support recovery. PostgreSQL needs its own availability plan. This is the permitted discussion option; no live replica set or failover test was deployed.

## Individual reflection

I kept customers, products, orders and order items in separate tables so their details could be maintained without repeating them in every related record. The order-item quantity must be greater than zero. The constraint tests check this rule alongside required values and record links. One issue illustrated by the two-session exercise is that both sessions can read the same value before either update is committed. Locking the row before reading preserves both increments. The index comparison also shows why I need to check the execution plan as well as the final result: the same result can require different amounts of database work.

## AI-use declaration

I used GitHub Copilot and Portfolio Generator to assist with preparing and reviewing scripts. I used Neon PostgreSQL to create, execute and test the relational database scripts. I also used ChatGPT for explanations, guidance and troubleshooting during this coursework. I remain responsible for the work submitted and for understanding the database concepts and results.

## References

- [PostgreSQL: constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)
- [PostgreSQL: EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)
- [PostgreSQL: isolation](https://www.postgresql.org/docs/17/transaction-iso.html)
- [PostgreSQL: row locks](https://www.postgresql.org/docs/17/explicit-locking.html)
- [MongoDB: data modelling](https://www.mongodb.com/docs/manual/data-modeling/)
- [MongoDB: replication](https://www.mongodb.com/docs/manual/replication/)
- [MongoDB: sharding](https://www.mongodb.com/docs/manual/sharding/)
- [Mermaid: ER diagrams](https://mermaid.js.org/syntax/entityRelationshipDiagram.html)
