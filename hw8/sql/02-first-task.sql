CREATE OR REPLACE PROCEDURE new_job(
    p_job_id VARCHAR(10),
    p_job_title VARCHAR(35),
    p_min_salary INTEGER
) 
LANGUAGE plpgsql AS $$
BEGIN
    -- If job exists, update it
    UPDATE jobs 
    SET job_title = p_job_title,
        min_salary = p_min_salary,
        max_salary = p_min_salary * 2
    WHERE job_id = p_job_id;
    
    -- If job doesn't exist, insert it
    IF NOT FOUND THEN
        INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
        VALUES (p_job_id, p_job_title, p_min_salary, p_min_salary * 2);
    END IF;
END; 
$$;

-- Invoking the procedure
CALL new_job('SY_ANAL', 'System Analyst', 6000);