/* task1 */

CREATE TABLE Employees
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);

INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');

SELECT * FROM Employees 

WITH cte AS (
	SELECT
		EmployeeID, 
		ManagerID,
		JobTitle,
		0 AS Depth
	FROM Employees
	WHERE ManagerID IS NULL 

	UNION ALL

	SELECT
		e.EmployeeID,
		e.ManagerID,
		e.JobTitle,
		c.Depth + 1
	FROM Employees AS e
	JOIN cte AS c ON e.ManagerID = c.EmployeeID
) 

SELECT * 
FROM cte
ORDER BY Depth, EmployeeID


/* task2 */
DECLARE @number INT = 10;

WITH cte AS (
	SELECT 1 AS n, 1 AS Factorial
	UNION ALL
	SELECT n + 1, Factorial * (n + 1)
	FROM cte
	WHERE n + 1 <= @number
) 

SELECT * FROM cte


/* task3 */
DECLARE @number INT = 10;

WITH cte AS (
	SELECT 1 AS n, 1 AS Fibonacci_Number
	UNION ALL
	SELECT n + 1, Fibonacci_Number + (n + 1)
	FROM cte
	WHERE n + 1 <= @number
)

SELECT * FROM cte