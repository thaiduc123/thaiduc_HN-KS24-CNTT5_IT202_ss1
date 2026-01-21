DROP DATABASE IF EXISTS online_shoping;
CREATE DATABASE online_shoping;
use online_shoping;

-- PHẦN 1: DDL – THIẾT KẾ CSDL
create table shippers (
	shipper_id int primary key auto_increment,
	full_name varchar(50) not null,
	phone_number varchar(20) unique not null,
	license_type varchar(10) not null,
	rating float default (5.0) check (rating between 0.0 and 5.0)
);

create table vehicle_details (
	vehicle_id	varchar(20) primary key,
	shipper_id int not null,
	license_plate varchar(20) not null unique,
	vehicle_type varchar(20) not null, 
	max_payload int not null check (max_payload>0),
    foreign key (shipper_id) references shippers(shipper_id)
);

create table shipments (
	shipment_id varchar(20) primary key,
	product_name varchar (50) not null,
	weight float not null check (weight >0),
	goods_value decimal(10,2) check (goods_value >=0),
	status varchar (20) not null
);

create table delivery_orders(
	order_id varchar(20) primary key,
	shipment_id varchar(20) not null,
	shipper_id int not null,
	order_date datetime default current_timestamp,
	delivery_fee decimal(10,2) check (delivery_fee >=0),
    status varchar (20) not null,
    foreign key (shipper_id) references shippers(shipper_id),
    foreign key (shipment_id) references shipments(shipment_id)
);

create table delivery_log(
	log_id int primary key auto_increment,
	order_id varchar(20) not null,
	current_location varchar(50) not null,
	log_time datetime not null,
	note text,
    foreign key (order_id) references delivery_orders(order_id)
);

-- PHẦN 2: DML – INSERT, UPDATE, DELETE
insert into shippers (full_name, phone_number, license_type, rating) values 
('Nguyen Van An','0901234567','C',4.8),
('Tran Thi Binh','0912345678','A2',5),
('Le Hoang Nam','0983456789','FC',4.2),
('Pham Minh Duc','0354567890','B2',4.9),
('Hoang Quoc Viet','0775678901','C',4.7);

insert into vehicle_details(vehicle_id, shipper_id,license_plate,vehicle_type,max_payload) values
('101',1,'29C-123.45','Truck',3500),
('102',2,'59A-888.88','Motorbike',500),
('103',3,'15R-999.99','Container',32000),
('104',4,'30F-111.22','Truck',1500),
('105',5,'43C-444.55','Truck',5000);

insert into shipments(shipment_id, product_name, weight, goods_value, status) values 
('5001','Smart TV Samsung 55 inch',25.5,1500000.00,'In Transit'),
('5002','Laptop Dell XPS',2,3500000.00,'Delivered'),
('5003','Industrial Air Compressor',450,12000000.00,'In Transit'),
('5004','Imported Fruit Boxes',15,250000.00,'Returned'),
('5005','LG Inverter Washing Machine',70,950000.00,'In Transit');

insert into delivery_orders(order_id, shipment_id, shipper_id, order_date, delivery_fee, status) values 
('9001','5001', 1,'2024-05-20 8:00',2000000.00,'Processing'),
('9002','5002', 2,'2024-05-20 9:30',3500000.00,'Finished'),
('9003','5003', 3,'2024-05-20 10:15',2500000.00,'Processing'),
('9004','5004', 5,'2024-05-21 7:00',1500000.00,'Finished'),
('9005','5005', 4,'2024-05-21 8:45',2500000.00,'Pending');

insert into delivery_log(order_id, current_location, log_time, note) values 
('9001','Main Warehouse - Hanoi','2024-05-15 8:15','Departed'),
('9001','Phu Ly Toll Station','2024-05-17 10:00','In transit'),
('9002','District 1 - HCM','2024-05-19 10:30','Arrived'),
('9003','Hai Phong Port','2024-05-20 11:00','Departed'),
('9004','Return Warehouse - Da Nang','2024-05-21 14:00','Returned');

-- Câu 2 – UPDATE & DELETE
update delivery_orders set delivery_fee = delivery_fee * 1.1 where status = 'Finished' 
and shipment_id in (select shipment_id from shipments where weight>100);
delete from delivery_log where log_time < '2024-05-17';

-- PHẦN 3: TRUY VẤN CƠ BẢN
-- cau 1
select license_plate, vehicle_type, max_payload
from vehicle_details where max_payload > 5000 or vehicle_type = 'Container';
-- cau 2
select full_name, phone_number from shippers 
where rating between 4.5 and 5.0 and phone_number like '090%';
-- cau 3
select shipment_id, product_name, goods_value 
from shipments order by goods_value desc limit 5 offset 3;

-- PHẦN 4: TRUY VẤN NÂNG CAO
-- cau 1
select s.full_name, d.shipment_id, sh.product_name, d.delivery_fee, d.order_date
from delivery_orders d join shippers s on d.shipper_id = s.shipper_id
join shipments sh on d.shipment_id = sh.shipment_id;
-- cau 2
select s.full_name, sum(d.delivery_fee) as tong_phi from delivery_orders d
join shippers s on d.shipper_id = s.shipper_id group by s.full_name
having sum(d.delivery_fee) > 3000000;
-- cau 3
select shipper_id, full_name, rating from shippers where rating = (select max(rating) from shippers);

-- PHẦN 5: INDEX & VIEW
-- cau 1
create index idx_goods_value on shipments(goods_value);
create index idx_status on shipments(status);
-- cau 2
create or replace view view_shipper as
select s.full_name, count(d.shipper_id), sum(d.delivery_fee)
from shippers s join delivery_orders d on s.shipper_id = d.shipper_id group by s.shipper_id;