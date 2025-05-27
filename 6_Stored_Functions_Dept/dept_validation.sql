DELIMITER //

CREATE FUNCTION USER_VALID_DEPTNO(
    p_dno INT
) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE dept_exists INT;
    
    -- Check if department exists
    SELECT COUNT(*) INTO dept_exists
    FROM DEPT
    WHERE deptno = p_dno;
    
    -- Return TRUE if department exists, FALSE otherwise
    RETURN dept_exists > 0;
END //

DELIMITER ;

-- Example usage:
-- SELECT USER_VALID_DEPTNO(10); -- Returns TRUE if department 10 exists
-- SELECT USER_VALID_DEPTNO(99); -- Returns FALSE if department 99 doesn't exist 