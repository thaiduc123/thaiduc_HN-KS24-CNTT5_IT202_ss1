DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0
);
CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    UNIQUE KEY unique_like (post_id, user_id)
);

CREATE TABLE followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (followed_id) REFERENCES users(user_id)
);

CREATE TABLE follow_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    follower_id INT,
    followed_id INT,
    error_message VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (username) VALUES ('A'), ('B');
-- cau 1

start transaction;
insert into posts (user_id, content) values (1, 'abcdef');
update users set posts_count = posts_count + 1 where user_id = 1;
commit;

-- start transaction;
-- insert into posts (user_id, content) values (67, 'six seven');
-- update users set posts_count = posts_count + 1 where user_id = 67;
-- rollback;
-- SELECT * FROM users;
-- SELECT * FROM posts;

-- cau 2
alter table posts add column likes_count int default 0;
start transaction;
insert into likes (post_id, user_id) values (1, 2);
update posts set likes_count = likes_count + 1 where post_id = 1;
commit;

-- start transaction;
-- insert into likes (post_id, user_id) values (1, 2);
-- update posts set likes_count = likes_count + 1 where post_id = 1;
-- rollback;

-- SELECT * FROM users;
-- SELECT * FROM posts;
-- SELECT * FROM likes;

-- cau 3
alter table users add column following_count int default 0,
add column followers_count int default 0;
delimiter //
create procedure sp_follow_user (in p_follower_id int, in p_followed_id int)
begin
    declare v_count int default 0;
    start transaction;
    select count(*) into v_count from users
    where user_id in (p_follower_id, p_followed_id);
    if v_count < 2 then
        insert into follow_log (follower_id, followed_id, error_message) values (p_follower_id, p_followed_id, 'tai khoan da ton tai');
        rollback;
    end if;
    if p_follower_id = p_followed_id then
        insert into follow_log (follower_id, followed_id, error_message) values (p_follower_id, p_followed_id, 'khong hop le');
        rollback;
    end if;
    select count(*) into v_count from followers where follower_id = p_follower_id and followed_id = p_followed_id;
    if v_count > 0 then
        insert into follow_log (follower_id, followed_id, error_message) values (p_follower_id, p_followed_id, 'da follow');
        rollback;
    end if;
    insert into followers (follower_id, followed_id) values (p_follower_id, p_followed_id);
    update users set following_count = following_count + 1 where user_id = p_follower_id;
    update users set followers_count = followers_count + 1 where user_id = p_followed_id;
    commit;
end//
delimiter ;
-- call sp_follow_user(1, 2);
-- call sp_follow_user(1, 2);

-- cau 4
alter table posts add column comments_count int default 0;
delimiter //
create procedure sp_post_comment (in p_post_id int, in p_user_id int,in p_content text)
begin
    declare v_rows int default 0;
    start transaction;
    insert into comments (post_id, user_id, content) values (p_post_id, p_user_id, p_content);
    savepoint after_insert;
    update posts set comments_count = comments_count + 1 where post_id = p_post_id;
    set v_rows = row_count();
    if v_rows = 0 then
        rollback to after_insert;
        commit;
    end if;
end//
delimiter ;
-- call sp_post_comment(1, 1, 'This is a valid comment');
-- call sp_post_comment(999, 1, 'This comment causes update failure');
