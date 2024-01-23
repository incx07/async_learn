/* List all cities without departments using:
- OUTER JOIN,
- subquery with NOT IN,
- subquery with EXISTS. */

-- using OUTER JOIN:
SELECT l.city
FROM public.locations l
    LEFT JOIN public.departments d ON d.location_id = l.location_id
WHERE d.department_id IS NULL
ORDER BY l.city;

-- using subquery with NOT IN:
SELECT l.city
FROM public.locations l
WHERE l.location_id NOT IN (SELECT d.location_id 
                            FROM public.departments d)
ORDER BY l.city;

-- using subquery with EXISTS:
SELECT l.city
FROM public.locations l
WHERE NOT EXISTS (SELECT d.location_id 
                  FROM public.departments d 
                  WHERE d.location_id = l.location_id)
ORDER BY l.city;


/* List departments without employees using:
- NOT IN,
- EXISTS,
- ANY/ALL. */

-- using NOT IN:
SELECT d.department_name
FROM public.departments d
WHERE d.department_id NOT IN (SELECT e.department_id
                              FROM public.employees e
                              WHERE e.department_id IS NOT NULL)
ORDER BY d.department_name;

-- using EXISTS:
SELECT d.department_name
FROM public.departments d
WHERE NOT EXISTS (SELECT e.department_id
                  FROM public.employees e
                  WHERE e.department_id = d.department_id)
ORDER BY d.department_name;

-- using ANY/ALL:
SELECT d.department_name
FROM public.departments d
WHERE d.department_id != ALL (SELECT e.department_id
                              FROM public.employees e
                              WHERE e.department_id IS NOT NULL)
ORDER BY d.department_name;


/* Choose 3 the longest period in JOB_HISTORY table using:
- subqueries,
- TOP(LIMIT)/OFFSET. */

-- using subqueries:
SELECT lp.first_name, lp.last_name, lp.period
FROM (
    SELECT p.first_name, p.last_name, p.period, row_number() over() as rn
    FROM (
        SELECT e.first_name, e.last_name, 
            AGE(h.end_date, h.start_date) AS period
        FROM public.job_history h
            LEFT JOIN public.employees e ON h.employee_id = e.employee_id
        ORDER BY period DESC
        ) AS p
    ) AS lp
WHERE lp.rn <= 3;

-- using TOP(LIMIT)/OFFSET:
SELECT e.first_name, e.last_name, 
    AGE(h.end_date, h.start_date) AS period
FROM public.job_history h
    LEFT JOIN public.employees e ON h.employee_id = e.employee_id
ORDER BY period DESC
LIMIT 3 OFFSET 0;


/* For each department print (using JOIN and subqueries):
- name of the department,
- last name of the director (or "No Head"),
- total salary for the department (or 0). */

-- using subqueries:
SELECT d.department_name, 
    COALESCE((SELECT last_name 
              FROM public.employees 
              WHERE employee_id = d.manager_id), 'No Head') AS manager_name,
    COALESCE((SELECT SUM(salary) 
              FROM public.employees 
              WHERE department_id = d.department_id), 0) AS total_salary
FROM public.departments d
ORDER BY d.department_name;

-- using JOIN:
SELECT d.department_name, 
    COALESCE(e1.last_name, 'No Head')  AS manager_name, 
    COALESCE(SUM(e2.salary), 0) AS total_salary
FROM public.departments d
    LEFT JOIN public.employees e1 ON e1.employee_id = d.manager_id
    LEFT JOIN public.employees e2 ON e2.department_id = d.department_id
GROUP BY d.department_name, e1.last_name
ORDER BY d.department_name;
