/*
(slide 26) Information about blank passport forms are stored in database table FORMS,
one row per form. Due to paper saving initiative, we should show available forms
in continuous ranges. Write a query to produce desired report.

CREATE TABLE IF NOT EXISTS forms
(
    seria character varying(30),
    numb integer
);
INSERT INTO forms(
	seria, numb)
	VALUES (AA,100000)
	VALUES (AA,100001)
	VALUES (AA,100005)
	VALUES (AA,100006)
	VALUES (BB,100004)
	VALUES (BB,100010)
	VALUES (BB,100011)
	VALUES (BB,100012);
*/

WITH prep AS (
    SELECT
        seria, numb,
        numb - ROW_NUMBER() OVER(PARTITION BY seria ORDER BY numb) as grp
    FROM forms
)
SELECT
    seria, MIN(numb) as numb1, MAX(numb) as numb2
FROM prep
GROUP BY seria, grp
ORDER BY seria, numb1;


/*
For each employee show they hire date, salary and average salary of two people who
hired just before him/her and three people hired just after.
*/

SELECT first_name, last_name, hire_date, salary,
	   ROUND(AVG(salary) OVER(ORDER BY hire_date
                         ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING), 2
			) AS avg_salary
FROM employees
ORDER BY hire_date;


/*
For each employee show total salary of people hired 90 days just before or after them.
*/

SELECT first_name, last_name, hire_date, salary,
	   SUM(salary) OVER(ORDER BY hire_date
                        RANGE BETWEEN INTERVAL '90 day' PRECEDING
						AND INTERVAL '90 day' FOLLOWING) AS total_salary
FROM employees
ORDER BY hire_date;
