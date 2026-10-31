-- Fictional sample records for SwiftCart Nigeria: E-commerce Management System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customers" ("id", "email", "full_name", "created_at") VALUES (1, 'amina@example.test', 'Amina Okafor', '2026-01-10T09:00:00Z');
INSERT INTO portfolio."customers" ("id", "email", "full_name", "created_at") VALUES (5, 'tunde@example.test', 'Tunde Bello', '2026-02-11T10:30:00+01:00');
INSERT INTO portfolio."products" ("id", "sku", "name", "category", "list_price") VALUES (2, 'SC-100', 'Cotton Tote', 'Accessories', 12.5);
INSERT INTO portfolio."products" ("id", "sku", "name", "category", "list_price") VALUES (6, 'SC-200', 'Ceramic Mug', 'Home', 8);
INSERT INTO portfolio."orders" ("id", "customer_id", "order_date", "status") VALUES (3, 1, '2026-03-01', 'placed');
INSERT INTO portfolio."orders" ("id", "customer_id", "order_date", "status") VALUES (7, 5, '2026-03-04', 'reviewed');
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price") VALUES (4, 3, 2, 2, 12.5);
INSERT INTO portfolio."order_items" ("id", "order_id", "product_id", "quantity", "unit_price") VALUES (8, 7, 6, 1, 8);
COMMIT;
