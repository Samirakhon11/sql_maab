/* task1 */

CREATE TABLE Employees (
	EmployeeID INT PRIMARY KEY,
	Name VARCHAR(50),
	Department VARCHAR(50),
	Salary INT
);

INSERT INTO Employees 
VALUES 
	(1, 'Alice', 'HR', 5000),
	(2, 'Bob', 'IT', 7000),
	(3, 'Charlie', 'Sales', 6000),
	(4, 'David', 'HR', 5500),
	(5, 'Emma', 'IT', 7200)

SELECT * FROM Employees

CREATE TABLE #EmployeeTransfers (
	EmployeeID INT PRIMARY KEY,
	Name VARCHAR(50),
	Department VARCHAR(50),
	Salary INT
);

SELECT * INTO #EmployeeTransfers FROM Employees

SELECT
	EmployeeID,
	Name,
	CASE	
		WHEN Department = 'HR' THEN 'IT'	
		WHEN Department = 'IT' THEN 'Sales'
		WHEN Department = 'Sales' THEN 'HR'
	END AS SwappedDept,
	Salary
FROM #EmployeeTransfers

SELECT * FROM #EmployeeTransfers



/* task2 */
CREATE TABLE Orders_DB1 (
	OrderID INT PRIMARY KEY,
	CustomerName VARCHAR(50),
	Product VARCHAR(100),
	Quantity INT
);

INSERT INTO Orders_DB1
VALUES
	(101, 'Alice', 'Laptop', 1),
	(102, 'Bob', 'Phone', 2),
	(103, 'Charlie', 'Tablet', 1),
	(104, 'David', 'Monitor', 1)

CREATE TABLE Orders_DB2 (
	OrderID INT PRIMARY KEY,
	CustomerName VARCHAR(50),
	Product VARCHAR(100),
	Quantity INT
);

INSERT INTO Orders_DB2
VALUES
	(101, 'Alice', 'Laptop', 1),
	(103, 'Charlie', 'Tablet', 1)

DECLARE @MissingOrders TABLE (
	OrderID INT PRIMARY KEY,
	CustomerName VARCHAR(50),
	Product VARCHAR(100),
	Quantity INT
);

INSERT INTO @MissingOrders 
SELECT OrderID, CustomerName, Product, Quantity
FROM Orders_DB1
WHERE OrderID NOT IN (
	SELECT 
		OrderID 
	FROM Orders_DB2
)

SELECT * FROM @MissingOrders

/* task3 */
CREATE TABLE WorkLog (
	EmployeeID INT,
	EmployeeName VARCHAR(50),
	Department VARCHAR(50),
	WorkDate DATE,
	HoursWorked INT
);

INSERT INTO WorkLog (EmployeeID, EmployeeName, Department, WorkDate, HoursWorked)
VALUES
    (1, 'Alice', 'HR', '2024-03-01', 8),
    (2, 'Bob', 'IT', '2024-03-01', 9),
    (3, 'Charlie', 'Sales', '2024-03-02', 7),
    (1, 'Alice', 'HR', '2024-03-03', 6),
    (2, 'Bob', 'IT', '2024-03-03', 8),
    (3, 'Charlie', 'Sales', '2024-03-04', 9);

CREATE VIEW vw_MonthlyWorkSummary AS 
SELECT
	EmployeeID,
	EmployeeName,
	Department,
	SUM(HoursWorked) AS TotalHoursWorked,
	SUM(HoursWorked) AS TotalHoursDepartment,
	CAST(AVG(HoursWorked * 1.0) AS DECIMAL (10, 2)) AS AvgHoursDepartment
FROM WorkLog
GROUP BY EmployeeID, EmployeeName, Department;

SELECT * FROM vw_MonthlyWorkSummary;