CREATE DATABASE Training_Institute 
USE Training_Institute 

CREATE TABLE Trainee ( 
    trainee_id INT PRIMARY KEY, 
    trainee_name VARCHAR(100),
	gender char (10) CHECK (gender IN ('Male', 'Female')),
    Email VARCHAR(100), 
    background varchar (500) 
);	
CREATE TABLE Trainer ( 
    trainer_id INT PRIMARY KEY, 
    trainer_name VARCHAR(100),
    specialty varchar (500),
	phone varchar (15),
    Email VARCHAR(100) 
);	
CREATE TABLE Course ( 
    course_id INT PRIMARY KEY, 
    title VARCHAR(100),
    category VARCHAR(100), 
    duration_hours INT,	
	course_level varchar (50) CHECK (course_level IN ('Beginner', 'Intermediate', 'Advanced'))
);	
CREATE TABLE Schedule ( 
    schedule_id INT PRIMARY KEY, 
	course_id INT,
    trainer_id INT,
	StartDate date,
    EndDate date,
	time_slot varchar (50) CHECK (time_slot IN ('Morning', 'Evening', 'Weekend')),
	FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id) 
);	
CREATE TABLE Enrollment ( 
    enrollment_id INT PRIMARY KEY, 
	trainee_id INT,
    course_id INT,
	enrollment_date date,
    FOREIGN KEY (trainee_id) REFERENCES Trainee(trainee_id), 
    FOREIGN KEY (course_id) REFERENCES Course(course_id) 
);	
-- Trainee 
INSERT INTO Trainee VALUES 
(1, 'Aisha Al-Harthy', 'Female',' aisha@example.com', 'Engineering'),
(2, 'Sultan Al-Farsi', 'Male', 'sultan@example.com', 'Business'),
(3, 'Mariam Al-Saadi', 'Female', ' mariam@example.com ', 'Marketing'),
(4, 'Omar Al-Balushi', 'Male', 'omar@example.com ', 'Computer Science'),
(5, 'Fatma Al-Hinai ', 'Female', ' fatma@example.com ', 'Data Science')
;
-- Trainer
INSERT INTO Trainer VALUES 
(1, 'Khalid Al-Maawali', 'Databases', '96891234567', 'khalid@example.com'), 
(2, 'Noura Al-Kindi', 'Web Development', '96892345678', 'noura@example.com'),
(3, 'Salim Al-Harthy', 'Data Science', '96893456789', 'salim@example.com')
;
-- Course
INSERT INTO Course VALUES 
(1, 'Database Fundamentals', 'Databases', 20, 'Beginner'),
(2, 'Web Development Basics', 'Web', 30, 'Beginner'),
(3, 'Data Science Introduction', 'Data Science', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'Databases', 15, 'Advanced')
;
-- Schedule
INSERT INTO Schedule VALUES 
(1, 1, 1, '2025-07-01', '2025-07-10', 'Morning'),
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning')
;
-- Enrollment
INSERT INTO Enrollment VALUES 
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06')
;


--Query Challenges 
-- 1. Show all available courses (title, level, category) 
SELECT 
title, course_level, category
FROM 
Course;

-- 2. View beginner-level Data Science courses
SELECT 
    title, course_level, category
FROM 
    Course
WHERE 
    course_level = 'Beginner' 
    AND category = 'Data Science';

-- 3. Show courses this trainee is enrolled in 
SELECT  c.title
FROM  Enrollment e
JOIN Course c
ON e.course_id = c.course_id
WHERE e.trainee_id = 1;  

-- 4. View the schedule (start_date, time_slot) for the trainee's enrolled courses 
SELECT title, StartDate, time_slot
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON c.course_id = s.course_id
WHERE e.trainee_id = 1; 

-- 5. Count how many courses the trainee is enrolled in 
SELECT COUNT(*) AS course_count
FROM Enrollment
WHERE trainee_id = 1; 

-- 6. Show course titles, trainer names, and time slots the trainee is attending 
SELECT title AS course_title,trainer_name,time_slot
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON c.course_id = s.course_id
JOIN Trainer t ON s.trainer_id = t.trainer_id
WHERE e.trainee_id = 1;

-- Trainer Perspective 
 --Query Challenges 
-- 1. List all courses the trainer is assigned to 
SELECT title AS course_title
FROM Schedule s JOIN Course c 
ON s.course_id = c.course_id
WHERE s.trainer_id = 1;

-- 2. Show upcoming sessions (with dates and time slots) 
SELECT title, StartDate, EndDate, time_slot
FROM Schedule s, Course c
WHERE s.course_id = c.course_id 
AND s.trainer_id = 1 
AND s.StartDate > GETDATE();

-- 3. See how many trainees are enrolled in each of your courses 
SELECT title AS course_title,
    COUNT(trainee_id) AS number_of_trainees
FROM Schedule s JOIN Course c 
ON s.course_id = c.course_id 
LEFT JOIN Enrollment e 
ON s.course_id = e.course_id
WHERE s.trainer_id = 1 
GROUP BY c.title;

-- 4. List names and emails of trainees in each of your courses 
SELECT  Course.title AS course_title,Trainee.trainee_name,Trainee.Email
FROM Schedule
JOIN Course ON Schedule.course_id = Course.course_id
JOIN Enrollment ON Course.course_id = Enrollment.course_id
JOIN Trainee ON Enrollment.trainee_id = Trainee.trainee_id
WHERE Schedule.trainer_id = 1  
ORDER BY Course.title;

-- 5. Show the trainer's contact info and assigned courses 
SELECT Trainer.trainer_name,Trainer.phone,Trainer.Email,Course.title AS course_title
FROM Trainer
JOIN Schedule ON Trainer.trainer_id = Schedule.trainer_id
JOIN Course ON Schedule.course_id = Course.course_id
WHERE Trainer.trainer_id = 1; 

-- 6. Count the number of courses the trainer teaches 
SELECT Trainer.trainer_name, COUNT(DISTINCT Schedule.course_id) AS number_of_courses
FROM Trainer JOIN Schedule 
ON Trainer.trainer_id = Schedule.trainer_id
WHERE Trainer.trainer_id = 1  
GROUP BY Trainer.trainer_name;

-- Admin Perspective 
-- Query Challenges 
-- 1. Add a new course (INSERT statement)
INSERT INTO Course VALUES 
(5, 'Python Programming Basics', 'Programming', 30, 'Beginner');

-- 2. Create a new schedule for a trainer 
INSERT INTO Schedule VALUES 
(5, 5, 2, '2025-08-01', '2025-08-15', 'Evening');

-- 3. View all trainee enrollments with course title and schedule info 
SELECT t.trainee_name, c.title AS course_title, s.StartDate, s.EndDate, s.time_slot
FROM Enrollment e
JOIN Trainee t ON e.trainee_id = t.trainee_id
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON c.course_id = s.course_id;

-- 4. Show how many courses each trainer is assigned to 
SELECT trainer_name, COUNT(DISTINCT s.course_id) AS number_of_courses
FROM Trainer t LEFT JOIN Schedule s 
ON t.trainer_id = s.trainer_id
GROUP BY t.trainer_name;

-- 5. List all trainees enrolled in "Data Basics" 
SELECT trainee_name, Email
FROM Enrollment e
JOIN Trainee t ON e.trainee_id = t.trainee_id
JOIN Course c ON e.course_id = c.course_id
WHERE c.title = 'Data Basics';

-- 6. Identify the course with the highest number of enrollments 
SELECT title, COUNT(e.trainee_id) AS total_enrollments
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
GROUP BY c.title;

-- 7. Display all schedules sorted by start date 
SELECT *
FROM Schedule
ORDER BY StartDate ;