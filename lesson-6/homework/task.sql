DROP TABLE IF EXISTS Departments;

CREATE TABLE Departments (
	DepartmentID INT PRIMARY KEY,
	DepartmentName VARCHAR(50)
);

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES 
    (101, 'IT'),
    (102, 'HR'),
    (103, 'Finance'),
    (104, 'Marketing');

DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
	EmployeeID INT PRIMARY KEY,
	Name VARCHAR(50),
	DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
	Salary INT
);

INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary)
VALUES
	(1, 'Alice', 101, 60000),
    (2, 'Bob', 102, 70000),
    (3, 'Charlie', 101, 65000),
    (4, 'David', 103, 72000),
    (5, 'Eva', NULL, 68000);

DROP TABLE IF EXISTS Projects;

CREATE TABLE Projects (
	ProjectID INT PRIMARY KEY, 
	ProjectName VARCHAR(100),
	EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID)
);

INSERT INTO Projects (ProjectID, ProjectName, EmployeeID)
VALUES 
    (1, 'Alpha', 1),
    (2, 'Beta', 2),
    (3, 'Gamma', 1),
    (4, 'Delta', 4),
    (5, 'Omega', NULL);

SELECT * FROM Employees
SELECT * FROM Departments
SELECT * FROM Projects

/* TASK1 */
SELECT
	e.EmployeeID,
	d.DepartmentName,
	e.Name,
	e.Salary
FROM Employees AS e
INNER JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID

/* TASK2 */
SELECT
	e.EmployeeID,
	d.DepartmentName,
	e.Name,
	e.Salary
FROM Employees AS e
LEFT JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID

/* TASK3 */
SELECT
	e.EmployeeID,
	d.DepartmentName,
	e.Name,
	e.Salary
FROM Employees AS e
RIGHT JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID

/* TASK4 */
SELECT
	e.DepartmentID, 
	e.Name,
	e.DepartmentID,
	d.DepartmentName,
	e.Salary
FROM Employees AS e
FULL OUTER JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID

/* TASK5 */
SELECT
	d.DepartmentID,
	d.DepartmentID,
	SUM(e.Salary) AS TotalSalary
FROM Departments AS d
LEFT JOIN Employees AS e
ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName

 
/* TASK6 */

--METHOD 1
SELECT * FROM Employees, Departments, Projects

--METHOD2
SELECT * FROM Employees CROSS JOIN Departments CROSS JOIN Projects

/* TASK7 */
SELECT 
	e.EmployeeID,
	e.Name,
	e.DepartmentID,
	d.DepartmentName,
	p.ProjectName
FROM Employees AS e
LEFT JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
LEFT JOIN Projects AS p ON p.EmployeeID = e.EmployeeID
