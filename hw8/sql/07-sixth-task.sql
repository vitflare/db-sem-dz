CREATE OR REPLACE FUNCTION check_job_salary_range()
RETURNS TRIGGER AS $$
DECLARE 
    invalid_employees RECORD;
BEGIN
    -- Check if any existing employees with this job_id have salaries outside the new range
    FOR invalid_employees IN 
        SELECT employee_id, first_name, last_name, salary 
        FROM employees 
        WHERE job_id = NEW.job_id 
          AND (salary < NEW.min_salary OR salary > NEW.max_salary)
    LOOP
        RAISE EXCEPTION 
            'Employee % % (ID: %) has salary % which is outside the new salary range % to %', 
            invalid_employees.first_name, 
            invalid_employees.last_name, 
            invalid_employees.employee_id, 
            invalid_employees.salary, 
            NEW.min_salary, 
            NEW.max_salary;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER CHECK_SAL_RANGE
BEFORE UPDATE OF min_salary, max_salary ON jobs
FOR EACH ROW
EXECUTE FUNCTION check_job_salary_range();