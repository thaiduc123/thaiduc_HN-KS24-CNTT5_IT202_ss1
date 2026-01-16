DROP DATABASE IF EXISTS bth;
CREATE DATABASE bth;
USE bth;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
	FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE
);

CREATE TABLE Friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES Users(user_id)ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

INSERT INTO Users (username, password, email) VALUES
('an_nguyen',  '123456', 'an@gmail.com'),
('binh_tran',  '123456', 'binh@gmail.com'),
('chi_le',     '123456', 'chi@gmail.com'),
('duc_pham',   '123456', 'duc@gmail.com'),
('hoa_vo',     '123456', 'hoa@gmail.com');

INSERT INTO Posts (user_id, content) VALUES
(1, 'Hôm nay trời đẹp quá!'),
(2, 'Mình đang học MySQL'),
(3, 'Mini Social Network bằng SQL'),
(1, 'Ai thích lập trình không?'),
(4, 'Chào mọi người!');

INSERT INTO Comments (post_id, user_id, content) VALUES
(1, 2, 'Đúng rồi, trời rất đẹp'),
(1, 3, 'Chuẩn luôn'),
(2, 1, 'Cố lên nhé'),
(3, 4, 'Ý tưởng hay đó'),
(4, 5, 'Mình thích lập trình');

INSERT INTO Likes (user_id, post_id) VALUES
(2, 1),
(3, 1),
(1, 2),
(4, 3),
(5, 4);

INSERT INTO Friends (user_id, friend_id, status) VALUES
(1, 2, 'accepted'),
(1, 3, 'pending'),
(2, 3, 'accepted'),
(4, 5, 'pending'),
(3, 5, 'accepted');

-- cau 1
create table user_log (
    log_id int auto_increment primary key,
    user_id int,
    action varchar(100),
    log_time datetime default current_timestamp
);
delimiter //
create procedure sp_register_user(in p_username varchar(50), in p_password varchar(255), in p_email varchar(100))
begin
    if exists (select 1 from users where username = p_username) then
        signal sqlstate '45000' set message_text = 'username đã tồn tại';
    end if;
    if exists (select 1 from users where email = p_email) then
        signal sqlstate '45000' set message_text = 'email đã tồn tại';
    end if;
    insert into users (username, password, email) values (p_username, p_password, p_email);
end//
delimiter ;
delimiter //
create trigger trg_after_user_register
after insert on users for each row
begin
    insert into user_log (user_id, action) values (new.user_id, 'user registered');
end//
delimiter ;
-- call sp_register_user('minh_nguyen', '123456', 'minh@gmail.com');
-- call sp_register_user('lan_tran', '123456', 'lan@gmail.com');
-- call sp_register_user('tuan_le', '123456', 'tuan@gmail.com');
-- call sp_register_user('minh_nguyen', 'abc', 'minh2@gmail.com');
-- select * from users;
-- select * from user_log;

-- cau 2
create table post_log (
    log_id int auto_increment primary key,
    post_id int,
    action varchar(100),
    log_time datetime default current_timestamp
);
delimiter //
create procedure sp_create_post(in p_user_id int, in p_content text)
begin
    if p_content is null or trim(p_content) = '' then
        signal sqlstate '45000' set message_text = 'nội dung bài viết không được rỗng';
    end if;
    insert into posts (user_id, content) values (p_user_id, p_content);
end//
delimiter ;
delimiter //
create trigger trg_after_post_create
after insert on posts for each row
begin
    insert into post_log (post_id, action) values (new.post_id, 'post created');
end//
delimiter ;
-- call sp_create_post(1, 'bài viết đầu tiên');
-- call sp_create_post(1, 'học mysql stored procedure');
-- call sp_create_post(2, 'hôm nay học trigger');
-- call sp_create_post(3, 'mini social network');
-- call sp_create_post(2, 'thực hành sql');
-- select * from posts;
-- select * from post_log;
-- call sp_create_post(1, '');

-- cau 3
alter table posts add column like_count int default 0;
create table like_log (
    log_id int auto_increment primary key,
    user_id int,
    post_id int,
    action varchar(50),
    log_time datetime default current_timestamp
);
delimiter //
create trigger trg_after_like_insert
after insert on likes for each row
begin
    update posts set like_count = like_count + 1 where post_id = new.post_id;
    insert into like_log (user_id, post_id, action) values (new.user_id, new.post_id, 'like');
end//
delimiter ;

delimiter //
create trigger trg_after_like_delete
after delete on likes for each row
begin
    update posts set like_count = like_count - 1 where post_id = old.post_id;
    insert into like_log (user_id, post_id, action) values (old.user_id, old.post_id, 'unlike');
end//
delimiter ;
-- insert into likes (user_id, post_id) values (1, 1);
-- insert into likes (user_id, post_id) values (2, 1);
-- insert into likes (user_id, post_id) values (3, 2);
-- select post_id, content, like_count from posts;
-- select * from like_log;
-- delete from likes where user_id = 1 and post_id = 1;
-- insert into likes (user_id, post_id) values (2, 1);

-- cau 4
create table friend_log (
    log_id int auto_increment primary key,
    sender_id int,
    receiver_id int,
    action varchar(100),
    log_time datetime default current_timestamp
);

delimiter //
create procedure sp_send_friend_request(in p_sender_id int, in p_receiver_id int)
begin
    if p_sender_id = p_receiver_id then
        signal sqlstate '45000' set message_text = 'không thể tự gửi lời mời kết bạn';
    end if;
    if exists (select 1 from friends where user_id = p_sender_id and friend_id = p_receiver_id) then
        signal sqlstate '45000' set message_text = 'lời mời kết bạn đã tồn tại';
    end if;
    insert into friends (user_id, friend_id, status) values (p_sender_id, p_receiver_id, 'pending');
end//
delimiter ;
delimiter //
create trigger trg_after_friend_request
after insert on friends for each row
begin
    insert into friend_log (sender_id, receiver_id, action) 
    values (new.user_id, new.friend_id, 'send friend request');
end//
delimiter ;
-- call sp_send_friend_request(1, 2);
-- call sp_send_friend_request(1, 3);
-- call sp_send_friend_request(2, 3);
-- select * from friends;
-- select * from friend_log;
-- call sp_send_friend_request(1, 1);
-- call sp_send_friend_request(1, 2);

-- cau 5
delimiter //
create procedure sp_accept_friend_request(in p_sender_id int, in p_receiver_id int)
begin
    if not exists (select 1 from friends where user_id = p_sender_id 
    and friend_id = p_receiver_id 
    and status = 'pending') then 
		signal sqlstate '45000' set message_text = 'không tồn tại lời mời kết bạn đang chờ';
    end if;
    update friends set status = 'accepted' where user_id = p_sender_id and friend_id = p_receiver_id;
end//
delimiter ;
delimiter //
create trigger trg_after_friend_accept
after update on friends for each row
begin
    if old.status = 'pending' and new.status = 'accepted' then
        if not exists (select 1 from friends where user_id = new.friend_id and friend_id = new.user_id) then
            insert into friends (user_id, friend_id, status)
            values (new.friend_id, new.user_id, 'accepted');
        end if;
        insert into friend_log (sender_id, receiver_id, action)
        values (new.friend_id, new.user_id, 'accept friend request');
    end if;
end//
delimiter ;
-- call sp_send_friend_request(1, 4);
-- select * from friends;

-- cau 6
delimiter //
create procedure sp_update_friend_status(in p_user1 int, in p_user2 int,in p_status varchar(20))
begin
    start transaction;
    update friends
    set status = p_status
    where (user_id = p_user1 and friend_id = p_user2) or (user_id = p_user2 and friend_id = p_user1);
    commit;
end //
delimiter ;
delimiter //
create procedure sp_delete_friend(in p_user1 int,in p_user2 int)
begin
    start transaction;
    delete from friends
    where (user_id = p_user1 and friend_id = p_user2) or (user_id = p_user2 and friend_id = p_user1);
    commit;
end//
delimiter ;
-- call sp_update_friend_status(1, 4, 'accepted');
-- select * from friends where user_id in (1,4);
-- call sp_delete_friend(1, 4);
-- select * from friends where user_id in (1,4);

