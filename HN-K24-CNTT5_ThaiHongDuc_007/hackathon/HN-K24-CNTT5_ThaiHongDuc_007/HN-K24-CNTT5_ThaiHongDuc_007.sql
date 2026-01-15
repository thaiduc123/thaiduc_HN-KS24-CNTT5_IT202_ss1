DROP DATABASE IF EXISTS hackathon;
CREATE DATABASE hackathon;
USE hackathon;
-- phan 1
#1
create table category(
	category_id varchar(10) primary key,
    category_name varchar(100) not null unique,
    description text
);

create table products(
	 product_id varchar(10) primary key,
     product_name varchar (150) not null,
     price decimal(10,2) not null,
     status varchar(50) not null,
     category_id varchar(10) not null,
     FOREIGN KEY (category_id) REFERENCES category(category_id)
);

create table orders(
	order_id int primary key auto_increment,
    order_date datetime not null,
    total_amount decimal(15,2) not null,
    customer_name varchar(100)
);

create table order_detail(
	detail_id int primary key auto_increment,
    order_id int not null,
    product_id varchar(10) not null,
    quantity int not null,
    subtotal decimal(12,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id) 
);
#2
insert into category(category_id, category_name, description) values
('C01', 'Coffee', 'All types of coffee beans and brews'),
('C02', 'Tea & Fruit', 'Fresh fruit juices and tea'),
('C03', 'Bakery', 'Cakes and pastries'),
('C04', 'Ban', 'ban');

insert into products(product_id, product_name, price, status, category_id) values
('P001', 'Espresso', 35000, 'Available', 'C01'),
('P002', 'Matcha Latte', 45000, 'Available', 'C02'),
('P003', 'Tiramisu', 55000, 'Available', 'C03'),
('P004', 'Cold Brew', 50000, 'Out of stock', 'C01'),
('P005', 'Croissant', 30000, 'Available', 'C03');

insert into orders(order_date, total_amount, customer_name) values
('2025-01-01 08:30:00', 80000, 'Mr.An'),
('2025-01-01 09:15:00', 45000, 'Ms.Hoa'),
('2025-01-02 14:00:00', 140000, 'Mr. Binh'),
('2025-01-03 10:00:00', 35000, 'Anonymous'),
('2025-01-03 11:20:00', 90000, 'Ms. Lan');

insert into order_detail(order_id, product_id, quantity, subtotal) values
(1, 'P001', 1, '35000'),
(1, 'P001', 1, '45000'),
(3, 'P003', 2, '110000'),
(3, 'P005', 1, '30000'),
(5, 'P002', 2, '90000');

#3
update products set status = 'Available' where product_id = 'P004';
#4
update products set price = (products.price + products.price*0.1) where category_id = 'C03';
#5
delete from order_detail where quantity<=0;

-- phan 2
#6
select p.product_id, p.product_name, p.price from products p
where status = 'Available' and price>=40000;

#7
select o.order_id, o.order_date, o.customer_name from orders o
where customer_name like 'M%';

#8
select p.product_name, p.price from products p order by price desc;

#9
select * from orders order by order_date desc limit 3;

#10
select * from products limit 5 offset 2;

-- phan 3
#11
select p.product_name, p.price, c.category_name from products p
join category c on p.category_id = c.category_id;

#12
select c.*, p.* from category c left join products p on p.category_id = c.category_id;

#14
select order_id from order_detail
group by order_id having count(product_id) >= 2;

#15
select product_id, product_name, price from products
where price > (select avg(price) from products);

#16
select o.customer_name from orders o
join order_detail od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
where p.product_name = 'Matcha Latte';

#17
select o.order_id, o.order_date, p.product_name, od.quantity, od.subtotal
from orders o join order_detail od on o.order_id = od.order_id
join products p on od.product_id = p.product_id order by o.order_id;
