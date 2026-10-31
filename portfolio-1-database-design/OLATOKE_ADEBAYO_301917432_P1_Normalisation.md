# SwiftCart Nigeria: E-commerce Management System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| order_id | order_items records (list) |
| --- | --- |
| 3 | [4] |
| 7 | [8] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| order_items.id | order_items.order_id | order_items.product_id | orders.id | orders.customer_id | orders.status | customers.id | customers.email |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4 | 3 | 2 | 3 | 1 | placed | 1 | amina@example.test |
| 8 | 7 | 6 | 7 | 5 | reviewed | 5 | tunde@example.test |

Key: id.

## 2NF: depend on the whole key

order_items: order_id is a proper part of candidate key (order_id, product_id), and determines orders details. order_items: product_id is a proper part of candidate key (order_id, product_id), and determines products details.

## orders_example

| orders.id | orders.customer_id | orders.status | customers.id | customers.email |
| --- | --- | --- | --- | --- |
| 3 | 1 | placed | 1 | amina@example.test |
| 7 | 5 | reviewed | 5 | tunde@example.test |

## order_items_example

| order_items.id | order_items.order_id | order_items.product_id |
| --- | --- | --- |
| 4 | 3 | 2 |
| 8 | 7 | 6 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customers

| id | email | full_name | created_at |
| --- | --- | --- | --- |
| 1 | amina@example.test | Amina Okafor | 2026-01-10T09:00:00+00:00 |
| 5 | tunde@example.test | Tunde Bello | 2026-02-11T09:30:00+00:00 |

## products

| id | sku | name | category | list_price |
| --- | --- | --- | --- | --- |
| 2 | SC-100 | Cotton Tote | Accessories | 12.5 |
| 6 | SC-200 | Ceramic Mug | Home | 8 |

## orders

| id | customer_id | order_date | status |
| --- | --- | --- | --- |
| 3 | 1 | 2026-03-01 | placed |
| 7 | 5 | 2026-03-04 | reviewed |

## order_items

| id | order_id | product_id | quantity | unit_price |
| --- | --- | --- | --- | --- |
| 4 | 3 | 2 | 2 | 12.5 |
| 8 | 7 | 6 | 1 | 8 |

## Dependencies

- customers: (id) → email, full_name, created_at
- products: (id) → sku, name, category, list_price
- orders: (id) → customer_id, order_date, status
- order_items: (id) → order_id, product_id, quantity, unit_price

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
