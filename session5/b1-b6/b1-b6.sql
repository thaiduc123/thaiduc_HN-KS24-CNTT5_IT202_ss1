DROP DATABASE IF EXISTS btvn;
CREATE DATABASE btvn;
USE btvn;

create table products (
	product_id int primary key auto_increment,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT,
    status enum('ACTIVE', 'INACTIVE'),
    sold_quantity int default 0
);

create table customer(
	customer_id int primary key auto_increment,
    full_name varchar(255),
    email varchar(255),
    city varchar(255),
    status enum('ACTIVE', 'INACTIVE')
);

create table orders (
	order_id int primary key auto_increment,
    customer_id int not null,
    total_amount decimal(10,2),
    order_date date,
    status enum('pending', 'completed', 'cancelled'),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

INSERT INTO products (product_name, price, stock, status, sold_quantity) VALUES
('Laptop', 15000, 10, 'ACTIVE', 95),
('Mouse', 20, 100, 'ACTIVE', 420),
('Keyboard', 50, 50, 'ACTIVE', 310),
('Monitor', 3000, 20, 'ACTIVE', 180),
('Printer', 2000, 0, 'INACTIVE', 75),
('USB Cable', 100, 200, 'ACTIVE', 560),
('Webcam', 800, 15, 'ACTIVE', 140),
('Headphone', 120, 0, 'INACTIVE', 260),
('Tablet', 6000, 8, 'ACTIVE', 210),
('Speaker', 150, 12, 'ACTIVE', 190),
('SSD 512GB', 2500, 40, 'ACTIVE', 50),
('SSD 1TB', 4200, 25, 'ACTIVE', 25),
('RAM 8GB', 1200, 60, 'ACTIVE', 202),
('RAM 16GB', 2200, 45, 'ACTIVE', 101),
('Power Supply 650W', 1800, 30, 'ACTIVE', 100),
('Mainboard B560', 3200, 20, 'ACTIVE', 50),
('Mainboard Z690', 5500, 15, 'ACTIVE', 50),
('CPU Intel i5', 6500, 18, 'ACTIVE', 69),
('CPU Intel i7', 9800, 10, 'ACTIVE', 67),
('CPU AMD Ryzen 5', 6200, 22, 'ACTIVE', 36);

INSERT INTO customer (full_name, email, city, status) VALUES
('Thai Hong Duc', 'thd@gmail.com', 'HA NOI', 'ACTIVE'),
('Nguyen Van An', 'an.nguyen@gmail.com', 'HA NOI', 'ACTIVE'),
('Tran Thi Bich', 'bich.tran@gmail.com', 'HA NOI', 'INACTIVE'),
('Le Minh Quan', 'quan.le@gmail.com', 'DA NANG', 'ACTIVE'),
('Pham Thu Ha', 'ha.pham@gmail.com', 'HA NOI', 'ACTIVE'),
('Vo Tuan Kiet', 'kiet.vo@gmail.com', 'TP HCM', 'ACTIVE'),
('Do Thi Mai', 'mai.do@gmail.com', 'HA NOI', 'INACTIVE'),
('Nguyen Hoang Long', 'long.nguyen@gmail.com', 'DA NANG', 'ACTIVE'),
('Bui Thanh Tung', 'tung.bui@gmail.com', 'TP HCM', 'ACTIVE'),
('Hoang Anh Tuan', 'tuan.hoang@gmail.com', 'HA NOI', 'ACTIVE');

INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES
(1, 1200000, '2024-01-05', 'completed'),
(2, 2500000, '2024-01-10', 'pending'),
(3, 800000,  '2024-01-12', 'cancelled'),
(4, 5400000, '2024-01-15', 'completed'),
(5, 3200000, '2024-01-18', 'completed'),
(6, 1500000, '2024-01-20', 'pending'),
(7, 6700000, '2024-01-22', 'completed'),
(8, 2300000, '2024-01-25', 'pending'),
(9, 4100000, '2024-01-28', 'completed'),
(10, 950000, '2024-01-30', 'cancelled');

#cau1
-- SELECT * FROM products;
-- SELECT * FROM products WHERE status = 'active';
-- SELECT * FROM products WHERE price > 10000;
-- SELECT * FROM products WHERE status = 'active' ORDER BY price ASC;

#cau2
-- select * from customer order by full_name asc;
-- select * from customer where city = 'TP HCM';
-- select * from customer where status = 'ACTIVE' and city = 'HA NOI';

#cau3
-- select * from orders;
-- select * from orders where status = 'completed' order by total_amount desc;
-- select * from orders where total_amount > 5000000;
-- select * from orders order by order_date desc limit 5;

#cau4
-- SELECT * FROM products ORDER BY sold_quantity DESC LIMIT 10;
-- SELECT * FROM products ORDER BY sold_quantity DESC LIMIT 5 OFFSET 10;
-- SELECT * FROM products WHERE price < 2000000 ORDER BY sold_quantity DESC;

#cau5
-- SELECT * FROM orders WHERE status <> 'cancelled' ORDER BY order_date DESC LIMIT 5;
-- SELECT * FROM orders WHERE status <> 'cancelled' ORDER BY order_date DESC LIMIT 5 OFFSET 5;
-- SELECT * FROM orders WHERE status <> 'cancelled' ORDER BY order_date DESC LIMIT 5 OFFSET 10;

#cau6
-- SELECT * FROM products
-- WHERE status = 'ACTIVE'
--   AND price BETWEEN 1000 AND 3000
-- ORDER BY price ASC LIMIT 10;
-- SELECT * FROM products
-- WHERE status = 'ACTIVE'
--   AND price BETWEEN 1000 AND 3000
-- ORDER BY price ASC LIMIT 10 OFFSET 10;

