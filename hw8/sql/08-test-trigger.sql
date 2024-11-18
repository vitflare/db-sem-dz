-- Check the current salary of the employee with the position SY_ANAL
SELECT employee_id, first_name, last_name, salary, job_id
FROM employees
WHERE job_id = 'SY_ANAL';

-- Trying to set salary range 8000-10000
UPDATE jobs 
SET min_salary = 8000, 
    max_salary = 10000 
WHERE job_id = 'SY_ANAL';