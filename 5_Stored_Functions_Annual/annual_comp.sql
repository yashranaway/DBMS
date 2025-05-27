DELIMITER //

CREATE FUNCTION USER_ANNUAL_COMP(
    p_eno INT,
    p_sal DECIMAL(10,2),
    p_comm DECIMAL(10,2)
) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE annual_compensation DECIMAL(10,2);
    
    -- If salary or commission is NULL, substitute with 0
    SET p_sal = IFNULL(p_sal, 0);
    SET p_comm = IFNULL(p_comm, 0);
    
    -- Calculate annual compensation
    SET annual_compensation = (p_sal + p_comm) * 12;
    
    RETURN annual_compensation;
END //

DELIMITER ;

-- Example usage:
-- SELECT 
--     empno,
--     sal,
--     comm,
--     USER_ANNUAL_COMP(empno, sal, comm) as annual_compensation
-- FROM EMP; 