/*
For each department having employees show the number of people working as 'SA_REP',
'ST_CLERK','IT_PROG' as well as total salary of such people.
*/

CREATE EXTENSION IF NOT EXISTS tablefunc;

WITH counts AS (
	SELECT *
	FROM crosstab(
		'SELECT d.department_name, e.job_id, COUNT(e.employee_id)
		 FROM Employees e JOIN Departments d ON e.department_id = d.department_id
		 WHERE e.job_id IN (''SA_REP'', ''ST_CLERK'', ''IT_PROG'')
		 GROUP BY d.department_name, e.job_id'
		,'VALUES (''SA_REP''), (''ST_CLERK''), (''IT_PROG'')'
	)
	AS (department_name text, "SA_REP_count" int, "ST_CLERK_count" int, "IT_PROG_count" int)
),

salaries AS (
	SELECT *
	FROM crosstab(
		'SELECT d.department_name, e.job_id, SUM(e.salary)
		 FROM Employees e JOIN Departments d ON e.department_id = d.department_id
		 WHERE e.job_id IN (''SA_REP'', ''ST_CLERK'', ''IT_PROG'')
		 GROUP BY d.department_name, e.job_id '
		,'VALUES (''SA_REP''), (''ST_CLERK''), (''IT_PROG'')'
	)
	AS (department_name text, "SA_REP_salary" numeric, "ST_CLERK_salary" numeric, "IT_PROG_salary" numeric)
)

SELECT counts.department_name,
       "SA_REP_count", "ST_CLERK_count", "IT_PROG_count",
       "SA_REP_salary", "ST_CLERK_salary", "IT_PROG_salary"
FROM counts
JOIN salaries ON counts.department_name = salaries.department_name;


/*
Select all subordinates of Steven King
*/

WITH RECURSIVE cte AS (
	SELECT first_name, last_name, employee_id, manager_id, 1 AS level
	FROM employees
	WHERE first_name = 'Steven' AND last_name = 'King'
	UNION ALL
	SELECT e.first_name, e.last_name, e.employee_id, e.manager_id, c.level + 1
	FROM cte c
	JOIN employees e ON e.manager_id = c.employee_id
	)
SELECT first_name, last_name, employee_id, manager_id, level
FROM cte
ORDER BY level;


/*
Generate dates from now (sysdate) till the end of the year.
*/

-- using a Recursive CTE

WITH RECURSIVE date_series AS (
	SELECT current_date AS date
	UNION ALL
	SELECT (date + INTERVAL '1 day')::date
	FROM date_series
	WHERE date < (date_trunc('year', current_date) + INTERVAL '1 year' - INTERVAL '1 day')::date
)
SELECT date FROM date_series;

-- using a generate_series function

SELECT generate_series(
	date_trunc('day', current_date),
	date_trunc('year', current_date) + '1 year' - INTERVAL '1 day',
	INTERVAL '1 day'
) AS date;
