DROP DATABASE IF EXISTS retailpulse;

CREATE DATABASE retailpulse;

USE retailpulse;

-- ============================================
-- 1. CATEGORIES
-- ============================================

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE = InnoDB;


-- ============================================
-- 2. STORES
-- ============================================

CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    store_type VARCHAR(30) NOT NULL,
    opening_date DATE NOT NULL,

    CONSTRAINT chk_store_type
        CHECK (store_type IN ('Mall', 'High Street', 'Neighborhood'))
) ENGINE = InnoDB;


-- ============================================
-- 3. CUSTOMERS
-- ============================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    city VARCHAR(50) NOT NULL,
    customer_segment VARCHAR(30) NOT NULL,
    signup_date DATE NOT NULL,

    CONSTRAINT chk_customer_segment
        CHECK (
            customer_segment IN
            ('Regular', 'Premium', 'Business')
        )
) ENGINE = InnoDB;


-- ============================================
-- 4. PRODUCTS
-- ============================================

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    CONSTRAINT chk_product_cost
        CHECK (unit_cost >= 0),

    CONSTRAINT chk_product_price
        CHECK (selling_price >= unit_cost),

    CONSTRAINT chk_stock
        CHECK (stock_quantity >= 0)
) ENGINE = InnoDB;


-- ============================================
-- 5. EMPLOYEES
-- ============================================

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    store_id INT NOT NULL,
    manager_id INT NULL,
    monthly_target DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_employee_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id),

    CONSTRAINT fk_employee_manager
        FOREIGN KEY (manager_id)
        REFERENCES employees(employee_id),

    CONSTRAINT chk_employee_target
        CHECK (monthly_target >= 0)
) ENGINE = InnoDB;


-- ============================================
-- 6. ORDERS
-- ============================================

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    store_id INT NOT NULL,
    employee_id INT NOT NULL,
    order_date DATE NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    order_status VARCHAR(30) NOT NULL,

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_order_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id),

    CONSTRAINT fk_order_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id),

    CONSTRAINT chk_payment_method
        CHECK (
            payment_method IN
            ('UPI', 'Card', 'Cash', 'Net Banking')
        ),

    CONSTRAINT chk_order_status
        CHECK (
            order_status IN
            ('Completed', 'Cancelled', 'Pending')
        )
) ENGINE = InnoDB;


-- ============================================
-- 7. ORDER ITEMS
-- ============================================

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_percent DECIMAL(5,2) DEFAULT 0,

    CONSTRAINT fk_item_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_item_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT chk_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_item_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_discount
        CHECK (
            discount_percent >= 0
            AND discount_percent <= 100
        )
) ENGINE = InnoDB;


-- ============================================
-- 8. RETURNS
-- ============================================

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_item_id INT NOT NULL,
    return_date DATE NOT NULL,
    returned_quantity INT NOT NULL,
    return_reason VARCHAR(100) NOT NULL,

    CONSTRAINT fk_return_item
        FOREIGN KEY (order_item_id)
        REFERENCES order_items(order_item_id),

    CONSTRAINT chk_return_quantity
        CHECK (returned_quantity > 0)
);


-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_orders_customer
ON orders(customer_id);

CREATE INDEX idx_orders_store
ON orders(store_id);

CREATE INDEX idx_orders_date
ON orders(order_date);

CREATE INDEX idx_order_items_product
ON order_items(product_id);

CREATE INDEX idx_returns_item
ON returns(order_item_id);
