DROP DATABASE IF EXISTS retest;
CREATE DATABASE retest;
USE retest;
create table customers(
	customer_id varchar(10) primary key,
    full_name varchar(100) not null,
    phone varchar(15) not null unique,
    address varchar(200) not null
);

create table insuranceAgents(
	agent_id varchar(10) primary key,
    full_name varchar(100) not null,
    region varchar(50) not null,
    years_of_experience int, check(years_of_experience>=0),
    commission_rate decimal(5,2), check(commission_rate>=0)
);

create table policies(
	policy_id int primary key auto_increment,
	customer_id varchar(10) not null,
	agent_id varchar(10) not null,
	start_date TIMESTAMP NOT NULL,
	end_date TIMESTAMP NOT NULL,
	status ENUM('Active', 'Expired','Cancelled'),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	FOREIGN KEY (agent_id) REFERENCES insuranceAgents(agent_id)
);

create table claimPayments(
	payment_id INT primary key auto_increment,
	policy_id INT not null,
	payment_method VARCHAR(50) NOT NULL,
	payment_date TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
	amount DECIMAL(15, 2), CHECK(amount >= 0),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

insert into customers( customer_id, full_name ,phone ,address) values
('C001 ','Nguyen Van An ',0912345678,' Hanoi, Vietnam '),
('C002 ','Tran Thi Binh ',0923456789,' Ho Chi Minh, Vietnam '),
('C003 ','Le Minh Chau ',0934567890,' Da Nang,Vietnam '),
('C004 ','Pham Hoang Duc ',0945678901,' Can Tho, Vietnam '),
('C005 ','Vu Thi Hoa ',0956789012,' Hai Phong, Vietnam ');

insert into insuranceAgents(agent_id, full_name ,region ,years_of_experience ,commission_rate )values
('A001 ','Nguyen Van Minh ','Mien Bac ',10, 5.50),
('A002 ','Tran Thi Lan ','Mien Nam ',15, 7.00),
('A003 ','Le Hoang Nam ','Mien Trung ',8, 4.50),
('A004 ','Pham Quang Huy ','Mien Tay ',20, 8.00),
('A005 ','Vu Thi Mai ','Mien Bac ',5, 3.50);

-- insert into policies(customer_id ,agent_id ,start_date ,end_date) values
-- ('C001',' A001 ','2024-01-01 08:00:00 ','2025-01-01 08:00:00'),
-- ('C002',' A002 ','2024-02-01 09:30:00 ','2025-02-01 09:30:00'),
-- ('C003',' A003 ','2023-03-02 10:00:00 ','2024-03-02 10:00:00'),
-- ('C004',' A004 ','2024-05-02 14:00:00 ','2025-05-02 14:00:00'),
-- ('C005',' A005 ','2024-06-03 15:30:00 ','2025-06-03 15:30:00');

-- insert into claimPayments(policy_id, payment_method, payment_date, amount) values
-- (1, 'Bank Transfer ','2024-05-01 08:45:00 ', 5000000.00),
-- (2, 'Bank Transfer ','2024-05-01 08:45:00 ', 5000000.00),
-- (4, 'Bank Transfer ','2024-05-01 08:45:00 ', 5000000.00),
-- (1, 'Bank Transfer ','2024-05-01 08:45:00 ', 5000000.00),
-- (3, 'Bank Transfer ','2024-05-01 08:45:00 ', 5000000.00);

update customers set address = 'District 1, Ho Chi Minh City' where customer_id = 'C002';
update insuranceAgents set years_of_experience = 
