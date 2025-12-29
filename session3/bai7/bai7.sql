INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES (10, 'TTTHHHDDD', '2006-06-06', 'thd@gmail.com');

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES
(10, 1, '2026-01-01'),
(10, 2, '2026-01-01');

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
(10, 1, 7.0, 8.0),
(10, 2, 6.5, 7.5);

UPDATE Score
SET final_score = 8.5
WHERE student_id = 10 AND subject_id = 2;

DELETE FROM Enrollment
WHERE student_id = 10 AND subject_id = 2;

SELECT Student.student_id, Student.full_name, Subject.subject_name, Score.mid_score, Score.final_score
FROM Student, Subject, Score
WHERE Student.student_id = Score.student_id AND Subject.subject_id = Score.subject_id;

