CREATE OR REPLACE PROCEDURE add_job_hist(
    p_employee_id INTEGER, 
    p_new_job_id VARCHAR(10)
)
LANGUAGE plpgsql AS $$
DECLARE
    v_hire_date DATE;
    v_min_salary NUMERIC;
BEGIN
    -- Check if employee exists
    SELECT hire_date INTO v_hire_date 
    FROM employees 
    WHERE employee_id = p_employee_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee % does not exist', p_employee_id;
    END IF;

    -- Get minimum salary for new job
    SELECT min_salary INTO v_min_salary 
    FROM jobs 
    WHERE job_id = p_new_job_id;

    -- Insert job history record
    INSERT INTO job_history 
    (employee_id, start_date, end_date, job_id, department_id)
    SELECT 
        employee_id, 
        hire_date, 
        CURRENT_DATE, 
        job_id, 
        department_id
    FROM employees 
    WHERE employee_id = p_employee_id;

    -- Update employee details
    UPDATE employees 
    SET 
        hire_date = CURRENT_DATE,
        job_id = p_new_job_id,
        salary = v_min_salary + 500
    WHERE employee_id = p_employee_id;
END;
$$;

-- Usage example
CALL add_job_hist(106, 'SY_ANAL');