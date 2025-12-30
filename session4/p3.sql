-- PHẦN III: CẬP NHẬT DỮ LIỆU

UPDATE Student
SET email = 'a_new@gmail.com'
WHERE student_id = 'SV01';

UPDATE Course
SET description = 'Khóa học SQL từ cơ bản đến nâng cao'
WHERE course_id = 'C01';

UPDATE Score
SET final_score = 9.0
WHERE student_id = 'SV01' AND course_id = 'C01';