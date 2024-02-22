/*
Select all managers of employee with phone_number= '650.505.2876'. Don't show the actual employee.
*/

WITH RECURSIVE cte AS (
	SELECT first_name, last_name, employee_id, manager_id, 1 AS level
	FROM employees
	WHERE phone_number = '650.505.2876'
	UNION ALL
	SELECT e.first_name, e.last_name, e.employee_id, e.manager_id, c.level + 1
	FROM cte c
	JOIN employees e ON e.employee_id = c.manager_id
	)
SELECT first_name, last_name, employee_id, manager_id, level
FROM cte
WHERE level != 1
ORDER BY level;


/*
Table contains one row and one field. This field stores some arithmetical
expression with numbers, arithmetic signs and parenthesis’s. For example,
2*((5+7)+2*(2+3))*8)+9
Write a query that will return each symbol from the string as a separate row.
*/

SELECT regexp_split_to_table('2*((5+7)+2*(2+3))*8)+9', '') AS symbol;


/*
For each employee of the 4th level list the full path from and to the root manager
(use regular expressions).
*/

WITH RECURSIVE cte AS (
  SELECT first_name, last_name, employee_id, manager_id, 1 AS level,
         first_name || ' ' || last_name AS path_from_root,
         first_name || ' ' || last_name AS path_to_root
  FROM employees
  WHERE manager_id IS NULL
  UNION ALL
  SELECT e.first_name, e.last_name, e.employee_id, e.manager_id, c.level + 1,
         c.path_from_root || ' -> ' || e.first_name || ' ' || e.last_name,
         e.first_name || ' ' || e.last_name || ' -> ' || c.path_to_root
  FROM cte c
  JOIN employees e ON e.manager_id = c.employee_id
)
SELECT first_name, last_name, level, path_from_root, path_to_root
FROM cte
WHERE level = 4
ORDER BY level;


/*
Find the manager with only one subordinate, who, in turn, has no subordinates
*/

SELECT m.employee_id, m.first_name, m.last_name
FROM employees m
JOIN (
    SELECT e.manager_id
    FROM employees e
    LEFT JOIN employees s ON e.employee_id = s.manager_id
    WHERE s.employee_id IS NULL
    GROUP BY e.manager_id
    HAVING COUNT(e.employee_id) = 1
) sq ON m.employee_id = sq.manager_id;
