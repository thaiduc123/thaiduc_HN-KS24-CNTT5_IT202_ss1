drop database if exists social_network;
create database social_network;
use social_network;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Users (username, password, email) VALUES
('an_nguyen', 'pass123', 'an@gmail.com'), ('binh_le', 'pass123', 'binh@gmail.com'),
('chi_pham', 'pass123', 'chi@gmail.com'), ('dung_tran', 'pass123', 'dung@gmail.com'),
('em_hoang', 'pass123', 'em@gmail.com'), ('giang_vo', 'pass123', 'giang@gmail.com'),
('hoa_dang', 'pass123', 'hoa@gmail.com'), ('khoa_ly', 'pass123', 'khoa@gmail.com'),
('lan_ngo', 'pass123', 'lan@gmail.com'), ('minh_do', 'pass123', 'minh@gmail.com'),
('nam_bui', 'pass123', 'nam@gmail.com'), ('oanh_vu', 'pass123', 'oanh@gmail.com'),
('phuc_le', 'pass123', 'phuc@gmail.com'), ('quang_ha', 'pass123', 'quang@gmail.com'),
('son_trinh', 'pass123', 'son@gmail.com'), ('thu_nguyen', 'pass123', 'thu@gmail.com'),
('uy_phan', 'pass123', 'uy@gmail.com'), ('viet_hoang', 'pass123', 'viet@gmail.com'),
('xuan_mai', 'pass123', 'xuan@gmail.com'), ('yen_trinh', 'pass123', 'yen@gmail.com');

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

INSERT INTO Posts (user_id, content) VALUES
(1, 'Hôm nay học SQL thật thú vị!'), (2, 'Chào cả nhà, mình là thành viên mới.'),
(3, 'Có ai muốn đi uống cafe không?'), (4, 'Database là trái tim của ứng dụng.'),
(5, 'Chúc mọi người một ngày tốt lành!'), (6, 'Dự án mạng xã hội sắp hoàn thành rồi.'),
(7, 'Thời tiết Hà Nội hôm nay đẹp quá.'), (8, 'Đang tìm hiểu về Index trong MySQL.'),
(9, 'Làm thế nào để tối ưu truy vấn?'), (10, 'Học lập trình cần sự kiên trì.'),
(11, 'Vừa hoàn thành bài tập mức độ giỏi!'), (12, 'Mọi người cho mình xin feedback bài viết.'),
(13, 'Sách hay nên đọc cuối tuần.'), (14, 'Travel vlog mới của mình đây.'),
(15, 'Món ăn này ngon tuyệt vời!'), (16, 'Game này đồ họa đẹp quá.'),
(17, 'Tìm đồng đội học nhóm SQL.'), (18, 'Vừa đạt chứng chỉ mới!'),
(19, 'Cảm ơn mọi người đã ủng hộ.'), (20, 'Kết thúc một ngày làm việc hiệu quả.');

CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

INSERT INTO Comments (post_id, user_id, content) VALUES
(1, 2, 'Đúng vậy bạn ơi!'), (1, 3, 'SQL rất quan trọng.'),
(2, 1, 'Chào mừng bạn nhé!'), (4, 5, 'Rất chính xác.'),
(5, 6, 'Cảm ơn bạn, bạn cũng vậy!'), (6, 7, 'Chúc mừng dự án thành công.'),
(7, 8, 'Trong Sài Gòn đang mưa to.'), (8, 9, 'Index giúp tìm kiếm nhanh hơn.'),
(4, 10, 'Mình cũng đang học cái này.'), (11, 1, 'Giỏi quá bạn ơi!'),
(15, 12, 'Nhìn thèm quá!'), (13, 14, 'Cuốn sách tên gì vậy bạn?'),
(14, 15, 'Cảnh quay đẹp thật.'), (16, 2, 'Game gì vậy bạn?'),
(17, 4, 'Cho mình tham gia với.'), (18, 19, 'Chúc mừng nhé!'),
(19, 20, 'Không có gì đâu.'), (20, 1, 'Nghỉ ngơi thôi!'),
(3, 11, 'Mình rảnh nè, đi đâu?'), (10, 5, 'Kiên trì là chìa khóa.');

CREATE TABLE Friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    PRIMARY KEY (user_id, friend_id), -- Khóa chính kết hợp
    CHECK (status IN ('pending', 'accepted')),
    CHECK (user_id <> friend_id), -- Ràng buộc không cho tự kết bạn với chính mình
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

INSERT INTO Friends (user_id, friend_id, status) VALUES
(1, 2, 'accepted'), (1, 3, 'accepted'), (1, 4, 'pending'), (2, 3, 'accepted'),
(4, 5, 'accepted'), (5, 6, 'pending'), (6, 7, 'accepted'), (7, 8, 'accepted'),
(9, 10, 'accepted'), (10, 11, 'pending'), (11, 12, 'accepted'), (13, 14, 'accepted'),
(15, 16, 'accepted'), (17, 18, 'pending'), (19, 20, 'accepted'), (1, 10, 'accepted'),
(2, 20, 'pending'), (3, 15, 'accepted'), (5, 15, 'accepted'), (8, 12, 'accepted');

CREATE TABLE Likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    PRIMARY KEY (user_id, post_id), -- Khóa chính kết hợp để một người chỉ thích 1 bài 1 lần
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE
);

INSERT INTO Likes (user_id, post_id) VALUES
(2, 1), (3, 1), (4, 1), (5, 1), (1, 2),
(3, 2), (6, 4), (7, 4), (8, 4), (1, 5),
(10, 6), (11, 11), (12, 11), (13, 11), (14, 11),
(15, 15), (16, 15), (2, 20), (5, 20), (10, 20);

-- cau 1
select * from Users;

-- cau 2
create or replace view vw_public_users as 
select user_id, username, created_at from Users;

select * from vw_public_users;
select * from Users;
#VIEW giúp bảo mật vì: Không cho lộ password, email, giảm rủi ro lộ dữ liệu nhạy cảm

-- cau 3
create index idx_users_username on Users(username);
select * from Users where username = 'an_nguyen';

-- cau 4
delimiter //
create procedure sp_create_post (in p_user_id int, in p_content text )
BEGIN
    if exists (select 1 from Users where user_id = p_user_id) then 
        insert into Posts (user_id, content) values (p_user_id, p_content);
    END IF;
END //
delimiter ;
call sp_create_post(1, 'Đây là bài viết mới được đăng bằng Stored Procedure');

-- cau 5
create or replace view vw_recent_posts as
select p.post_id, u.username, p.content, p.created_at
from Posts p join Users u on p.user_id = u.user_id where datediff(now(), p.created_at) <= 7;
select * from vw_recent_posts order by created_at desc;

-- cau 6
create index idx_posts_user_id on Posts(user_id);
create index idx_posts_user_time on Posts(user_id, created_at);
select post_id, content, created_at from Posts
where user_id = 1 order by created_at desc;

-- cau 7
delimiter //
create procedure sp_count_posts (in p_user_id int, out p_total int)
BEGIN
    select count(*) into p_total from Posts
    where user_id = p_user_id;
END //
delimiter ;
call sp_count_posts(1, @total_posts);
select @total_posts as tong_bai_viet;
