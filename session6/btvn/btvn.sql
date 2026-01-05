DROP DATABASE IF EXISTS btvn;
CREATE DATABASE btvn;
USE btvn;

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,        -- Mã khách hàng
    customer_name VARCHAR(100),            -- Tên khách hàng
    city          VARCHAR(50)               -- Thành phố
);

CREATE TABLE orders (
    order_id    INT PRIMARY KEY,            -- Mã đơn hàng
    customer_id INT,                        -- Khách hàng đặt
    order_date  DATE,                       -- Ngày đặt hàng
    status      VARCHAR(30),                -- Trạng thái đơn
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id   INT PRIMARY KEY,          -- Mã sản phẩm
    product_name VARCHAR(100),              -- Tên sản phẩm
    price        DECIMAL(12,2)        -- Giá bán
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,          -- Mã chi tiết đơn
    order_id      INT,                      -- Mã đơn hàng
    product_id    INT,                      -- Mã sản phẩm
    quantity      INT,                      -- Số lượng
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO customers VALUES
(1, 'Nguyen Van An', 'Ha Noi'),
(2, 'Tran Thi Binh',  'Da Nang'),
(3, 'Le Van Cuong',   'Ho Chi Minh'),
(4, 'Pham Thi Dao',   'Ha Noi'),
(5, 'Hoang Van Em',   'Can Tho');

INSERT INTO orders VALUES
(101, 1, '2025-01-05', 'Completed'),
(102, 2, '2025-01-06', 'Completed'),
(103, 3, '2025-01-07', 'Completed'),
(104, 1, '2025-01-08', 'Completed'),
(105, 4, '2025-01-09', 'Completed'),
(106, 5, '2025-01-10', 'Completed'),
(107, 2, '2025-01-11', 'Completed'),
(108, 3, '2025-01-12', 'Completed');

INSERT INTO products VALUES
(1, 'Laptop Dell',          20000000),
(2, 'iPhone 15',            25000000),
(3, 'Tai nghe Bluetooth',    1500000),
(4, 'Chuột không dây',        500000),
(5, 'Bàn phím cơ',           2000000);

INSERT INTO order_items VALUES
-- Đơn 101
(1, 101, 1, 1 ),
(2, 101, 3, 2),

-- Đơn 102
(3, 102, 2, 1),
(4, 102, 4, 1),

-- Đơn 103
(5, 103, 5, 2),
(6, 103, 3, 1),

-- Đơn 104
(7, 104, 1, 1),
(8, 104, 5, 1),

-- Đơn 105
(9, 105, 4, 3),

-- Đơn 106
(10, 106, 3, 5),

-- Đơn 107
(11, 107, 2, 1),
(12, 107, 3, 2),

-- Đơn 108
(13, 108, 1, 1),
(14, 108, 4, 2);
# cau 1
-- select o.order_id, o.order_date, o.status, c.customer_name
-- from orders o 
-- join customers c on o.customer_id = c.customer_id;

-- select c.customer_id, c.customer_name, count(o.order_id)
-- from customers c
-- join orders o on c.customer_id = o.customer_id group by c.customer_id, c.customer_name;

# cau 2
alter table orders add total_amount decimal(10,2);

update orders set total_amount = 2500000 where order_id = 101;
UPDATE orders SET total_amount = 1800000 WHERE order_id = 102;
UPDATE orders SET total_amount = 3200000 WHERE order_id = 103;
UPDATE orders SET total_amount = 1500000 WHERE order_id = 104;
UPDATE orders SET total_amount = 4100000 WHERE order_id = 105;

-- select c.customer_id, c.customer_name, sum(o.total_amount)
-- from customers c
-- join orders o on c.customer_id = o.customer_id group by c.customer_id, c.customer_name
-- order by sum(o.total_amount) DESC;

-- select c.customer_id, c.customer_name, max(o.total_amount)
-- from customers c
-- join orders o on c.customer_id = o.customer_id group by c.customer_id, c.customer_name;

# cau 3

-- select order_date, count(order_id) as So_don_hang, sum(total_amount) as Tong_doan_thu
-- from orders group by order_date having sum(total_amount) > 1000000;

# cau 4

-- select p.product_id, p.product_name, sum(oi.quantity) as 'da ban'
-- from products p
-- join order_items oi on p.product_id = oi.product_id group by p.product_id, p.product_name;

-- select p.product_id, p.product_name, sum(oi.quantity * p.price) as 'doanh thu'
-- from products p
-- join order_items oi on p.product_id = oi.product_id group by p.product_id, p.product_name;

-- select p.product_id, p.product_name, sum(oi.quantity * p.price) AS 'tong doanh thu'
-- from products p
-- join order_items oi on p.product_id = oi.product_id group by p.product_id, p.product_name having sum(oi.quantity * p.price) > 5000000;

# cau 5

-- select c.customer_id, c.customer_name, count(o.order_id) as 'tong so don', sum(o.total_amount) as 'tong tien', avg(o.total_amount) as 'trung binh'
-- from customers c
-- join orders o on c.customer_id = o.customer_id group by c.customer_id, c.customer_name
-- having count(o.order_id) >= 3 and sum(o.total_amount) > 1000000
-- order by sum(o.total_amount) desc;

# cau 6

-- select p.product_name, sum(oi.quantity) as 'so luong ban', sum(oi.quantity * p.price) as 'tong doan thu', avg(p.price) as 'trung binh'
-- from products p
-- join order_items oi on p.product_id = oi.product_id group by p.product_id, p.product_name
-- having sum(oi.quantity) >= 10 order by 'tong doan thu' desc limit 5;

