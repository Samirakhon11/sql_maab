DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
	EmployeeID    INT,
    Name          VARCHAR(50),
    Department    VARCHAR(50),
    Salary        DECIMAL(10,2),
    HireDate      DATE
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary, HireDate)
VALUES 
  (1, 'Alice Johnson',    'HR',         50000.00, '2019-03-15'),
  (2, 'Bob Smith',        'Finance',    52000.00, '2018-07-22'),
  (3, 'Charlie Brown',    'IT',         65000.00, '2020-11-30'),
  (4, 'Diana Adams',      'Marketing',  68000.00, '2021-05-10'),
  (5, 'Ethan Clark',      'IT',         70000.00, '2017-01-05'),
  (6, 'Fiona Davis',      'Finance',    64000.00, '2022-09-18'),
  (7, 'George Wilson',    'HR',         82000.00, '2020-02-25'),
  (8, 'Hannah Lee',       'IT',         80000.00, '2023-04-03'),
  (9, 'Ivan Petrov',      'Marketing',  55000.00, '2021-05-12'),
  (10, 'Julia Kim',       'Finance',    71000.00, '2016-12-01'),
  (11, 'Sophie Park',     'HR',         55000.00, '2021-07-12');


/* 1, 2 */
SELECT * FROM (
	SELECT *,
		DENSE_RANK() OVER(ORDER BY Salary) as rn
	FROM Employees 
) AS Ranked
WHERE rn IN (
	SELECT rn FROM (
		SELECT
			DENSE_RANK() OVER(ORDER BY Salary) as rn
		FROM Employees
	) AS RankedE
GROUP BY rn
HAVING COUNT(rn) > 1
);

SELECT * FROM Employees

/* 3 */
SELECT * FROM (
	SELECT *,
		RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS rnk 
	FROM Employees
) AS ordered
WHERE rnk <= 2


/* 4 */
SELECT * FROM (
	SELECT *,
		RANK() OVER(PARTITION BY Department ORDER BY Salary ASC) AS rnk
	FROM Employees
) AS ordered
WHERE rnk = 1


/* 5 */
SELECT *, 
	SUM(Salary) OVER(PARTITION BY Department ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS newColumn
FROM Employees


/* 6 */
SELECT *,
	SUM(Salary) OVER(PARTITION BY Department) AS TotalSalary
FROM Employees
/* 7 */
SELECT *,
	CAST(AVG(Salary) OVER(PARTITION BY Department) AS DECIMAL (10, 2)) as AverageSalary 
FROM Employees


/* 8 */
SELECT *,
	(CAST(ABS(Salary - (AVG(Salary) OVER(PARTITION BY Department))) AS DECIMAL (10, 2))) AS DifferenceFromAverage
FROM Employees


/* 9 */
SELECT *,
	CAST(AVG(Salary) OVER(PARTITION BY Department ORDER BY Salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS DECIMAL (10, 2)) AS MovingAverage
FROM Employees


/* 10 */
SELECT SUM(Salary) AS Last3 FROM (
	SELECT Salary,
		ROW_NUMBER() OVER(ORDER BY HireDate DESC) AS rn
	FROM Employees
) AS selected
WHERE rn <= 3

SELECT * FROM Employees

/* 11 */
SELECT *,
	CAST(AVG(Salary) OVER(ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS DECIMAL (10, 2)) AS MovingAverage
FROM Employees

/* 12 */
SELECT *,
	MAX(Salary) OVER(ORDER BY HireDate ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS Max5
FROM Employees
 
/* 13 */
SELECT *,
	CAST(Salary * 100 / SUM(Salary) OVER(PARTITION BY Department) AS DECIMAL (10, 2)) AS Percentage
FROM Employees