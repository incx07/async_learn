/*
Print out full name and email of employees,
having any doubled letter in last and first name.
*/

SELECT first_name||' '||last_name AS full_name, email
FROM employees
WHERE first_name ~ '(.)\1' AND last_name ~ '(.)\1'


/*
Considering that any record in the table regtest (created early test table) fits
the template (on the slide 30) return the list of unique cities.
*/

SELECT DISTINCT (matches[3]) AS city
FROM
  (
	  SELECT (regexp_matches(dt, '^(\w+), (\d|\w{8,}), (\w+)$')) AS matches
	  FROM regtest
  ) sq
