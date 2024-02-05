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
			      ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING
			    ), 2) AS avg_salary
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


/*
For each employee from EMPLOYEES table show last name of the first employee
hired in the same year and last employee, hired in the same year.
*/

SELECT first_name, last_name, hire_date, 
       FIRST_VALUE(last_name) OVER (PARTITION BY EXTRACT(YEAR FROM hire_date) 
			ORDER BY hire_date) AS first_hired,
       FIRST_VALUE(last_name) OVER (PARTITION BY EXTRACT(YEAR FROM hire_date)
			ORDER BY hire_date DESC) AS last_hired
FROM employees
ORDER BY EXTRACT(YEAR FROM hire_date);


 /*
Table TUMBLER stores "turn on" and "turn off" events
for some machine:
    - event_time - date and time of event
    - event_type - "ON" of "OFF"
Calculate how much time (in days) machine were ON and OFF
during period represented in TUMBLER table
Note: "ON" event can be followed by "OFF" event only and vice virsa

CREATE TABLE IF NOT EXISTS tumbler
(
    event_time TIMESTAMP NOT NULL,
    event_type VARCHAR
);

INSERT INTO tumbler (event_time, event_type)
VALUES ('2012-01-01','ON'),
	   ('2012-01-17','OFF'),
	   ('2012-01-19','ON'),
	   ('2012-02-28','OFF'),
	   ('2012-03-02','ON');

*/

SELECT event_type, SUM(diff) AS total_time
FROM (
	SELECT event_type,
	       LEAD(event_time, 1, CURRENT_DATE) OVER (ORDER BY event_time) - event_time AS diff
	FROM tumbler
) sq
GROUP BY event_type;
