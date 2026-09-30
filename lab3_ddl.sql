DROP TABLE IF EXISTS employee_archive, temp_employees, projects, departments, employees CASCADE;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50) DEFAULT 'Unassigned',
    salary INT DEFAULT 40000,
    hire_date DATE,
    status VARCHAR(50) DEFAULT 'Active'
);

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50),
    budget INT,
    manager_id INT
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    start_date DATE,
    end_date DATE,
    budget INT
);

INSERT INTO employees (emp_id, first_name, last_name, department) VALUES (1, 'John', 'Doe', 'IT');

INSERT INTO employees (first_name, last_name, salary, status) VALUES ('Alice', 'Smith', DEFAULT, DEFAULT);

INSERT INTO departments (dept_name, budget, manager_id) VALUES 
('IT', 120000, 1), ('Sales', 80000, 2), ('HR', 50000, 3);

INSERT INTO employees (first_name, last_name, hire_date, salary) 
VALUES ('Bob', 'Jones', CURRENT_DATE, 50000 * 1.1);

CREATE TABLE temp_employees AS SELECT * FROM employees WHERE department = 'IT';

UPDATE employees SET salary = salary * 1.10;

UPDATE employees SET status = 'Senior' WHERE salary > 60000 AND hire_date < '2020-01-01';

UPDATE employees SET department = CASE 
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;

UPDATE employees SET department = DEFAULT WHERE status = 'Inactive';

UPDATE departments d SET budget = budget * 1.2 
WHERE dept_name IN (SELECT department FROM employees);

UPDATE employees SET salary = salary * 1.15, status = 'Promoted' WHERE department = 'Sales';

DELETE FROM employees WHERE status = 'Terminated';

DELETE FROM employees WHERE salary < 40000 AND hire_date > '2023-01-01' AND department IS NULL;

DELETE FROM departments WHERE dept_id NOT IN (SELECT DISTINCT dept_id FROM projects WHERE dept_id IS NOT NULL);

INSERT INTO projects (project_name, end_date, budget) VALUES ('Old Proj', '2022-01-01', 10000);
DELETE FROM projects WHERE end_date < '2023-01-01' RETURNING *;

INSERT INTO employees (first_name, last_name, salary, department) VALUES ('Mike', 'Brown', NULL, NULL);

UPDATE employees SET department = 'Unassigned' WHERE department IS NULL;

DELETE FROM employees WHERE salary IS NULL OR department IS NULL;

INSERT INTO employees (first_name, last_name) VALUES ('Anna', 'Taylor') 
RETURNING emp_id, (first_name || ' ' || last_name) AS full_name;

UPDATE employees SET salary = salary + 5000 WHERE department = 'IT' 
RETURNING emp_id, salary - 5000 AS old_salary, salary AS new_salary;

DELETE FROM employees WHERE hire_date < '2020-01-01' RETURNING *;

INSERT INTO employees (first_name, last_name)
SELECT 'David', 'Clark'
WHERE NOT EXISTS (SELECT 1 FROM employees WHERE first_name = 'David' AND last_name = 'Clark');

UPDATE employees SET salary = salary * CASE 
    WHEN department IN (SELECT dept_name FROM departments WHERE budget > 100000) THEN 1.10
    ELSE 1.05
END;

WITH new_emps AS (
    INSERT INTO employees (first_name, last_name, salary) VALUES 
    ('E1','L1',30000), ('E2','L2',30000), ('E3','L3',30000), ('E4','L4',30000), ('E5','L5',30000)
    RETURNING emp_id
)
UPDATE employees SET salary = salary * 1.10 WHERE emp_id IN (SELECT emp_id FROM new_emps);

CREATE TABLE employee_archive AS SELECT * FROM employees WHERE 1=0;
WITH moved AS (
    DELETE FROM employees WHERE status = 'Inactive' RETURNING *
)
INSERT INTO employee_archive SELECT * FROM moved;

UPDATE projects SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000 AND dept_id IN (
    SELECT dept_id FROM departments WHERE dept_name IN (
        SELECT department FROM employees GROUP BY department HAVING COUNT(*) > 3
    )
);