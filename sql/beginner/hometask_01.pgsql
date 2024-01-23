/* Calculate the number of days till the end of the year. */
SELECT date_trunc('year', current_date + INTERVAL '1' YEAR) - current_date AS result;

 
/* List out experience for each employee, sort from old to newcomers.
If experience is the same, sort by salary. */

SELECT first_name||' '||last_name AS full_name,
       AGE(hire_date) AS experience,
       salary
FROM public.employees
ORDER BY experience DESC, salary DESC;
