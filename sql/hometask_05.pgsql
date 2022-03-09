/* Delete all departments that never have any employees. */
BEGIN;
DELETE FROM public.departments
WHERE   department_id NOT IN (SELECT department_id
                              FROM public.employees
                              WHERE department_id IS NOT NULL
                              GROUP BY department_id)
    AND department_id NOT IN (SELECT department_id
                              FROM public.job_history
                              WHERE department_id IS NOT NULL
                              GROUP BY department_id);
ROLLBACK;


/* Increase salary for all programmers. */
BEGIN;
UPDATE public.employees
SET salary = salary + 1000
WHERE job_id = 'IT_PROG';
ROLLBACK;
