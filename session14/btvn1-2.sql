DROP DATABASE IF EXISTS btvn;
CREATE DATABASE btvn;
USE btvn;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    account_name VARCHAR(50),
    balance DECIMAL(10,2)
);
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    price DECIMAL(10,2),
    stock INT NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE company_funds (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15,2) NOT NULL -- Số dư quỹ công ty
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,   -- Tên nhân viên
    salary DECIMAL(10,2) NOT NULL    -- Lương nhân viên
);

CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,                      -- ID nhân viên (FK)
    salary DECIMAL(10,2) NOT NULL,   -- Lương được nhận
    pay_date DATE NOT NULL,          -- Ngày nhận lương
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);


INSERT INTO company_funds (balance) VALUES (50000.00);

INSERT INTO employees (emp_name, salary) VALUES
('Nguyễn Văn An', 5000.00),
('Trần Thị Bốn', 4000.00),
('Lê Văn Cường', 3500.00),
('Hoàng Thị Dung', 4500.00),
('Phạm Văn Em', 3800.00);

INSERT INTO products (product_name, price, stock) VALUES
('Laptop Dell', 1500.00, 10),
('iPhone 13', 1200.00, 8),
('Samsung TV', 800.00, 5),
('AirPods Pro', 250.00, 20),
('MacBook Air', 1300.00, 7);

INSERT INTO accounts (account_name, balance) VALUES 
('Nguyễn Văn An', 1000.00),
('Trần Thị Bảy', 500.00);

-- cau 1
delimiter //
create procedure transfer_money(in from_account int, in to_account int, in amount decimal(10,2))
BEGIN
    declare from_balance decimal(10,2);
    start transaction;
    select balance into from_balance from accounts where account_id = from_account;
    if from_balance >= amount then
        update accounts set balance = balance - amount where account_id = from_account;
        update accounts set balance = balance + amount where account_id = to_account;
        commit;
    else
        rollback;
    end if;
END //
delimiter ;
call transfer_money(1, 2, 200.00);
-- SELECT * FROM accounts;

-- cau 2
delimiter //
create procedure place_order(in p_product_id int, in p_quantity int)
BEGIN
    declare current_stock int;
    declare product_price decimal(10,2);
    declare total_cost decimal(10,2);
    start transaction;
    select stock, price into current_stock, product_price from products where product_id = p_product_id;
    if current_stock >= p_quantity then 
        set total_cost = product_price * p_quantity;
        insert into orders (product_id, quantity, total_price) values (p_product_id, p_quantity, total_cost);
        update products set stock = stock - p_quantity where product_id = p_product_id;
        commit;
    else 
        rollback;
    end if;
END //
delimiter ;
CALL place_order(2, 2);
-- SELECT * FROM orders;
-- SELECT * FROM products;

