-- Create tables
CREATE TABLE Student (
    studentid INT PRIMARY KEY,
    studentname VARCHAR(50),
    instructorid INT,
    studentcity VARCHAR(50)
);

CREATE TABLE Instructor (
    instructorid INT PRIMARY KEY,
    Instructorname VARCHAR(50),
    instructorcity VARCHAR(50),
    specialization VARCHAR(50)
);

-- Add foreign key constraint
ALTER TABLE Student
ADD CONSTRAINT fk_instructor
FOREIGN KEY (instructorid) REFERENCES Instructor(instructorid);

-- 1. Find the instructor of each student (INNER JOIN)
SELECT 
    s.studentname,
    i.Instructorname
FROM Student s
INNER JOIN Instructor i ON s.instructorid = i.instructorid;

-- 2. Find the student who is not having any instructor (LEFT JOIN)
SELECT 
    s.studentname
FROM Student s
LEFT JOIN Instructor i ON s.instructorid = i.instructorid
WHERE i.instructorid IS NULL;

-- 3. Find students without instructors and instructors without students (FULL OUTER JOIN)
-- Note: MySQL doesn't support FULL OUTER JOIN directly, so we use UNION of LEFT and RIGHT JOIN
SELECT 
    s.studentname,
    i.Instructorname
FROM Student s
LEFT JOIN Instructor i ON s.instructorid = i.instructorid
WHERE i.instructorid IS NULL
UNION
SELECT 
    s.studentname,
    i.Instructorname
FROM Student s
RIGHT JOIN Instructor i ON s.instructorid = i.instructorid
WHERE s.studentid IS NULL;

-- 4. Find students whose instructor's specialization is computer (INNER JOIN)
SELECT 
    s.studentname,
    i.Instructorname,
    i.specialization
FROM Student s
INNER JOIN Instructor i ON s.instructorid = i.instructorid
WHERE i.specialization = 'computer';

-- 5. Create a view containing total number of students whose instructor belongs to "Pune"
CREATE VIEW Pune_Students_Count AS
SELECT 
    COUNT(*) as total_students
FROM Student s
INNER JOIN Instructor i ON s.instructorid = i.instructorid
WHERE i.instructorcity = 'Pune'; 