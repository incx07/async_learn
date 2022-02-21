/* List full name of employees with work experience more than 5 years or salary more than 15000. */
SELECT first_name||' '||last_name AS full_name
FROM public.employees
WHERE AGE(hire_date) > INTERVAL '1 year' OR salary > 15000;


/* List last name of employees who:
∙ works in the 10th department
∙ has more than 2000 as a salary
∙ was hired not later than 2001 */
SELECT last_name
FROM public.employees
WHERE department_id = 10 AND salary > 2000 AND hire_date < timestamp '2002-01-01';


/* List all countries with complex names (more than 2 words with space or ‘-’ delimiter). */
SELECT country_name
FROM public.countries
WHERE country_name SIMILAR TO '_+( |-)_+';


/* List all persons without first name or with a first name with the only one letter (‘J’ or ‘J.’). */
SELECT concat(first_name, ' ', last_name) AS full_name
FROM public.employees
WHERE first_name IS NULL OR first_name SIMILAR TO 'J.?';


/* Calculate the total salary of employees taking into account bonuses. */
SELECT trunc(sum(salary * (1 + COALESCE(commission_pct, 0))), 2) AS total_salary
FROM public.employees;


/* Print out the average salary for the jobs having more than 5 people. */
SELECT job_id, 
    trunc(avg(salary), 2) AS avg_salary
FROM public.employees
GROUP BY job_id
HAVING count(employee_id) > 5;


/* Print out departments, where all employees are on the same job. */
SELECT department_id
FROM public.employees
GROUP BY department_id
HAVING count(distinct(job_id)) = 1
ORDER BY department_id;


/* Print out departments, where all employees are on the different jobs. */
SELECT department_id
FROM public.employees
GROUP BY department_id
HAVING count(distinct(job_id)) = count(department_id)
ORDER BY department_id;


/* Print the average salary for each department (use EMPLOYEES table) */
SELECT department_id, 
    trunc(avg(salary), 2) AS avg_salary
FROM public.employees
GROUP BY department_id;


/* Print the amount of employees of each manager (use EMPLOYEES table) */
SELECT manager_id, count(employee_id) AS employees
FROM public.employees
GROUP BY manager_id;


/* Print the amount of employees hired in each day in 2003. 
Print the list of such employees (use EMPLOYEES table) */
SELECT count(employee_id) as count_of_employees, 
    STRING_AGG(concat(first_name, ' ', last_name),', ') as names_of_employees
FROM public.employees
WHERE hire_date > timestamp '2002-12-31' AND hire_date < timestamp '2004-01-01';


/*  Print all employees who has changed at least 2 jobs (use JOB_HISTORY) */
SELECT employee_id
FROM public.job_history
GROUP BY employee_id
HAVING count(distinct(job_id)) > 1;
