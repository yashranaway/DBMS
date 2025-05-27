DELIMITER //

-- 1. Stored procedure to get employee details
CREATE PROCEDURE GetEmployeeDetails(
    IN p_emp_id INT
)
BEGIN
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.email,
        e.phone_number,
        e.hire_date,
        e.salary,
        d.department_name,
        m.first_name as manager_first_name,
        m.last_name as manager_last_name
    FROM employees e
    LEFT JOIN departments d ON e.department_id = d.department_id
    LEFT JOIN employees m ON e.manager_id = m.employee_id
    WHERE e.employee_id = p_emp_id;
END //

-- 2. Stored procedure using cursor to fetch high-salary employees
CREATE PROCEDURE GetHighSalaryEmployees(
    IN p_min_salary DECIMAL(10,2)
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_emp_id INT;
    DECLARE v_first_name VARCHAR(20);
    DECLARE v_last_name VARCHAR(25);
    DECLARE v_salary DECIMAL(8,2);
    
    -- Declare cursor
    DECLARE emp_cursor CURSOR FOR 
        SELECT employee_id, first_name, last_name, salary
        FROM employees
        WHERE salary > p_min_salary
        ORDER BY salary DESC;
    
    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Create temporary table to store results
    DROP TEMPORARY TABLE IF EXISTS temp_high_salary_emps;
    CREATE TEMPORARY TABLE temp_high_salary_emps (
        employee_id INT,
        first_name VARCHAR(20),
        last_name VARCHAR(25),
        salary DECIMAL(8,2)
    );
    
    -- Open cursor
    OPEN emp_cursor;
    
    -- Start loop
    read_loop: LOOP
        -- Fetch next row
        FETCH emp_cursor INTO v_emp_id, v_first_name, v_last_name, v_salary;
        
        -- Exit loop if no more rows
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Insert into temporary table
        INSERT INTO temp_high_salary_emps
        VALUES (v_emp_id, v_first_name, v_last_name, v_salary);
        
    END LOOP;
    
    -- Close cursor
    CLOSE emp_cursor;
    
    -- Return results
    SELECT * FROM temp_high_salary_emps;
    
    -- Clean up
    DROP TEMPORARY TABLE IF EXISTS temp_high_salary_emps;
END //

DELIMITER ;

-- Example usage:
-- CALL GetEmployeeDetails(100);
-- CALL GetHighSalaryEmployees(50000); 