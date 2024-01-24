/*
Find all departments that are either located in Canada (country_id = 'CA)
or have no less than 10 people.
*/

-- via subqueries and joins (without union)

SELECT COALESCE(q1.department_id, q2.department_id) department_id,
	   COALESCE(q1.department_name, q2.department_name) department_name
FROM (
	SELECT d.department_id, d.department_name
	FROM departments d, locations l
	WHERE d.location_id = l.location_id AND l.country_id = 'CA'
) q1 FULL JOIN (
	SELECT d.department_id , d.department_name
	FROM  departments d, employees e
	WHERE d.department_id = e.department_id
	GROUP BY d.department_id,  d.department_name
	HAVING COUNT(e.employee_id) >= 10
) q2 ON 1 = 0;


/*
List full names of people who worked or are currently working as "Programmer".
Specify “Currently” or “In the past” in a separate column.
*/

WITH programmer_id AS (SELECT job_id FROM jobs WHERE job_title = 'Programmer')

SELECT e.first_name || ' '||e.last_name AS full_name
FROM employees e
WHERE e.job_id = (SELECT * FROM programmer_id)
UNION
SELECT e.first_name || ' '||e.last_name
FROM employees e
WHERE e.employee_id IN (
	SELECT h.employee_id
	FROM job_history h
	WHERE h.job_id = (SELECT * FROM programmer_id)
);


/*
Find the most popular month for hiring people in company.
Include both current employees and historical data.
*/

SELECT month_number
FROM (
	SELECT EXTRACT(MONTH FROM MIN(hire_date)) AS month_number
	FROM (
		SELECT e.employee_id, e.hire_date
		FROM employees e
		UNION ALL
		SELECT h.employee_id, h.start_date
		FROM job_history h
	) sq
	GROUP BY employee_id
) q
GROUP BY month_number
ORDER BY COUNT(*) DESC
LIMIT 1;


/*
For each employee print their full name and a number of different positions (jobs)
they have worked at. Take into account current positions and JOB_HISTORY.
*/

SELECT full_name, COUNT(DISTINCT job_id)
FROM (
	SELECT e.first_name || ' '||e.last_name AS full_name, e.job_id
	FROM employees e
	UNION ALL
	SELECT e.first_name || ' '||e.last_name AS full_name, h.job_id
	FROM employees e INNER JOIN job_history h USING (employee_id)
) q
GROUP BY full_name


/*
Find out all employees, that are now on the same position and in the same department
as they were in the past.
*/

SELECT employee_id, job_id, department_id
FROM employees
INTERSECT
SELECT employee_id, job_id, department_id
FROM job_history;


/*
Delete all jobs that no one takes currently and no one took in the past
*/

DELETE FROM jobs
WHERE job_id IN (
	SELECT j.job_id
	FROM jobs j
	EXCEPT
	SELECT e.job_id
	FROM employees e
	EXCEPT
	SELECT h.job_id
	FROM job_history h
);
