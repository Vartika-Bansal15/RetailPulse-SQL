USE retailpulse;

-- ============================================
-- VIEW 1: ORDER REVENUE
-- ============================================

CREATE OR REPLACE VIEW vw_order_revenue AS
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    s.store_name,
    SUM(
        oi.quantity *
        oi.unit_price *
        (1 - oi.discount_percent / 100)
    ) AS order_value
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN stores s
    ON o.store_id = s.store_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.order_date,
    c.customer_name,
    s.store_name;


SELECT *
FROM vw_order_revenue;


-- ============================================
-- VIEW 2: PRODUCT PROFITABILITY
-- ============================================

CREATE OR REPLACE VIEW vw_product_profitability AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.selling_price,
    p.unit_cost,
    p.selling_price - p.unit_cost AS profit_per_unit,
    ROUND(
        (
            (p.selling_price - p.unit_cost)
            / NULLIF(p.selling_price, 0)
        ) * 100,
        2
    ) AS margin_percent
FROM products p
JOIN categories c
    ON p.category_id = c.category_id;


SELECT *
FROM vw_product_profitability;


-- ============================================
-- WINDOW FUNCTION: PRODUCT RANKING
-- ============================================

SELECT
    p.product_name,
    SUM(
        oi.quantity *
        oi.unit_price *
        (1 - oi.discount_percent / 100)
    ) AS revenue,

    RANK() OVER (
        ORDER BY
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100)
        ) DESC
    ) AS revenue_rank

FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id

GROUP BY
    p.product_id,
    p.product_name;


-- ============================================
-- WINDOW FUNCTION: MONTHLY REVENUE
-- ============================================

WITH monthly_sales AS
(
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100)
        ) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)

SELECT
    month,
    revenue,

    LAG(revenue) OVER (
        ORDER BY month
    ) AS previous_month_revenue

FROM monthly_sales
ORDER BY month;


-- ============================================
-- CTE: CUSTOMER TIERS
-- ============================================

WITH customer_spending AS
(
    SELECT
        c.customer_id,
        c.customer_name,

        COALESCE(
            SUM(
                oi.quantity *
                oi.unit_price *
                (1 - oi.discount_percent / 100)
            ),
            0
        ) AS total_spending

    FROM customers c

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id

    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_name,
    total_spending,

    CASE
        WHEN total_spending >= 15000
            THEN 'Platinum'

        WHEN total_spending >= 8000
            THEN 'Gold'

        WHEN total_spending >= 3000
            THEN 'Silver'

        ELSE 'Bronze'
    END AS loyalty_tier

FROM customer_spending
ORDER BY total_spending DESC;


-- ============================================
-- STORED PROCEDURE
-- ============================================

DELIMITER $$

CREATE PROCEDURE GetCustomerSummary(
    IN input_customer_id INT
)

BEGIN

    SELECT
        c.customer_id,
        c.customer_name,
        c.customer_segment,

        COUNT(DISTINCT o.order_id) AS total_orders,

        COALESCE(
            SUM(
                oi.quantity *
                oi.unit_price *
                (1 - oi.discount_percent / 100)
            ),
            0
        ) AS total_spending

    FROM customers c

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id

    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE c.customer_id = input_customer_id

    GROUP BY
        c.customer_id,
        c.customer_name,
        c.customer_segment;

END$$

DELIMITER ;


-- Example
CALL GetCustomerSummary(1);
