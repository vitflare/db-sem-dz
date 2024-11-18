CREATE OR REPLACE FUNCTION get_years_service(p_employee_id INTEGER)
RETURNS NUMERIC 
LANGUAGE plpgsql AS $$
DECLARE
    v_years_service NUMERIC;
BEGIN
    -- Check if employee exists
    IF NOT EXISTS (SELECT 1 FROM employees WHERE employee_id = p_employee_id) THEN
        RAISE EXCEPTION 'Invalid employee ID: %', p_employee_id;
    END IF;

    -- Calculate years of service
    SELECT 
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(start_date))) 
    INTO v_years_service
    FROM (
        SELECT hire_date AS start_date FROM employees WHERE employee_id = p_employee_id
        UNION
        SELECT start_date FROM job_history WHERE employee_id = p_employee_id
    ) service_dates;

    RETURN COALESCE(v_years_service, 0);
END;
$$;

-- Usage examples
SELECT get_years_service(106); 