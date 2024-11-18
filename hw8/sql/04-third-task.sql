CREATE OR REPLACE PROCEDURE upd_jobsal(
    p_job_id VARCHAR(10), 
    p_min_salary INTEGER, 
    p_max_salary INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
    -- Validate job ID
    IF NOT EXISTS (SELECT 1 FROM jobs WHERE job_id = p_job_id) THEN
        RAISE EXCEPTION 'Invalid job ID: %', p_job_id;
    END IF;

    -- Validate salary range
    IF p_max_salary < p_min_salary THEN
        RAISE EXCEPTION 'Maximum salary must be greater than minimum salary';
    END IF;

    -- Update job salaries
    UPDATE jobs 
    SET 
        min_salary = p_min_salary, 
        max_salary = p_max_salary
    WHERE job_id = p_job_id;
END;
$$;

-- Usage example
CALL upd_jobsal('SY_ANAL', 7000, 14000);