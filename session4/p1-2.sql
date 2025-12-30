DROP DATABASE IF EXISTS school;
CREATE DATABASE school;
USE school;

CREATE TABLE Student (
    student_id VARCHAR(20) PRIMARY KEY,
    full_name  VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Teacher (
    teacher_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Course (
    course_id VARCHAR(20) PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    total_sessions INT NOT NULL CHECK (total_sessions > 0),
    teacher_id VARCHAR(20) NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollment (
    student_id VARCHAR(20),
    course_id VARCHAR(20),
    enroll_date DATE NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

CREATE TABLE Score (
    student_id VARCHAR(20),
    course_id VARCHAR(20),
    mid_score DECIMAL(4,2) CHECK (mid_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) CHECK (final_score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

-- PHẦN II: NHẬP DỮ LIỆU

INSERT INTO Student (student_id, full_name, date_of_birth, email) VALUES
('SV01', 'Nguyễn Văn A', '2003-05-10', 'a@gmail.com'),
('SV02', 'Trần Thị B', '2003-08-15', 'b@gmail.com'),
('SV03', 'Lê Văn C', '2002-11-20', 'c@gmail.com'),
('SV04', 'Phạm Thị D', '2003-02-12', 'd@gmail.com'),
('SV05', 'Hoàng Văn E', '2002-09-30', 'e@gmail.com');

INSERT INTO Teacher (teacher_id, full_name, email) VALUES
('GV01', 'Nguyễn Minh H', 'h@gmail.com'),
('GV02', 'Trần Văn K', 'k@gmail.com'),
('GV03', 'Lê Thị M', 'm@gmail.com'),
('GV04', 'Phạm Văn N', 'n@gmail.com'),
('GV05', 'Hoàng Thị P', 'p@gmail.com');

INSERT INTO Course (course_id, course_name, description, total_sessions, teacher_id) VALUES
('C01', 'Cơ sở dữ liệu', 'Học về SQL và thiết kế CSDL', 30, 'GV01'),
('C02', 'Lập trình Java', 'Java cơ bản đến nâng cao', 40, 'GV02'),
('C03', 'Cấu trúc dữ liệu', 'Danh sách, Stack, Queue', 35, 'GV03'),
('C04', 'Web cơ bản', 'HTML, CSS, JavaScript', 25, 'GV04'),
('C05', 'Python cơ bản', 'Python cho người mới', 20, 'GV05');

INSERT INTO Enrollment (student_id, course_id, enroll_date) VALUES
('SV01', 'C01', '2025-01-05'),
('SV01', 'C02', '2025-01-06'),
('SV02', 'C01', '2025-01-07'),
('SV03', 'C03', '2025-01-08'),
('SV04', 'C04', '2025-01-09');

INSERT INTO Score (student_id, course_id, mid_score, final_score) VALUES
('SV01', 'C01', 7.5, 8.0),
('SV01', 'C02', 6.5, 7.0),
('SV02', 'C01', 8.0, 8.5),
('SV03', 'C03', 7.0, 7.5),
('SV04', 'C04', 6.0, 6.5);

