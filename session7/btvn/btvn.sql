DROP DATABASE IF EXISTS btvn;
CREATE DATABASE btvn;
USE btvn;
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(12,2) NOT NULL
);

CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0)
);

INSERT INTO customers (name, email) VALUES
('Nguyen Van A', 'a@gmail.com'),
('Tran Thi B',   'b@gmail.com'),
('Le Van C',     'c@gmail.com'),
('Pham Thi D',   'd@gmail.com'),
('Hoang Van E',  'e@gmail.com'),
('Do Thi F',     'f@gmail.com'),
('Vu Van G',     'g@gmail.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-03-01', 1500000),
(2, '2025-03-02',  750000),
(1, '2025-03-05', 2200000),
(3, '2025-03-07',  500000),
(4, '2025-03-10', 1800000),
(2, '2025-03-12',  950000),
(5, '2025-03-15', 3000000),
(6, '2025-03-18', 1200000);

INSERT INTO products (name, price) VALUES
('Whey Protein', 1200000),
('Tham Yoga',     350000),
('Ta tay',        250000),
('Binh nuoc',     150000),
('Giay chay bo', 1800000),
('Ao the thao',   300000),
('Dong ho sport',2200000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 5),
(1, 2, 3),
(2, 1, 4),
(3, 3, 6),
(4, 5, 2),
(5, 6, 10),
(6, 7, 1),
(7, 4, 8);

#cau 1
select  * from customers where id in ( select customer_id from orders);

#cau 2
select * from products where id in (select product_id from order_items);

#cau 3
select  * from orders where total_amount > (select avg(total_amount) from orders);

#cau 4
select name, (select count(*) from orders where orders.customer_id = customers.id) as 'số lượng đơn' from customers;

#cau 5
-- select id, (select sum(total_amount) from orders where orders.customer_id = customers.id) as tong_tien_mua
-- from customers;

select * from customers
where id in (select customer_id from orders group by customer_id
    having sum(total_amount) = (select max(Tong_tien)
        from(select sum(total_amount) as Tong_tien from orders group by customer_id) as t)
);

#cau 6
select customer_id, sum(total_amount) as tong_tien from orders
group by customer_id having tong_tien> ( select avg(tong_khach)
    from (select sum(total_amount) as tong_khach
        from orders group by customer_id) as t);
