USE retailpulse;

-- Q1: Display all customers
SELECT *
FROM customers;


-- Q2: Display unique customer segments
SELECT DISTINCT customer_segment
FROM customers;


-- Q3: Display products costing more than 2000
SELECT
    product_name,
    unit_cost,
    selling_price
FROM products
WHERE unit_cost > 2000;


-- Q4: Products priced between 1000 and 3000
SELECT
    product_name,
    selling_price
FROM products
WHERE selling_price BETWEEN 1000 AND 3000;


-- Q5: Customers from selected cities
SELECT
    customer_name,
    city
FROM customers
WHERE city IN ('Agra', 'Delhi', 'Pune');


-- Q6: Products containing the word "Pro"
SELECT
    product_name
FROM products
WHERE product_name LIKE '%Pro%';


-- Q7: Employees without managers
SELECT
    employee_name
FROM employees
WHERE manager_id IS NULL;


-- Q8: Total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;


-- Q9: Average product selling price
SELECT
    AVG(selling_price) AS average_price
FROM products;


-- Q10: Highest product price
SELECT
    MAX(selling_price) AS highest_price
FROM products;


-- Q11: Lowest product price
SELECT
    MIN(selling_price) AS lowest_price
FROM products;


-- Q12: Number of products in every category
SELECT
    category_id,
    COUNT(*) AS product_count
FROM products
GROUP BY category_id;


-- Q13: Average selling price by category
SELECT
    category_id,
    AVG(selling_price) AS average_price
FROM products
GROUP BY category_id;


-- Q14: Categories having more than 2 products
SELECT
    category_id,
    COUNT(*) AS product_count
FROM products
GROUP BY category_id
HAVING COUNT(*) > 2;


-- Q15: Product profit
SELECT
    product_name,
    selling_price - unit_cost AS profit_per_unit
FROM products;


-- Q16: Product margin classification
SELECT
    product_name,
    selling_price - unit_cost AS profit,
    CASE
        WHEN selling_price - unit_cost >= 2500
            THEN 'High Margin'
        WHEN selling_price - unit_cost >= 1000
            THEN 'Medium Margin'
        ELSE 'Low Margin'
    END AS margin_category
FROM products;


-- Q17: Orders by payment method
SELECT
    payment_method,
    COUNT(*) AS total_orders
FROM orders
GROUP BY payment_method;


-- Q18: Orders by status
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;


-- Q19: Customer signup timeline
SELECT
    customer_name,
    signup_date
FROM customers
ORDER BY signup_date;


-- Q20: Top 5 expensive products
SELECT
    product_name,
    selling_price
FROM products
ORDER BY selling_price DESC
LIMIT 5;
