-- Create tables
CREATE TABLE STUDENT (
    USN VARCHAR(10) PRIMARY KEY,
    SName VARCHAR(50),
    Address VARCHAR(100),
    Phone VARCHAR(15),
    Gender CHAR(1)
);

CREATE TABLE SEMSEC (
    SSID INT PRIMARY KEY,
    Sem INT,
    Sec CHAR(1)
);

CREATE TABLE CLASS (
    USN VARCHAR(10),
    SSID INT,
    PRIMARY KEY (USN, SSID),
    FOREIGN KEY (USN) REFERENCES STUDENT(USN),
    FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID)
);

CREATE TABLE COURSE (
    Subcode VARCHAR(10) PRIMARY KEY,
    Title VARCHAR(50),
    Sem INT,
    Credits INT
);

CREATE TABLE IAMARKS (
    USN VARCHAR(10),
    Subcode VARCHAR(10),
    SSID INT,
    Test1 INT,
    Test2 INT,
    Test3 INT,
    FinalIA INT,
    PRIMARY KEY (USN, Subcode, SSID),
    FOREIGN KEY (USN) REFERENCES STUDENT(USN),
    FOREIGN KEY (Subcode) REFERENCES COURSE(Subcode),
    FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID)
);

-- 1. List all student details studying in fourth semester 'C' section
SELECT s.*
FROM STUDENT s
JOIN CLASS c ON s.USN = c.USN
JOIN SEMSEC ss ON c.SSID = ss.SSID
WHERE ss.Sem = 4 AND ss.Sec = 'C';

-- 2. Compute total number of male and female students in each semester and section
SELECT 
    ss.Sem,
    ss.Sec,
    s.Gender,
    COUNT(*) as Count
FROM STUDENT s
JOIN CLASS c ON s.USN = c.USN
JOIN SEMSEC ss ON c.SSID = ss.SSID
GROUP BY ss.Sem, ss.Sec, s.Gender
ORDER BY ss.Sem, ss.Sec, s.Gender;

-- 3. Create a view of Test1 marks of student USN '1BI15CS101' in all Courses
CREATE VIEW STUDENT_TEST1_MARKS AS
SELECT 
    c.Title as Course_Title,
    i.Test1 as Test1_Marks
FROM IAMARKS i
JOIN COURSE c ON i.Subcode = c.Subcode
WHERE i.USN = '1BI15CS101';

-- 4. Calculate FinalIA (average of best two test marks)
UPDATE IAMARKS
SET FinalIA = (
    SELECT AVG(best_two)
    FROM (
        SELECT AVG(test_score) as best_two
        FROM (
            SELECT Test1 as test_score FROM IAMARKS WHERE USN = IAMARKS.USN AND Subcode = IAMARKS.Subcode
            UNION ALL
            SELECT Test2 FROM IAMARKS WHERE USN = IAMARKS.USN AND Subcode = IAMARKS.Subcode
            UNION ALL
            SELECT Test3 FROM IAMARKS WHERE USN = IAMARKS.USN AND Subcode = IAMARKS.Subcode
        ) t
        GROUP BY USN, Subcode
        ORDER BY test_score DESC
        LIMIT 2
    ) best_scores
);

-- 5. Categorize students based on FinalIA
SELECT 
    s.USN,
    s.SName,
    i.FinalIA,
    CASE 
        WHEN i.FinalIA >= 17 AND i.FinalIA <= 20 THEN 'Outstanding'
        WHEN i.FinalIA >= 12 AND i.FinalIA <= 16 THEN 'Average'
        WHEN i.FinalIA < 12 THEN 'Weak'
    END as CAT
FROM STUDENT s
JOIN IAMARKS i ON s.USN = i.USN
JOIN SEMSEC ss ON i.SSID = ss.SSID
WHERE ss.Sem = 8 AND ss.Sec IN ('A', 'B', 'C')
ORDER BY i.FinalIA DESC; 