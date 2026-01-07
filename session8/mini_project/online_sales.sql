DROP DATABASE if exists online_sales;
CREATE DATABASE online_sales;
USE online_sales;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(10) NOT NULL UNIQUE
);

INSERT INTO customers (customer_name, email, phone) VALUES
('Nguyen Van A', 'a@gmail.com', '0901111111'),
('Tran Thi B', 'b@gmail.com', '0902222222'),
('Le Van C', 'c@gmail.com', '0903333333'),
('Pham Thi D', 'd@gmail.com', '0904444444');

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO categories (category_name) VALUES
('Điện thoại'),
('Laptop'),
('Phụ kiện'),
('Thiết bị gia dụng');

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

INSERT INTO products (product_name, price, category_id) VALUES
('iPhone 15', 25000000, 1),
('Samsung Galaxy S23', 22000000, 1),
('MacBook Air M2', 32000000, 2),
('Dell XPS 13', 28000000, 2),
('Tai nghe Bluetooth', 1500000, 3),
('Sạc nhanh 65W', 900000, 3),
('Máy hút bụi', 4500000, 4),
('Nồi chiên không dầu', 3500000, 4);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Completed', 'Cancel') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders (customer_id, status) VALUES
(1, 'Completed'),
(1, 'Completed'),
(2, 'Pending'),
(3, 'Completed'),
(3, 'Cancel'),
(4, 'Completed');

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 5, 2),

(2, 3, 1),
(2, 6, 1),

(3, 2, 1),

(4, 4, 1),
(4, 5, 1),
(4, 6, 2),

(5, 7, 1),

(6, 8, 2),
(6, 5, 1);

-- A
SELECT * FROM categories;

SELECT * FROM orders WHERE status = 'Completed';

select * FROM products 
order by price desc;


select * FROM products 
order by price desc
limit 5 offset 2;

-- B
SELECT p.*, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id;

select o.order_id, o.order_date, c.customer_name, o.status
from orders o 
join customers c on o.customer_id = c.customer_id;

select o.order_id, sum(oi.quantity) as total_quantity
from orders o
join order_items oi on o.order_id = oi.order_id
group by o.order_id;

SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 2;

SELECT c.category_name,
       AVG(p.price) AS avg_price,
       MIN(p.price) AS min_price,
       MAX(p.price) AS max_price
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name;

SELECT *
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

SELECT *
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM orders
);

SELECT order_id, SUM(quantity) AS total_quantity
FROM order_items
GROUP BY order_id
ORDER BY total_quantity DESC
LIMIT 1;

-- C
select * from products
where price > (select avg(price) from products);

select * from customers
where customer_id in (select customer_id from orders);

select * from orders
where order_id = (select order_id from order_items group by order_id order by sum(quantity) desc limit 1);

select customer_name from customers
where customer_id in (select o.customer_id from orders o
    join order_items oi on o.order_id = oi.order_id
    join products p on oi.product_id = p.product_id
    where p.category_id = (select category_id from products
        group by category_id order by avg(price) desc limit 1));
	
select t.customer_id, t.customer_name, sum(t.quantity) as total
from (select c.customer_id, c.customer_name, oi.quantity from customers c 
	join orders o on c.customer_id = o.customer_id
    join order_items oi on o.order_id = oi.order_id) as t
group by t.customer_id, t.customer_name;

select * from products
where price = (select max(price) from products);
