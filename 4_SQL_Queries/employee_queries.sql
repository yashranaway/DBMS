-- Create tables
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(30) NOT NULL,
    location_id INT
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(25) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    hire_date DATE NOT NULL,
    job_id INT NOT NULL,
    salary DECIMAL(8, 2) NOT NULL,
    manager_id INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- 1. Find all employees who locate in the location with the id 1700
SELECT e.*
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.location_id = 1700;

-- 2. Find all employees who do not locate at the location 1700
SELECT e.*
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.location_id != 1700;

-- 3. Finds the employees who have the highest salary
SELECT *
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- 4. Finds all employees whose salaries are greater than the average salary of all employees
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 5. Finds all departments which have at least one employee with the salary is greater than 10,000
SELECT DISTINCT d.*
FROM departments d
JOIN employees e ON d.department_id = e.department_id
WHERE e.salary > 10000;

-- 6. Finds all departments that do not have any employee with the salary greater than 10,000
SELECT d.*
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
    AND e.salary > 10000
);

-- 7. Finds all employees whose salaries are greater than the lowest salary of every department
SELECT e.*
FROM employees e
WHERE e.salary > ALL (
    SELECT MIN(salary)
    FROM employees
    GROUP BY department_id
);

-- 8. Finds all employees whose salaries are greater than or equal to the highest salary of every department
SELECT e.*
FROM employees e
WHERE e.salary >= ALL (
    SELECT MAX(salary)
    FROM employees
    GROUP BY department_id
);

-- 9. Finds the salaries of all employees, their average salary, and the difference between the salary of each employee and the average salary
SELECT 
    employee_id,
    first_name,
    last_name,
    salary,
    (SELECT AVG(salary) FROM employees) as avg_salary,
    salary - (SELECT AVG(salary) FROM employees) as salary_difference
FROM employees; 