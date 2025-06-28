/* Task_1 */
DROP TABLE  IF EXISTS Employees

CREATE TABLE Employees (
	EmployeeID INT PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Department VARCHAR(50),
	Salary DECIMAL(10, 2),
	HireDate DATE
)

SELECT * FROM Employees

SELECT Salary FROM Employees
SELECT TOP 10 PERCENT * FROM Employees
ORDER BY Salary DESC
SELECT Salary,
	CASE
		WHEN Salary > 80000 THEN 'HIGH'
		WHEN Salary BETWEEN 50000 AND 80000 THEN 'MEDIUM'
		ELSE 'LOW'
	END
	AS SalaryCategory
FROM Employees
ORDER BY Salary 
OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY 

SELECT Department, ROUND(AVG(Salary), 2) AS AverageSalary FROM Employees
GROUP BY Department
ORDER BY Salary DESC


/* Task_2 */
DROP TABLE IF EXISTS Orders

CREATE TABLE Orders (
	OrderID INT PRIMARY KEY,
	CustomerName VARCHAR(50),
	OrderDate DATE,
	TotalAmount DECIMAL(10, 2),
	Status VARCHAR(20), CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')) 
);

SELECT OrderDate FROM Orders
	WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31'

ALTER TABLE Orders
ADD OrderStatus VARCHAR(20)

UPDATE Orders
SET OrderStatus = 
	CASE
		WHEN Status IN('Shipped', 'Delivered') THEN 'Completed'
		WHEN Status = 'Pending' THEN 'Pending'
        WHEN Status = 'Cancelled' THEN 'Cancelled'
	END;
SELECT OrderStatus, COUNT(*) FROM Orders AS TotalOrders	
GROUP BY OrderStatus, 
	CASE 
		WHEN Status IN('Shipped', 'Delivered') THEN 'Completed'
		WHEN Status = 'Pending' THEN 'Pending'
        WHEN Status = 'Cancelled' THEN 'Cancelled'
	END;

SELECT OrderStatus, 
	COUNT(*) AS TotalOrders,
	SUM(TotalAmount) AS TotalRevenue
FROM Orders
GROUP BY OrderStatus
HAVING SUM(TotalAmount) > 5000
ORDER BY TotalRevenue DESC


/* Task_3 */
DROP TABLE IF EXISTS Products

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

SELECT Category, MAX(Price) AS MostExpensive FROM Products
GROUP BY Category;

SELECT Price, Stock,
	IIF (Stock = 0, 'out of stock',
		IIF (1 <= Stock AND Stock <= 10, 'low stock', 'stock'
		)
	)
	AS InventoryStatus 
FROM Products
ORDER BY Price DESC
OFFSET 5 ROWS FETCH NEXT 10000 ROWS ONLY;