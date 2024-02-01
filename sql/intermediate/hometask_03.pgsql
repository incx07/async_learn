/*
List the number of hired employees in the department for each year
*/

-- only this solution as PostgreSQL does not support PARTITION BY clause in the JOIN:

SELECT d.department_name,
	   EXTRACT(YEAR FROM e.hire_date) hire_year,
	   SUM( CASE
         	WHEN d.department_id = e.department_id THEN 1
         	ELSE 0
        	END) AS s
FROM departments d
     CROSS JOIN employees e
GROUP BY d.department_id, d.department_name, EXTRACT(YEAR FROM e.hire_date)
ORDER BY d.department_name, hire_year;


-- more complete version with series of years:

SELECT d.department_name, y.year, COALESCE(e.count, 0) as num_employees
FROM
    (SELECT DISTINCT department_name FROM departments) d
CROSS JOIN
    (SELECT generate_series(MIN(EXTRACT(YEAR FROM hire_date))::int,
                            MAX(EXTRACT(YEAR FROM hire_date))::int) AS year FROM employees) y
LEFT JOIN
    (SELECT d.department_id, d.department_name, EXTRACT(YEAR FROM e.hire_date) AS year, COUNT(e.employee_id) as count
     FROM employees e
	   LEFT JOIN departments d ON e.department_id = d.department_id
     GROUP BY d.department_id, d.department_name, EXTRACT(YEAR FROM e.hire_date)) e
     ON d.department_name = e.department_name AND y.year = e.year
ORDER BY d.department_name, y.year;


/*
Co-workers in department without employee itself:
*/

SELECT E1.department_id,
       E1.salary,
       E1.last_name,
       COALESCE(STRING_AGG(E2.last_name,', ' ORDER BY E2.last_name), '') AS colleagues
FROM employees E1
LEFT JOIN employees E2 ON E1.department_id = E2.department_id AND E1.employee_id <> E2.employee_id
GROUP BY E1.last_name, E1.department_id, E1.salary
ORDER BY E1.department_id, E1.last_name;


/*
1. For each employee show their salary and three average salaries:
  • for all employees,
  • for their job
  • for their department;
2. For each employee show average salary of people hired in the same year.
3. For each employee, show comma-separated list of people managed by the same manager.
*/

SELECT e.first_name||' '||e.last_name as name, e.department_id,
       e.salary,
       e.job_id,
	     ROUND(AVG(salary) OVER (), 2) avg_over_all,
	     ROUND(AVG(salary) OVER (PARTITION BY job_id), 2) avg_over_job,
	     ROUND(AVG(salary) OVER (PARTITION BY department_id), 2) avg_over_dep,
	     ROUND(AVG(salary) OVER (PARTITION BY EXTRACT(YEAR FROM hire_date)), 2) avg_over_year,
	     STRING_AGG(last_name, ', ') OVER (PARTITION BY manager_id) same_manager
FROM employees e;


/*
Typical top-N query can be understood as:
• return exactly N rows. If there's a "tail" - ignore it;
• return all records with one of first N values;
• return N rows + tail if it exists;
• return not more than N rows (if last value has tail - don't get rows with last value);
Implement each of these approaches (EMPLOYEES table, salary column, N=5).
*/

-- return exactly N rows. If there's a "tail" - ignore it:

SELECT *
FROM (
    SELECT last_name, salary,
           ROW_NUMBER() OVER (ORDER BY salary DESC) AS rownum
    FROM employees
) t
WHERE rownum <= 5;

-- return all records with one of first N values:

SELECT *
FROM (
    SELECT last_name, salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS mcduck_rank
    FROM employees
) t
WHERE mcduck_rank <= 5;

-- return N rows + tail if it exists:

SELECT *
FROM (
    SELECT last_name, salary,
           RANK() OVER(ORDER BY salary DESC) AS mcduck_rank
    FROM employees
) AS t
WHERE mcduck_rank <= 5;


-- return not more than N rows (if last value has tail - don't get rows with last value):
-- (the solution below is not correct, I did not figure out the valid one)

WITH ranked_employees AS (
	SELECT * FROM (
		SELECT last_name, salary,
			   RANK() OVER (ORDER BY salary DESC) AS rank
		FROM employees) e
	WHERE e.rank <= 5
)
SELECT *
FROM (
    SELECT *,
           LEAD(rank) OVER (ORDER BY salary DESC) AS next_rank
    FROM ranked_employees
) t
WHERE (rank < 5) OR (rank = 5 AND next_rank > 5);
