CREATE OR REPLACE FUNCTION get_job_count(p_employee_id INTEGER)
RETURNS INTEGER 
LANGUAGE plpgsql AS $$
DECLARE
    v_job_count INTEGER;
BEGIN
    -- Check if employee exists
    IF NOT EXISTS (SELECT 1 FROM employees WHERE employee_id = p_employee_id) THEN
        RAISE EXCEPTION 'Invalid employee ID: %', p_employee_id;
    END IF;

    -- Count unique jobs
    WITH job_history_union AS (
        SELECT job_id FROM job_history WHERE employee_id = p_employee_id
        UNION
        SELECT job_id FROM employees WHERE employee_id = p_employee_id
    )
    SELECT COUNT(DISTINCT job_id) INTO v_job_count
    FROM job_history_union;

    RETURN v_job_count;
END;
$$;

-- Usage example
SELECT get_job_count(176);