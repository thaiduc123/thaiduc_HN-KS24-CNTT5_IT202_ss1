DROP DATABASE IF EXISTS btvn;
CREATE DATABASE btvn;
USE btvn;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT CHECK (credit > 0)
);

CREATE TABLE Enrollment (
    student_id INT,
    subject_id INT,
    enroll_date DATE NOT NULL,
    CONSTRAINT pk_enrollment PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_enrollment_subject FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

CREATE TABLE Score (
    student_id INT,
    subject_id INT,
    mid_score DECIMAL(3,1),
    final_score DECIMAL(3,1),
    CONSTRAINT pk_score PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_score_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
	CONSTRAINT fk_score_subject FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    CONSTRAINT chk_mid_score CHECK (mid_score BETWEEN 0 AND 10),
    CONSTRAINT chk_final_score CHECK (final_score BETWEEN 0 AND 10)
);

INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES
(1, 'THD', '2006-01-10', 'a@gmail.com'),
(2, 'DHT', '2006-02-15', 'b@gmail.com'),
(3, 'HDT', '2006-03-20', 'c@gmail.com');

INSERT INTO Subject (subject_id, subject_name, credit)
VALUES
(1, 'Co so du lieu', 3),
(2, 'Lap trinh C', 3),
(3, 'Lap trinh Java', 4);

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES
(1, 1, '2025-01-10'),
(1, 2, '2025-01-11'),
(2, 1, '2025-01-12'),
(2, 3, '2025-01-13');

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
(1, 1, 7.5, 8.0),
(1, 2, 6.5, 7.0),
(2, 1, 8.0, 9.0);

-- SELECT student_id, full_name, date_of_birth, email
-- FROM Student;

-- SELECT student_id, full_name
-- FROM Student;

#student
UPDATE Student
SET email = 'a_new@gmail.com'
WHERE student_id = 1;

UPDATE Student
SET email = 'c_new@gmail.com'
WHERE student_id = 3;

UPDATE Student
SET date_of_birth = '2006-04-25'
WHERE student_id = 4;

UPDATE Student
SET date_of_birth = '2006-02-20'
WHERE student_id = 2;

DELETE FROM Student
WHERE student_id = 5;

-- SELECT student_id, full_name, date_of_birth, email
-- FROM Student;

#subject
UPDATE Subject
SET credit = 4
WHERE subject_id = 2;

-- SELECT subject_id, subject_name, credit
-- FROM Subject;

UPDATE Subject
SET subject_name = 'Lap trinh Python'
WHERE subject_id = 3;

#enrollment
-- SELECT student_id, subject_id, enroll_date
-- FROM Enrollment;

-- SELECT student_id, subject_id, enroll_date
-- FROM Enrollment
-- WHERE student_id = 1;

#score
-- SELECT student_id, subject_id, mid_score, final_score FROM Score

UPDATE Score
SET final_score = 8.5
WHERE student_id = 1
AND subject_id = 2;

-- SELECT student_id, subject_id, final_score FROM Score
-- WHERE final_score >= 8;
