USE retailpulse;


-- ============================================
-- 1. TOTAL REVENUE
-- ============================================

SELECT
    ROUND(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100)
        ),
        2
    ) AS total_revenue

FROM order_items oi;


-- ============================================
-- 2. TOP 5 PRODUCTS BY REVENUE
-- ============================================

SELECT
    p.product_name,

    ROUND(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100)
        ),
        2
    ) AS revenue

FROM products p

JOIN order_items oi
    ON p.product_id = oi.product_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY revenue DESC

LIMIT 5;


-- ============================================
-- 3. TOP CUSTOMERS
-- ============================================

SELECT
    c.customer_name,

    ROUND(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100)
        ),
        2
    ) AS total_spending

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY total_spending DESC

LIMIT 5;


-- ============================================
-- 4. STORE PERFORMANCE
-- ============================================

SELECT
    s.store_name,

    COUNT(DISTINCT o.order_id)
        AS total_orders,

    ROUND(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100)
        ),
        2
    ) AS revenue

FROM stores s

LEFT JOIN orders o
    ON s.store_id = o.store_id

LEFT JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY
    s.store_id,
    s.store_name

ORDER BY revenue DESC;


-- ============================================
-- 5. EMPLOYEE PERFORMANCE
-- ============================================

SELECT
    e.employee_name,
    e.monthly_target,

    COALESCE(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100)
        ),
        0
    ) AS sales_generated,

    CASE

        WHEN COALESCE(
            SUM(
                oi.quantity *
                oi.unit_price *
                (1 - oi.discount_percent / 100)
            ),
            0
        ) >= e.monthly_target

        THEN 'Target Achieved'

        ELSE 'Below Target'

    END AS target_status

FROM employees e

LEFT JOIN orders o
    ON e.employee_id = o.employee_id

LEFT JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY
    e.employee_id,
    e.employee_name,
    e.monthly_target

ORDER BY sales_generated DESC;


-- ============================================
-- 6. RETURN RATE BY PRODUCT
-- ============================================

SELECT
    p.product_name,

    SUM(oi.quantity) AS units_sold,

    COALESCE(
        SUM(r.returned_quantity),
        0
    ) AS units_returned,

    ROUND(
        (
            COALESCE(SUM(r.returned_quantity), 0)
            / NULLIF(SUM(oi.quantity), 0)
        ) * 100,
        2
    ) AS return_rate

FROM products p

JOIN order_items oi
    ON p.product_id = oi.product_id

LEFT JOIN returns r
    ON oi.order_item_id = r.order_item_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY return_rate DESC;


-- ============================================
-- 7. PAYMENT METHOD ANALYSIS
-- ============================================

SELECT
    payment_method,
    COUNT(*) AS order_count,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM orders),
        2
    ) AS percentage_of_orders

FROM orders

GROUP BY payment_method

ORDER BY order_count DESC;


-- ============================================
-- 8. MONTHLY SALES
-- ============================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m')
        AS sales_month,

    ROUND(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100)
        ),
        2
    ) AS monthly_revenue

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY
    DATE_FORMAT(o.order_date, '%Y-%m')

ORDER BY sales_month;


-- ============================================
-- 9. CATEGORY PERFORMANCE
-- ============================================

SELECT
    c.category_name,

    SUM(oi.quantity) AS units_sold,

    ROUND(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100)
        ),
        2
    ) AS revenue

FROM categories c

JOIN products p
    ON c.category_id = p.category_id

JOIN order_items oi
    ON p.product_id = oi.product_id

GROUP BY
    c.category_id,
    c.category_name

ORDER BY revenue DESC;


-- ============================================
-- 10. HIGH-VALUE CUSTOMERS
-- ============================================

SELECT
    c.customer_name,

    ROUND(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100)
        ),
        2
    ) AS spending

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY
    c.customer_id,
    c.customer_name

HAVING spending > 8000

ORDER BY spending DESC;
