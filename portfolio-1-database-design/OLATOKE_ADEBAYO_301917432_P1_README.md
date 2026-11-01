# Portfolio 1 — Database Design and Modelling

## Project overview

This portfolio presents the database design and PostgreSQL implementation for **SwiftCart Nigeria**, a fictional e-commerce management system.

The database organises information into four related tables:

- `customers`
- `products`
- `orders`
- `order_items`

The design and ER diagram documents describe the entities, attributes, keys, relationships and business rules. The normalisation document explains how the data is organised into first, second and third normal forms.

## Database implementation

The PostgreSQL implementation contains four tables. The database-results evidence records the following sample row counts:

| Table | Sample rows |
| --- | ---: |
| `customers` | 2 |
| `products` | 2 |
| `orders` | 2 |
| `order_items` | 2 |
| **Total** | **8** |

The schema includes:

- A primary key for each table.
- Foreign keys connecting orders to customers, and order items to orders and products.
- Unique constraints for customer email and product SKU.
- A unique constraint on the `order_id` and `product_id` combination in `order_items`.
- CHECK constraints requiring order-item quantity to be greater than zero and unit price to be non-negative.

## Constraint testing

The constraint-testing script contains **30 deliberately invalid INSERT statements** designed to test primary-key, unique, foreign-key, NOT NULL and CHECK constraints.

The Portfolio 1 database-results screenshot records **Rejected** for all 30 invalid-data checks. This is the evidence summary for the negative tests. The screenshot does not display the individual PostgreSQL SQLSTATE codes, so this README does not claim that those codes were separately recorded.

## Project files

- [Database design](OLATOKE_ADEBAYO_301917432_P1_Design.md)
- [ER diagram documentation](OLATOKE_ADEBAYO_301917432_P1_ERDiagram.md)
- [Normalisation explanation](OLATOKE_ADEBAYO_301917432_P1_Normalisation.md)
- [Database schema](OLATOKE_ADEBAYO_301917432_P1_Schema.sql)
- [Sample data](OLATOKE_ADEBAYO_301917432_P1_SampleData.sql)
- [Constraint tests](OLATOKE_ADEBAYO_301917432_P1_ConstraintTests.sql)
- [Database tables and constraint-test evidence](screenshots/OLATOKE_ADEBAYO_301917432_P1_DatabaseResults.png)

## Running the SQL scripts

1. Create a fresh PostgreSQL database.
2. Execute the schema script first.
3. Execute the sample-data script.
4. Run the deliberately invalid statements in the constraint-test script individually, outside a transaction that would prevent subsequent statements from running.

Each invalid statement is intended to be rejected by its corresponding database constraint.

## Reference

- [PostgreSQL Documentation — Constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)
