-- Create employee_log table
CREATE TABLE employee_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    action VARCHAR(10),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    first_name VARCHAR(20),
    last_name VARCHAR(25),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    hire_date DATE,
    job_id INT,
    salary DECIMAL(8,2),
    manager_id INT,
    department_id INT
);

-- Create trigger for employee logging
DELIMITER //

CREATE TRIGGER AfterInsertEmployee
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log (
        employee_id,
        action,
        first_name,
        last_name,
        email,
        phone_number,
        hire_date,
        job_id,
        salary,
        manager_id,
        department_id
    ) VALUES (
        NEW.employee_id,
        'INSERT',
        NEW.first_name,
        NEW.last_name,
        NEW.email,
        NEW.phone_number,
        NEW.hire_date,
        NEW.job_id,
        NEW.salary,
        NEW.manager_id,
        NEW.department_id
    );
END //

DELIMITER ;

-- Example usage:
-- INSERT INTO employees (first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
-- VALUES ('John', 'Doe', 'john.doe@example.com', '123-456-7890', '2024-01-01', 1, 50000, NULL, 1); 