/*
Show list of DEPARTMENT_IDs having at least one employee with salary > 8000.
Show total salary for each such department.

The first possible solution:

       SELECT department_id, SUM(salary)
       FROM employees
       WHERE department_id IN (
              SELECT department_id
              FROM employees
              WHERE salary > 8000
              )
       GROUP BY department_id;

While this approach works, it has not the most efficient execution plan with two
Seq Scan on public.employees table (in PostreSQL).
What can be improved from performance point of view?

*/

SELECT department_id, SUM(salary) AS sum_salary
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 8000;


/*
Find out departments, where employees of the only one job are working.
Print:
- Department_id
- Job_id
*/

--#1 with subquery (less efficient):

SELECT DISTINCT department_id, job_id
FROM employees
WHERE department_id IN (
       SELECT department_id
       FROM employees
       GROUP BY department_id
       HAVING COUNT(DISTINCT job_id) = 1
);

--#2 without subqueries (better execution plan):

SELECT department_id, MIN(job_id) AS job_id
FROM employees
GROUP BY department_id
HAVING COUNT(DISTINCT job_id) = 1;
