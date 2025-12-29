#CREATE DATABASE btvn;
USE btvn;

CREATE TABLE class_list (
    id INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    academic_year DATE NOT NULL,
    CONSTRAINT pk_class PRIMARY KEY (id),
    CONSTRAINT uq_class_name UNIQUE (name)
);

CREATE TABLE teacher_list (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(50),
    email VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT chk_email_format CHECK (email LIKE '%@%.%')
);

CREATE TABLE student_list (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    gpa DECIMAL(3,2),
    phone CHAR(10) UNIQUE,
    email VARCHAR(50) UNIQUE,
    avatar BLOB NOT NULL,
    class_id INT NOT NULL,
    CONSTRAINT chk_gpa_non_negative CHECK (gpa >= 0),
    CONSTRAINT fk_student_class 
        FOREIGN KEY (class_id) REFERENCES class_list(id)
);

CREATE TABLE subject_list (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(50),
    credit INT,
    teacher_id INT NOT NULL,
    CONSTRAINT chk_credit CHECK (credit >= 0),
    CONSTRAINT fk_subject_teacher 
        FOREIGN KEY (teacher_id) REFERENCES teacher_list(id)
);

CREATE TABLE enrollment (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    CONSTRAINT pk_registration PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_reg_student 
        FOREIGN KEY (student_id) REFERENCES student_list(id),
    CONSTRAINT fk_reg_subject 
        FOREIGN KEY (subject_id) REFERENCES subject_list(id)
);

CREATE TABLE grade (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    mid_score DECIMAL(3,1) DEFAULT 0,
    final_score DECIMAL(3,1) DEFAULT 0,
    CONSTRAINT pk_grade PRIMARY KEY (student_id, subject_id),
    CONSTRAINT chk_mid_score CHECK (mid_score BETWEEN 0 AND 10),
    CONSTRAINT chk_final_score CHECK (final_score BETWEEN 0 AND 10),
    CONSTRAINT fk_grade_student 
        FOREIGN KEY (student_id) REFERENCES student_list(id),
    CONSTRAINT fk_grade_subject 
        FOREIGN KEY (subject_id) REFERENCES subject_list(id)
);
