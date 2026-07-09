-- =====================================================================
-- Student Name: Rahaf Abdulaziz Alslimy
-- Assignment: SQL Fundamentals Assignment - Student Management Database
-- =====================================================================

-- =====================================================================
-- Task 1: Create Database and Tables
-- =====================================================================

CREATE DATABASE training_center_db;
USE training_center_db;

-- Instructors table: one instructor teaches many courses
CREATE TABLE instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(100) NOT NULL,
    specialty     VARCHAR(100),
    CONSTRAINT uq_instructor_email UNIQUE (email)
);

-- Students table: one student has many enrollments
CREATE TABLE students (
    student_id  INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL,
    age         INT NOT NULL,
    city        VARCHAR(100) DEFAULT 'Riyadh',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_student_email UNIQUE (email),
    CONSTRAINT chk_student_age CHECK (age >= 18)
);

-- Courses table: many courses belong to one instructor
CREATE TABLE courses (
    course_id       INT AUTO_INCREMENT PRIMARY KEY,
    course_name     VARCHAR(150) NOT NULL,
    category        VARCHAR(100) NOT NULL,
    price           DECIMAL(10,2) NOT NULL,
    duration_hours  INT NOT NULL,
    start_date      DATE NOT NULL,
    instructor_id   INT NOT NULL,
    CONSTRAINT fk_course_instructor FOREIGN KEY (instructor_id)
        REFERENCES instructors(instructor_id),
    CONSTRAINT chk_course_price CHECK (price >= 0),
    CONSTRAINT chk_course_duration CHECK (duration_hours > 0)
);

-- Enrollments table: many-to-many bridge table between students and courses
-- ON DELETE CASCADE is used on both foreign keys so that if a student or a
-- course is ever deleted, their related enrollment rows are removed
-- automatically instead of blocking the delete or leaving orphaned rows.
CREATE TABLE enrollments (
    enrollment_id    INT AUTO_INCREMENT PRIMARY KEY,
    student_id       INT NOT NULL,
    course_id        INT NOT NULL,
    enrollment_date  DATE NOT NULL DEFAULT (CURRENT_DATE),
    status           VARCHAR(20) NOT NULL DEFAULT 'Active',
    grade            DECIMAL(5,2),
    CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id)
        REFERENCES students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_course FOREIGN KEY (course_id)
        REFERENCES courses(course_id) ON DELETE CASCADE,
    CONSTRAINT chk_enrollment_status CHECK (status IN ('Active','Completed','Cancelled')),
    CONSTRAINT chk_enrollment_grade CHECK (grade IS NULL OR (grade BETWEEN 0 AND 100))
);


-- =====================================================================
-- Task 2: Insert Sample Data
-- =====================================================================

-- 4 instructors
INSERT INTO instructors (full_name, email, specialty) VALUES
('Amani Al-Zahrani', 'amani1914@gmail.com', 'Database Systems'),
('Dima Al-Mani', 'dima1913@gmail.com', 'web development'),
('Dana Al-gawiaz', 'dana1915@gmai.com', 'Data Science'),
('Fahad Al-rwili', 'fahad1911@gmail.com', 'Cloud Computing');

-- 6 courses (course 6 intentionally has no enrollments - for LEFT JOIN testing)
INSERT INTO courses (course_name, category, price, duration_hours, start_date, instructor_id) VALUES
('SQL Fundamentals',        'Database',        1200.00, 40, '2026-01-10', 1),
('Advanced MySQL',          'Database',         1500.00, 30, '2026-02-01', 1),
('Frontend with React',     'Web Development',  1800.00, 50, '2026-01-15', 2),
('Backend with Node.js',    'Web Development',  1700.00, 45, '2026-03-01', 2),
('Python for Data Science', 'Data Science',     2000.00, 60, '2026-01-20', 3),
('AWS Cloud Practitioner',  'Cloud Computing',  1600.00, 35, '2026-04-01', 4);

-- 10 students
INSERT INTO students (full_name, email, age, city) VALUES
('Abdullah Al-Saud',    'abdullah.saud@example.com',    22, 'Riyadh'),
('Fatimah Al-Zahrani',  'fatimah.zahrani@example.com',  24, 'Jeddah'),
('Khalid Al-Mutairi',   'khalid.mutairi@example.com',   19, 'Dammam'),
('Noura Al-Shammari',   'noura.shammari@example.com',   26, 'Riyadh'),
('Faisal Al-Dosari',    'faisal.dosari@example.com',    21, 'Makkah'),
('Reem Al-Ghamdi',      'reem.ghamdi@example.com',      23, 'Riyadh'),
('Omar Al-Amri',        'omar.amri@example.com',        20, 'Jeddah'),
('Hind Al-Balawi',      'hind.balawi@example.com',      25, 'Madinah'),
('Yousef Al-Anazi',     'yousef.anazi@example.com',     27, 'Dammam'),
('Maha Al-Subaie',      'maha.subaie@example.com',      22, 'Riyadh');

-- 16 enrollments (student 1, 2, and 3 are each enrolled in more than one course)
INSERT INTO enrollments (student_id, course_id, enrollment_date, status, grade) VALUES
(1,  1, '2026-01-11', 'Active',    NULL),
(1,  3, '2026-01-16', 'Active',    88.5),
(2,  1, '2026-01-12', 'Completed', 92.0),
(3,  2, '2026-02-02', 'Active',    NULL),
(4,  3, '2026-01-17', 'Completed', 75.0),
(5,  4, '2026-03-02', 'Active',    NULL),
(6,  5, '2026-01-21', 'Completed', 95.0),
(7,  1, '2026-01-13', 'Cancelled', NULL),
(8,  2, '2026-02-03', 'Active',    60.0),
(9,  4, '2026-03-03', 'Completed', 55.0),
(10, 5, '2026-01-22', 'Active',    NULL),
(2,  5, '2026-01-23', 'Active',    70.0),
(3,  1, '2026-01-14', 'Completed', 82.0),
(6,  3, '2026-01-18', 'Active',    NULL),
(9,  1, '2026-01-15', 'Completed', 90.0),
(4,  5, '2026-01-24', 'Active',    65.0);


-- =====================================================================
-- Task 3: CRUD Queries
-- =====================================================================

-- Display all students
SELECT * FROM students;

-- Display all courses
SELECT * FROM courses;

-- Display all enrollments
SELECT * FROM enrollments;

-- WHERE: find students from a specific city
SELECT * FROM students WHERE city = 'Riyadh';

-- --- UPDATE: change a student's city ---
-- Step 1: verify the target row before updating
SELECT * FROM students WHERE student_id = 5;
-- Step 2: perform the update
UPDATE students SET city = 'Jeddah' WHERE student_id = 5;
-- Step 3: confirm the change
SELECT * FROM students WHERE student_id = 5;

-- --- UPDATE: change a course price ---
SELECT * FROM courses WHERE course_id = 2;
UPDATE courses SET price = 1550.00 WHERE course_id = 2;
SELECT * FROM courses WHERE course_id = 2;

-- --- DELETE: remove one cancelled enrollment ---
-- Step 1: verify which row will be deleted
SELECT * FROM enrollments WHERE status = 'Cancelled' AND student_id = 7 AND course_id = 1;
-- Step 2: delete only that exact row
DELETE FROM enrollments WHERE status = 'Cancelled' AND student_id = 7 AND course_id = 1;
-- Step 3: confirm it is gone
SELECT * FROM enrollments WHERE student_id = 7;


-- =====================================================================
-- Task 4: String Functions
-- =====================================================================

-- CONCAT: student name and city in one column
SELECT CONCAT(full_name, ' - ', city) AS name_and_city FROM students;

-- UPPER / LOWER on name or email
SELECT full_name, UPPER(full_name) AS name_upper, LOWER(email) AS email_lower FROM students;

-- SUBSTRING: extract the username part of an email (before the @)
SELECT email, SUBSTRING(email, 1, LOCATE('@', email) - 1) AS email_username FROM students;

-- REPLACE: mask the domain in displayed email results
SELECT email, REPLACE(email, 'gmail.com', 'hidden.com') AS masked_email FROM students;

-- CHAR_LENGTH: show the length of student names
SELECT full_name, CHAR_LENGTH(full_name) AS name_length FROM students;


-- =====================================================================
-- Task 5: Refining Selections
-- =====================================================================

-- DISTINCT: list all course categories
SELECT DISTINCT category FROM courses;

-- ORDER BY: sort courses by price, highest to lowest
SELECT course_name, price FROM courses ORDER BY price DESC;

-- LIMIT: show the top 3 most expensive courses
SELECT course_name, price FROM courses ORDER BY price DESC LIMIT 3;

-- LIKE: find students whose names contain the letter 'a'
SELECT full_name FROM students WHERE full_name LIKE '%a%';

-- Escaped wildcard: search for a literal underscore in course_name
-- (none of our course names contain a literal underscore, so this
--  returns zero rows, but it demonstrates correct escape syntax)
SELECT course_name FROM courses WHERE course_name LIKE '%\_%' ESCAPE '\\';


-- =====================================================================
-- Task 6: Aggregate Functions
-- =====================================================================

-- Total number of students
SELECT COUNT(*) AS total_students FROM students;

-- Number of enrollments per course
SELECT c.course_name, COUNT(e.enrollment_id) AS total_enrollments
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- Average course price
SELECT AVG(price) AS average_price FROM courses;

-- SUM: total value of all course prices combined
SELECT SUM(price) AS total_price_of_all_courses FROM courses;

-- Minimum and maximum course price
SELECT MIN(price) AS min_price, MAX(price) AS max_price FROM courses;

-- GROUP BY: group courses by category
SELECT category, COUNT(*) AS course_count, AVG(price) AS avg_price
FROM courses
GROUP BY category;

-- HAVING: only courses with more than one enrolled student
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.student_id) > 1;


-- =====================================================================
-- Task 7: Operators, Dates, and CASE
-- =====================================================================

-- BETWEEN: courses within a price range
SELECT course_name, price FROM courses WHERE price BETWEEN 1500 AND 2000;

-- BETWEEN: courses starting within a date range
SELECT course_name, start_date FROM courses WHERE start_date BETWEEN '2026-01-01' AND '2026-02-28';

-- IN: filter selected course categories
SELECT course_name, category FROM courses WHERE category IN ('Database', 'Data Science');

-- AND / OR in the same query
SELECT full_name, age, city
FROM students
WHERE (age >= 25 AND city = 'Riyadh') OR city = 'Jeddah';

-- Comparison operators: !=, >, <=
SELECT course_name, category FROM courses WHERE category != 'Cloud Computing';
SELECT course_name, price FROM courses WHERE price > 1500;
SELECT course_name, duration_hours FROM courses WHERE duration_hours <= 40;

-- IS NULL: enrollments without a grade
SELECT * FROM enrollments WHERE grade IS NULL;

-- CASE: display grade status
SELECT
    enrollment_id,
    student_id,
    grade,
    CASE
        WHEN grade IS NULL THEN 'Not Graded'
        WHEN grade >= 90 THEN 'Excellent'
        WHEN grade >= 60 THEN 'Passed'
        ELSE 'Failed'
    END AS grade_status
FROM enrollments;


-- =====================================================================
-- Task 8: ALTER TABLE and Constraints
-- =====================================================================

-- Show structure BEFORE changes
DESCRIBE students;

-- Add a phone_number column
ALTER TABLE students ADD COLUMN phone_number VARCHAR(20);

-- Add a DATETIME column to track exactly when an enrollment record
-- was last updated (DATETIME stores both date and time, unlike DATE)
ALTER TABLE enrollments ADD COLUMN last_updated DATETIME DEFAULT CURRENT_TIMESTAMP;

-- Modify the size of an existing column
ALTER TABLE students MODIFY COLUMN city VARCHAR(150) DEFAULT 'Riyadh';

-- Add a named constraint after table creation
ALTER TABLE courses ADD CONSTRAINT chk_course_name_length CHECK (CHAR_LENGTH(course_name) >= 3);

-- Demonstrate dropping a column: add a temporary column, then drop it
ALTER TABLE students ADD COLUMN temp_notes VARCHAR(50);
ALTER TABLE students DROP COLUMN temp_notes;
-- Note: no other existing column is dropped, because full_name, email, age,
-- city, created_at, and phone_number are all actively used by later queries,
-- joins, and the view in Task 10.

-- Show structure AFTER changes
DESCRIBE students;


-- =====================================================================
-- Task 9: Relationships and Joins
-- =====================================================================

-- INNER JOIN: student names with their enrolled course names
SELECT s.full_name, c.course_name
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id;

-- LEFT JOIN: all courses, including ones with no students
SELECT c.course_name, s.full_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
LEFT JOIN students s ON e.student_id = s.student_id;

-- RIGHT JOIN: all instructors, including ones with no courses
-- (LEFT JOIN is generally preferred for readability because the "kept" table
--  stays on the left, but RIGHT JOIN is used here to satisfy the requirement
--  and is functionally equivalent to swapping the table order in a LEFT JOIN)
SELECT i.full_name AS instructor_name, c.course_name
FROM courses c
RIGHT JOIN instructors i ON c.instructor_id = i.instructor_id;

-- Join three tables: students, enrollments, courses
SELECT s.full_name, c.course_name, e.status
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Join four tables: students, enrollments, courses, instructors
SELECT s.full_name AS student_name, c.course_name, i.full_name AS instructor_name, e.status
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id;

-- JOIN with GROUP BY: number of students per instructor
SELECT i.full_name AS instructor_name, COUNT(DISTINCT e.student_id) AS student_count
FROM instructors i
JOIN courses c ON i.instructor_id = c.instructor_id
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY i.instructor_id, i.full_name;


-- =====================================================================
-- Task 10: Views
-- =====================================================================

-- Create the view
CREATE VIEW vw_student_course_summary AS
SELECT
    s.full_name  AS student_name,
    s.email      AS student_email,
    c.course_name,
    i.full_name  AS instructor_name,
    e.status,
    e.grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id;

-- Query the view with WHERE and ORDER BY
SELECT * FROM vw_student_course_summary
WHERE status = 'Completed'
ORDER BY grade DESC;

-- Replace the view to add a calculated grade_status column
CREATE OR REPLACE VIEW vw_student_course_summary AS
SELECT
    s.full_name  AS student_name,
    s.email      AS student_email,
    c.course_name,
    i.full_name  AS instructor_name,
    e.status,
    e.grade,
    CASE
        WHEN e.grade IS NULL THEN 'Not Graded'
        WHEN e.grade >= 90 THEN 'Excellent'
        WHEN e.grade >= 60 THEN 'Passed'
        ELSE 'Failed'
    END AS grade_status
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id;

SELECT * FROM vw_student_course_summary ORDER BY student_name;

-- WITH ROLLUP: total enrollments per category, plus a grand total row
SELECT c.category, COUNT(e.enrollment_id) AS total_enrollments
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.category WITH ROLLUP;


-- =====================================================================
-- Bonus Task: Window Functions
-- =====================================================================

-- ROW_NUMBER: latest enrollment per student
SELECT student_id, course_id, enrollment_date, status
FROM (
    SELECT
        student_id, course_id, enrollment_date, status,
        ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY enrollment_date DESC) AS rn
    FROM enrollments
) ranked
WHERE rn = 1;

-- RANK / DENSE_RANK: rank courses by price within each category
SELECT
    course_name,
    category,
    price,
    RANK()       OVER (PARTITION BY category ORDER BY price DESC) AS price_rank,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS price_dense_rank
FROM courses;

-- PARTITION BY: average grade per course
SELECT
    enrollment_id,
    student_id,
    course_id,
    grade,
    AVG(grade) OVER (PARTITION BY course_id) AS avg_grade_per_course
FROM enrollments;

-- LEAD / LAG: compare a student's grades across their courses over time
SELECT
    student_id,
    course_id,
    enrollment_date,
    grade,
    LAG(grade)  OVER (PARTITION BY student_id ORDER BY enrollment_date) AS previous_grade,
    LEAD(grade) OVER (PARTITION BY student_id ORDER BY enrollment_date) AS next_grade
FROM enrollments;