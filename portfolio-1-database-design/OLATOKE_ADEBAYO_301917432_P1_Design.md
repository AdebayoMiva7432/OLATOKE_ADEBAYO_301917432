# SwiftCart Nigeria: E-commerce Management System — database design

My case study records customers, products, orders, order_items.

## Users

- Customers browsing and ordering products
- Store staff reviewing orders and product sales

## Main operations

- Create orders and their product lines, then commit or roll back the transaction.
- Join order lines to orders, customers, and products to inspect purchases.
- Filter orders by date and status; aggregate line sales by product.
- Benchmark the same order_date range lookup on 20000 synthetic orders with and without a B-tree index; compare query plans and record measurements without assuming an outcome.

## Entities

| Entity | Information stored |
| --- | --- |
| customers | A customer account that may place orders. |
| products | A product available for sale. |
| orders | An order placed by one customer. |
| order_items | A product line belonging to an order, with the sale-time quantity and unit price. |

## customers

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| full_name | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## products

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| sku | TEXT | Unique | Yes |
| name | TEXT |  | Yes |
| category | TEXT |  | Yes |
| list_price | NUMERIC(18,2) |  | Yes |
- Unique key: (sku).

## orders

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| order_date | DATE |  | Yes |
| status | TEXT |  | Yes |
- customer_id → customers.id

## order_items

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| order_id | BIGINT | FK | Yes |
| product_id | BIGINT | FK | Yes |
| quantity | INTEGER |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
- order_id → orders.id
- product_id → products.id
- Unique key: (order_id, product_id).

## Relationships and business rules

- Each customer email is required and unique.
- Each product SKU is required and unique.
- Every order references an existing customer.
- Every order item references an existing order.
- Every order item references an existing product.
- An order can contain at most one line for a given product.
- Order item quantity must be greater than zero.
- Order item unit_price must be zero or greater.

## Assumptions

- All records and measurements are synthetic; amounts use one unspecified currency and are stored as decimal values.
- Each order belongs to one customer, and each order line references one order and one product.
- An order contains at most one line per product; the database enforces this with a unique constraint on order_id and product_id.
- The normalisation example uses order_items as the root row with foreign keys to orders and products; customer is reached only through orders.

