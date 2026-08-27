USE retailpulse;

-- Q1: Products priced above average
SELECT
    product_name,
    selling_price
FROM products
WHERE selling_price >
(
    SELECT AVG(selling_price)
    FROM products
);


-- Q2: Most expensive product
SELECT
    product_name,
    selling_price
FROM products
WHERE selling_price =
(
    SELECT MAX(selling_price)
    FROM products
);


-- Q3: Customers who have placed orders
SELECT
    customer_name
FROM customers
WHERE customer_id IN
(
    SELECT customer_id
    FROM orders
);


-- Q4: Customers who have never ordered
SELECT
    customer_name
FROM customers
WHERE customer_id NOT IN
(
    SELECT customer_id
    FROM orders
);


-- Q5: Products more expensive than their category average
SELECT
    p.product_name,
    p.selling_price,
    p.category_id
FROM products p
WHERE p.selling_price >
(
    SELECT AVG(p2.selling_price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);


-- Q6: Customers with spending above average customer spending
SELECT
    c.customer_name
FROM customers c
WHERE
(
    SELECT COALESCE(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100)
        ), 0
    )
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.customer_id = c.customer_id
)
>
(
    SELECT AVG(customer_total)
    FROM
    (
        SELECT
            o.customer_id,
            SUM(
                oi.quantity *
                oi.unit_price *
                (1 - oi.discount_percent / 100)
            ) AS customer_total
        FROM orders o
        JOIN order_items oi
            ON o.order_id = oi.order_id
        GROUP BY o.customer_id
    ) AS spending
);


-- Q7: Stores with more orders than average
SELECT
    store_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY store_id
HAVING COUNT(*) >
(
    SELECT AVG(store_orders)
    FROM
    (
        SELECT
            store_id,
            COUNT(*) AS store_orders
        FROM orders
        GROUP BY store_id
    ) AS store_summary
);


-- Q8: Products that have been returned
SELECT
    product_name
FROM products
WHERE EXISTS
(
    SELECT 1
    FROM order_items oi
    JOIN returns r
        ON oi.order_item_id = r.order_item_id
    WHERE oi.product_id = products.product_id
);


-- Q9: Products that have never been returned
SELECT
    product_name
FROM products p
WHERE NOT EXISTS
(
    SELECT 1
    FROM order_items oi
    JOIN returns r
        ON oi.order_item_id = r.order_item_id
    WHERE oi.product_id = p.product_id
);
