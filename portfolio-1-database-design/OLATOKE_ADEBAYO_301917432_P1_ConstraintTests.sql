-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customers pk. Expected: pk_customers, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("id", "email", "full_name", "created_at")
VALUES (1, 'new-customer@example.test', 'New Customer', '2026-04-01T09:00:00Z');

-- 2. customers unique email. Expected: uq_customers_0, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("id", "email", "full_name", "created_at")
VALUES (101, 'amina@example.test', 'Another Customer', '2026-04-01T09:00:00Z');

-- 3. customers not null id. Expected: id, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("id", "email", "full_name", "created_at")
VALUES (NULL, 'null-id-customer@example.test', 'Null Id Customer', '2026-04-01T09:00:00Z');

-- 4. customers not null email. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("id", "email", "full_name", "created_at")
VALUES (102, NULL, 'Null Email Customer', '2026-04-01T09:00:00Z');

-- 5. customers not null name. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("id", "email", "full_name", "created_at")
VALUES (103, 'null-name@example.test', NULL, '2026-04-01T09:00:00Z');

-- 6. customers not null created at. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("id", "email", "full_name", "created_at")
VALUES (104, 'null-created@example.test', 'Null Created Customer', NULL);

-- 7. products pk. Expected: pk_products, SQLSTATE 23505.
INSERT INTO portfolio."products" ("id", "sku", "name", "category", "list_price")
VALUES (2, 'SC-301', 'New Product', 'Home', 5);

-- 8. products unique sku. Expected: uq_products_0, SQLSTATE 23505.
INSERT INTO portfolio."products" ("id", "sku", "name", "category", "list_price")
VALUES (105, 'SC-100', 'Another Product', 'Accessories', 5);

-- 9. products not null id. Expected: id, SQLSTATE 23502.
INSERT INTO portfolio."products" ("id", "sku", "name", "category", "list_price")
VALUES (NULL, 'SC-302', 'Null Id Product', 'Home', 5);

-- 10. products not null sku. Expected: sku, SQLSTATE 23502.
INSERT INTO portfolio."products" ("id", "sku", "name", "category", "list_price")
VALUES (106, NULL, 'Null SKU Product', 'Home', 5);

-- 11. products not null name. Expected: name, SQLSTATE 23502.
INSERT INTO portfolio."products" ("id", "sku", "name", "category", "list_price")
VALUES (107, 'SC-303', NULL, 'Home', 5);

-- 12. products not null category. Expected: category, SQLSTATE 23502.
INSERT INTO portfolio."products" ("id", "sku", "name", "category", "list_price")
VALUES (108, 'SC-304', 'Null Category Product', NULL, 5);

-- 13. products not null list price. Expected: list_price, SQLSTATE 23502.
INSERT INTO portfolio."products" ("id", "sku", "name", "category", "list_price")
VALUES (109, 'SC-305', 'Null Price Product', 'Home', NULL);

-- 14. orders pk. Expected: pk_orders, SQLSTATE 23505.
INSERT INTO portfolio."orders" ("id", "customer_id", "order_date", "status")
VALUES (3, 5, '2026-04-01', 'placed');

-- 15. orders fk customer. Expected: fk_orders_0, SQLSTATE 23503.
INSERT INTO portfolio."orders" ("id", "customer_id", "order_date", "status")
VALUES (110, 99999, '2026-04-01', 'placed');

-- 16. orders not null id. Expected: id, SQLSTATE 23502.
INSERT INTO portfolio."orders" ("id", "customer_id", "order_date", "status")
VALUES (NULL, 1, '2026-04-01', 'placed');

-- 17. orders not null customer id. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."orders" ("id", "customer_id", "order_date", "status")
VALUES (111, NULL, '2026-04-01', 'placed');

-- 18. orders not null order date. Expected: order_date, SQLSTATE 23502.
INSERT INTO portfolio."orders" ("id", "customer_id", "order_date", "status")
VALUES (112, 1, NULL, 'placed');

-- 19. orders not null status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."orders" ("id", "customer_id", "order_date", "status")
VALUES (113, 1, '2026-04-01', NULL);

-- 20. order items pk. Expected: pk_order_items, SQLSTATE 23505.
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price")
VALUES (4, 3, 6, 1, 8);

-- 21. order items unique order product. Expected: uq_order_items_0, SQLSTATE 23505.
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price")
VALUES (114, 3, 2, 1, 12.5);

-- 22. order items fk order. Expected: fk_order_items_0, SQLSTATE 23503.
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price")
VALUES (115, 99999, 2, 1, 12.5);

-- 23. order items fk product. Expected: fk_order_items_1, SQLSTATE 23503.
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price")
VALUES (116, 3, 99999, 1, 12.5);

-- 24. order items not null id. Expected: id, SQLSTATE 23502.
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price")
VALUES (NULL, 3, 6, 1, 8);

-- 25. order items not null order id. Expected: order_id, SQLSTATE 23502.
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price")
VALUES (117, NULL, 6, 1, 8);

-- 26. order items not null product id. Expected: product_id, SQLSTATE 23502.
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price")
VALUES (118, 3, NULL, 1, 8);

-- 27. order items not null quantity. Expected: quantity, SQLSTATE 23502.
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price")
VALUES (119, 3, 6, NULL, 8);

-- 28. order items not null unit price. Expected: unit_price, SQLSTATE 23502.
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price")
VALUES (120, 3, 6, 1, NULL);

-- 29. order items check quantity positive. Expected: order_item_quantity_positive, SQLSTATE 23514.
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price")
VALUES (121, 3, 6, 0, 8);

-- 30. order items check price nonnegative. Expected: order_item_price_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price")
VALUES (122, 3, 6, 1, -1);
