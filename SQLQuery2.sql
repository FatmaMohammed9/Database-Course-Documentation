create database  Aggregation
use  Aggregation

CREATE TABLE Instructors ( 
    InstructorID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Email VARCHAR(100), 
    JoinDate DATE 
); 
CREATE TABLE Categories ( 
    CategoryID INT PRIMARY KEY, 
    CategoryName VARCHAR(50) 
); 
CREATE TABLE Courses ( 
    CourseID INT PRIMARY KEY, 
    Title VARCHAR(100), 
    InstructorID INT, 
    CategoryID INT, 
    Price DECIMAL(6,2), 
    PublishDate DATE, 
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID), 
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) 
); 
CREATE TABLE Students ( 
    StudentID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Email VARCHAR(100), 
    JoinDate DATE 
); 
CREATE TABLE Enrollments ( 
    EnrollmentID INT PRIMARY KEY, 
    StudentID INT, 
    CourseID INT, 
    EnrollDate DATE, 
    CompletionPercent INT, 
    Rating INT CHECK (Rating BETWEEN 1 AND 5), 
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID), 
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) 
); 

-- Instructors 
INSERT INTO Instructors VALUES 
(1, 'Sarah Ahmed', 'sarah@learnhub.com', '2023-01-10'), 
(2, 'Mohammed Al-Busaidi', 'mo@learnhub.com', '2023-05-21'); 
-- Categories 
INSERT INTO Categories VALUES 
(1, 'Web Development'), 
(2, 'Data Science'), 
(3, 'Business'); 
-- Courses 
INSERT INTO Courses VALUES 
(101, 'HTML & CSS Basics', 1, 1, 29.99, '2023-02-01'), 
(102, 'Python for Data Analysis', 2, 2, 49.99, '2023-03-15'), 
(103, 'Excel for Business', 2, 3, 19.99, '2023-04-10'), 
(104, 'JavaScript Advanced', 1, 1, 39.99, '2023-05-01'); 
-- Students 
INSERT INTO Students VALUES 
(201, 'Ali Salim', 'ali@student.com', '2023-04-01'), 
(202, 'Layla Nasser', 'layla@student.com', '2023-04-05'), 
(203, 'Ahmed Said', 'ahmed@student.com', '2023-04-10'); 
-- Enrollments 
INSERT INTO Enrollments VALUES 
(1, 201, 101, '2023-04-10', 100, 5), 
(2, 202, 102, '2023-04-15', 80, 4), 
(3, 203, 101, '2023-04-20', 90, 4), 
(4, 201, 102, '2023-04-22', 50, 3), 
(5, 202, 103, '2023-04-25', 70, 4), 
(6, 203, 104, '2023-04-28', 30, 2), 
(7, 201, 104, '2023-05-01', 60, 3);


-- 1. What is the difference between GROUP BY and ORDER BY? 
-- GROUP BY is used to group rows that have the same value in a column. It's often used with functions like COUNT(), SUM(), etc.
-- ORDER BY is used to sort the result in ascending or descending order.

-- 2. Why do we use HAVING instead of WHERE when filtering aggregate results? 
-- We use HAVING instead of WHERE when we want to filter results after using an aggregate function like SUM(), COUNT(), AVG()

-- 3. What are common beginner mistakes when writing aggregation queries? 

-- 1. Using WHERE instead of HAVING for filtering aggregate values
-- 2. Not using GROUP BY when using aggregate functions with other columns
-- 3. Including non-aggregated columns without grouping them
-- 4. Expecting GROUP BY to sort results
-- 5. Forgetting to alias aggregate results
-- 6. Assuming NULL values are counted in COUNT(column)

-- 4. When would you use COUNT(DISTINCT ...), AVG(...), and SUM(...) together? 
--we use COUNT(DISTINCT ...), SUM(...), and AVG(...) together when you want to:
-- Analyze data by counting unique values, totaling values, and calculating the average — all in one query.

-- 5. How does GROUP BY affect query performance, and how can indexes help?
-- How GROUP BY Affects Query Performance:
-- GROUP BY groups rows based on one or more columns before applying aggregate functions like SUM(), COUNT(), etc.
-- This can slow down performance on large datasets because:
-- The database engine must sort or scan through many rows.
-- It uses extra memory or temporary storage to group and calculate.

-- How Indexes Help:
-- If the column(s) used in GROUP BY are indexed, the database can:
-- Find groups faster without scanning the whole table.
-- Avoid sorting, because the index is already ordered.
-- Reduce I/O operations, which speeds up the query.

-- 1. Count total number of students. 
Select COUNT (StudentID)
From Students

-- 2. Count total number of enrollments. 
Select COUNT (EnrollmentID)
From Enrollments

-- 3. Find average rating of each course.
Select Avg(Rating), CourseID 
From Enrollments
group by CourseID

-- 4. Total number of courses per instructor. 
Select count (CourseID) AS total_courses, InstructorID
From Courses
group by InstructorID

-- 5. Number of courses in each category. 
Select count(CourseID), CategoryID
From Categories
group by CategoryID

-- 6. Number of students enrolled in each course.
Select count (StudentID) As No_students, CourseID
From Enrollments
group by CourseID
 
-- 7. Average course price per category. 
Select Avg(Price) as Ave_price, CategoryID
From Courses
group by CategoryID

-- 8. Maximum course price. 
select MAX(Price)As max_price
from Courses

-- 9. Min, Max, and Avg rating per course. 
Select min(Rating) as min_rating, CourseID 
From Enrollments
group by CourseID

Select max(Rating)as max_rating, CourseID 
From Enrollments
group by CourseID

Select Avg(Rating)as avg_rating, CourseID 
From Enrollments
group by CourseID

-- 10. Count how many students gave rating = 5. 
select COUNT(StudentID) as No_students
from Enrollments
where Rating= 5 