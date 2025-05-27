-- Create tables
CREATE TABLE PUBLISHER (
    Name VARCHAR(50) PRIMARY KEY,
    Address VARCHAR(100),
    Phone VARCHAR(15)
);

CREATE TABLE BOOK (
    Book_id INT PRIMARY KEY,
    Title VARCHAR(100),
    Publisher_Name VARCHAR(50),
    Pub_Year INT,
    FOREIGN KEY (Publisher_Name) REFERENCES PUBLISHER(Name)
);

CREATE TABLE BOOK_AUTHORS (
    Book_id INT,
    Author_Name VARCHAR(50),
    PRIMARY KEY (Book_id, Author_Name),
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id)
);

CREATE TABLE LIBRARY_PROGRAMME (
    Programme_id INT PRIMARY KEY,
    Programme_Name VARCHAR(50),
    Address VARCHAR(100)
);

CREATE TABLE BOOK_COPIES (
    Book_id INT,
    Programme_id INT,
    No_of_Copies INT,
    PRIMARY KEY (Book_id, Programme_id),
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id),
    FOREIGN KEY (Programme_id) REFERENCES LIBRARY_PROGRAMME(Programme_id)
);

CREATE TABLE BOOK_LENDING (
    Book_id INT,
    Programme_id INT,
    Card_No INT,
    Date_Out DATE,
    Due_Date DATE,
    PRIMARY KEY (Book_id, Programme_id, Card_No),
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id),
    FOREIGN KEY (Programme_id) REFERENCES LIBRARY_PROGRAMME(Programme_id)
);

-- 1. Retrieve details of all books in the library
SELECT 
    b.Book_id,
    b.Title,
    b.Publisher_Name,
    GROUP_CONCAT(ba.Author_Name) as Authors,
    GROUP_CONCAT(CONCAT(lp.Programme_Name, ': ', bc.No_of_Copies)) as Copies_Per_Programme
FROM BOOK b
LEFT JOIN BOOK_AUTHORS ba ON b.Book_id = ba.Book_id
LEFT JOIN BOOK_COPIES bc ON b.Book_id = bc.Book_id
LEFT JOIN LIBRARY_PROGRAMME lp ON bc.Programme_id = lp.Programme_id
GROUP BY b.Book_id, b.Title, b.Publisher_Name;

-- 2. Get particulars of borrowers who borrowed more than 3 books from Jan 2017 to Jun 2017
SELECT 
    Card_No,
    COUNT(*) as Books_Borrowed
FROM BOOK_LENDING
WHERE Date_Out BETWEEN '2017-01-01' AND '2017-06-30'
GROUP BY Card_No
HAVING COUNT(*) > 3;

-- 3. Delete a book and update related tables
-- First, delete related records from BOOK_LENDING
DELETE FROM BOOK_LENDING WHERE Book_id = [book_id_to_delete];

-- Then delete from BOOK_COPIES
DELETE FROM BOOK_COPIES WHERE Book_id = [book_id_to_delete];

-- Delete from BOOK_AUTHORS
DELETE FROM BOOK_AUTHORS WHERE Book_id = [book_id_to_delete];

-- Finally delete from BOOK
DELETE FROM BOOK WHERE Book_id = [book_id_to_delete];

-- 4. Partition the BOOK table based on year of publication
CREATE TABLE BOOK_PARTITIONED (
    Book_id INT,
    Title VARCHAR(100),
    Publisher_Name VARCHAR(50),
    Pub_Year INT,
    PRIMARY KEY (Book_id, Pub_Year)
) PARTITION BY RANGE (Pub_Year) (
    PARTITION p_2000_2005 VALUES LESS THAN (2006),
    PARTITION p_2006_2010 VALUES LESS THAN (2011),
    PARTITION p_2011_2015 VALUES LESS THAN (2016),
    PARTITION p_2016_2020 VALUES LESS THAN (2021),
    PARTITION p_2021_plus VALUES LESS THAN MAXVALUE
);

-- Example query on partitioned table
SELECT * FROM BOOK_PARTITIONED WHERE Pub_Year BETWEEN 2010 AND 2015;

-- 5. Create a view of available books
CREATE VIEW AVAILABLE_BOOKS AS
SELECT 
    b.Book_id,
    b.Title,
    ba.Author_Name,
    lp.Programme_Name,
    (bc.No_of_Copies - COUNT(bl.Book_id)) as Available_Copies
FROM BOOK b
JOIN BOOK_AUTHORS ba ON b.Book_id = ba.Book_id
JOIN BOOK_COPIES bc ON b.Book_id = bc.Book_id
JOIN LIBRARY_PROGRAMME lp ON bc.Programme_id = lp.Programme_id
LEFT JOIN BOOK_LENDING bl ON b.Book_id = bl.Book_id 
    AND bc.Programme_id = bl.Programme_id
    AND bl.Date_Out IS NOT NULL 
    AND bl.Due_Date > CURRENT_DATE
GROUP BY b.Book_id, b.Title, ba.Author_Name, lp.Programme_Name, bc.No_of_Copies; 