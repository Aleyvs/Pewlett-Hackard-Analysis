-- Retirement candidates

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- only 1952 

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- only 1953


SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';


-- only 1954


SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- only 1955


SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- age between 1952 and 1955 and hire date between 1985 and 1988

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- add retirement eligible employees list to csv

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create new table for retiring employees that includes emp_no
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;



-- Joining retirement_info and dept_emp tables
SELECT r.emp_no, r.first_name, r.last_name, de.to_date
FROM retirement_info as r
LEFT JOIN dept_emp as de
ON r.emp_no = de.emp_no;

-- Joining retirement_info and dept_emp tables to show current employees eligible for retirement

SELECT r.emp_no, r.first_name, r.last_name, de.to_date
INTO current_emp
FROM retirement_info as r
LEFT JOIN dept_emp as de
ON r.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- create new table showing Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retirement_dept_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- employee information: A list of employees containing 
-- their unique employee number, their last name, first name, gender, and salary

--step1. get employee information and crate a temporary table

SELECT emp_no,
    first_name,
    last_name,
    gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Step2. add the columns from salaries that are needed and join

SELECT e.emp_no,
    e.first_name,
    e.last_name,
    e.gender,
    s.salary,
    de.to_date
    --INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
         AND (de.to_date = '9999-01-01');


--Management: A list of managers for each department, including
--the department number, name, and the manager's employee number, last name, first name, 
--and the starting and ending employment dates

SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);


-- Department Retirees: An updated current_emp list that includes everything it currently has,
--  but also the employee's departments

SELECT  ce.emp_no,
        ce.first_name,
        ce.last_name,
        ce.to_date,
        d.dept_name
INTO dept_info
FROM current_emp as ce
    INNER JOIN dept_emp as de
        ON (ce.emp_no = de.emp_no)
    INNER JOIN departments as d
        ON (de.dept_no = d.dept_no);

-- Create a query that will return only the information relevant to the Sales team. 
-- The requested list includes:
--     Employee numbers
--     Employee first name
--     Employee last name
--     Employee department name

SELECT  di.emp_no,
        di.first_name,
        di.last_name,
        di.dept_name
INTO sales_info
FROM dept_info as di
WHERE di.dept_name = 'Sales';

-- Create another query that will return the following information for the Sales and Development teams:
--     Employee numbers
--     Employee first name
--     Employee last name
--     Employee department name


SELECT  di.emp_no,
        di.first_name,
        di.last_name,
        di.dept_name
INTO sales_dev_info
FROM dept_info as di
WHERE di.dept_name IN ('Sales', 'Development');