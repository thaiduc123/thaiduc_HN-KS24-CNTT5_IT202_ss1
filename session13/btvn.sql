DROP DATABASE IF EXISTS btvn;
CREATE DATABASE btvn;
USE btvn;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATE,
    follower_count INT DEFAULT 0,
    post_count INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME,
    like_count INT DEFAULT 0,
    CONSTRAINT fk_posts_users
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    liked_at DATETIME ,
    CONSTRAINT fk_likes_users FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_likes_posts FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

create table post_history (
    history_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    constraint fk_post_history_posts
        foreign key (post_id) references posts(post_id)
        on delete cascade
);

INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

-- bai 1
delimiter //
create trigger after_insert
after insert on posts for each row
BEGIN
    update users set post_count = post_count + 1
    where user_id = new.user_id;
END//
delimiter ;
delimiter //
create trigger after_delete
after delete on posts for each row 
BEGIN
    update users set post_count = post_count - 1
    where user_id = old.user_id;
END//
delimiter ;
-- SELECT * FROM users;
-- DELETE FROM posts WHERE post_id = 2;
-- SELECT * FROM users;

-- bai 2
delimiter //
create trigger after_insert_like
after insert on likes for each row
BEGIN
    update posts set like_count = like_count + 1
    where post_id = new.post_id;
END//
delimiter ;
delimiter //
create trigger after_delete_like
after delete on likes for each row
BEGIN
    update posts set like_count = like_count - 1
    where post_id = old.post_id;
END//
delimiter ;

create or replace view user_statistics as 
select u.user_id, u.username, u.post_count, SUM(p.like_count) AS total_likes
from users u join posts p on u.user_id = p.user_id group by u.user_id, u.username, u.post_count;

-- INSERT INTO likes (user_id, post_id, liked_at)
-- VALUES (2, 4, NOW());
-- SELECT * FROM posts WHERE post_id = 4;
-- SELECT * FROM user_statistics;
-- DELETE FROM likes
-- WHERE user_id = 2 AND post_id = 4;
-- SELECT * FROM user_statistics;

-- bai 3
delimiter //
create trigger before_insert_like
before insert on likes for each row 
BEGIN
    if exists (select 1 from posts where post_id = new.post_id and user_id = new.user_id) then
        signal sqlstate '45000' set message_text = 'không cho phép user like bài đăng của chính mình';
    end if;
END//
delimiter ;
delimiter //
create trigger after_update_like
after update on likes for each row
BEGIN
    if old.post_id <> new.post_id then 
        update posts set like_count = like_count - 1 where post_id = old.post_id;
        update posts set like_count = like_count + 1 where post_id = new.post_id;
    end if;
END//
delimiter ;

-- INSERT INTO likes (user_id, post_id, liked_at)
-- VALUES (1, 1, NOW());
INSERT INTO likes (user_id, post_id, liked_at)
VALUES (2, 1, NOW());
SELECT post_id, like_count FROM posts WHERE post_id = 1;
UPDATE likes
SET post_id = 2
WHERE user_id = 2 AND post_id = 1;
SELECT post_id, like_count FROM posts WHERE post_id IN (1, 2);
DELETE FROM likes
WHERE user_id = 2 AND post_id = 2;
SELECT post_id, like_count FROM posts WHERE post_id = 2;
SELECT * FROM user_statistics;

-- cau 4
delimiter //
create trigger before_update_posts
before update on posts for each row
begin
    if old.content <> new.content then
        insert into post_history (post_id,old_content, new_content,changed_at, changed_by_user_id)
        values (old.post_id, old.content, new.content, now(), old.user_id);
    end if;
end//
delimiter ;

insert into likes (user_id, post_id, liked_at) values (3, 1, now());
select post_id, like_count from posts where post_id = 1;

