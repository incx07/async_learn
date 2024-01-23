/* Find out the number of employees in each department. Print:
- department name,
- the number of employees. */
SELECT d.department_name, COUNT(e.employee_id) AS employees
FROM public.departments d
    JOIN public.employees e ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY d.department_name;


/* Print out jobs, that nobody obtains. */
SELECT j.job_title, e.employee_id
FROM public.jobs j
    LEFT JOIN public.employees e ON j.job_id = e.job_id
WHERE e.employee_id IS NULL;


/* For each employee list their full name and full name of their manager. */
SELECT e1.first_name||' '||e1.last_name AS employee_name,
       e2.first_name||' '||e2.last_name AS manager_name
FROM public.employees e1
    LEFT JOIN public.employees e2 ON e1.manager_id = e2.employee_id;


/* Find out the number of employees in each department on each job. Print:
- department name,
- job title,
- the amount of employees (or zero). */
SELECT d.department_name, j.job_title, COUNT(e.employee_id) AS employees
FROM public.departments d
    LEFT JOIN public.employees e ON d.department_id = e.department_id
    FULL JOIN public.jobs j ON e.job_id = j.job_id
GROUP BY d.department_name, j.job_title
ORDER BY d.department_name;
