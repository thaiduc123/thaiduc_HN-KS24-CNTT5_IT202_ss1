-- cau 1

DROP DATABASE IF EXISTS project;
CREATE DATABASE project;
USE project;

CREATE TABLE Reader(
	reader_id int primary key auto_increment,
    reader_name varchar(100) not null,
    phone varchar(15) unique,
    register_date date default(current_date)
);

CREATE TABLE Book(
	book_id int primary key,
    book_title varchar(150) not null,
    author varchar(100),
    publish_year int check(publish_year>=1900)
);

CREATE TABLE Borrow(
	reader_id int,
    book_id int,
    borrow_date date default(current_date),
    return_date date,
    CONSTRAINT pk_borrow primary key (reader_id, book_id),
    CONSTRAINT fk_borrow_reader foreign key (reader_id) references Reader(reader_id),
    CONSTRAINT fk_borrow_book foreign key (book_id) references Book(book_id),
    CONSTRAINT check_borrow_return check (return_date >= borrow_date)
);

-- cau 2

ALTER TABLE Reader add email varchar(100) unique;
ALTER TABLE Book modify author varchar(150);

-- cau 3

INSERT INTO Reader (reader_name, phone, email, register_date)
VALUE 
('Nguyễn Văn An', 0901234567, 'an.nguyen@gmail.com', '2024-09-01'),
('Trần Thị Bình', 0912345678, 'binh.tran@gmail.com', '2024-09-05'),
('Lê Minh Châu', 0923456789, 'chau.le@gmail.com', '2024-09-10');

INSERT INTO Book (book_id, book_title, author, publish_year)
VALUE 
(101, 'Lập trình C căn bản', 'Nguyễn Văn A', 2018),
(102, 'Cơ sở dữ liệu', 'Trần Thị B', 2020),
(103, 'Lập trình Java', 'Lê Minh C', 2019),
(104, 'Hệ quản trị MySQL', 'Phạm Văn D', 2021);

INSERT INTO Borrow (reader_id, book_id, borrow_date, return_date)
VALUE 
(1, 101, '2024-09-15', null),
(2, 102, '2024-09-15', '2024-09-25'),
(3, 103, '2024-09-18', null);

UPDATE Borrow
SET return_date = '2024-10-01'
WHERE reader_id = 1;

UPDATE Book
SET publish_year = 2023
WHERE publish_year >= 2021;

DELETE FROM Borrow
WHERE borrow_date < '2024-09-18';

SELECT * FROM Reader;
SELECT * FROM Book;
SELECT * FROM Borrow;