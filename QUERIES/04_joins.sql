USE retailpulse;

-- Q1: Orders with customer names
SELECT
    o.order_id,
    c.customer_name,
    o.order_date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;


-- Q2: Orders with store information
SELECT
    o.order_id,
    s.store_name,
    s.city,
    o.order_date
FROM orders o
INNER JOIN stores s
    ON o.store_id = s.store_id;


-- Q3: Orders with employee information
SELECT
    o.order_id,
    e.employee_name,
    o.order_date
FROM orders o
INNER JOIN employees e
    ON o.employee_id = e.employee_id;


-- Q4: Order details with products
SELECT
    o.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;


-- Q5: Revenue by store
SELECT
    s.store_name,
    SUM(
        oi.quantity *
        oi.unit_price *
        (1 - oi.discount_percent / 100)
    ) AS revenue
FROM stores s
JOIN orders o
    ON s.store_id = o.store_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY s.store_id, s.store_name
ORDER BY revenue DESC;


-- Q6: Customer spending
SELECT
    c.customer_name,
    SUM(
        oi.quantity *
        oi.unit_price *
        (1 - oi.discount_percent / 100)
    ) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC;


-- Q7: Product revenue
SELECT
    p.product_name,
    SUM(
        oi.quantity *
        oi.unit_price *
        (1 - oi.discount_percent / 100)
    ) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC;


-- Q8: Customers who have purchased
SELECT DISTINCT
    c.customer_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NOT NULL;


-- Q9: Customers with no orders
SELECT
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Q10: Return information with products
SELECT
    r.return_id,
    p.product_name,
    r.returned_quantity,
    r.return_reason
FROM returns r
JOIN order_items oi
    ON r.order_item_id = oi.order_item_id
JOIN products p
    ON oi.product_id = p.product_id;


-- Q11: Employee sales
SELECT
    e.employee_name,
    SUM(
        oi.quantity *
        oi.unit_price *
        (1 - oi.discount_percent / 100)
    ) AS sales_value
FROM employees e
JOIN orders o
    ON e.employee_id = o.employee_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY e.employee_id, e.employee_name
ORDER BY sales_value DESC;


-- Q12: Employee-manager hierarchy
SELECT
    emp.employee_name AS employee,
    mgr.employee_name AS manager
FROM employees emp
LEFT JOIN employees mgr
    ON emp.manager_id = mgr.employee_id;
