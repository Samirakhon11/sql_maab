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

INSERT INTO Products VALUES (1, 'Wireless Mouse', 'Electronics', 19.99, 150);
INSERT INTO Products VALUES (2, 'Gaming Keyboard', 'Electronics', 49.99, 0);
INSERT INTO Products VALUES (3, 'USB-C Charger', 'Electronics', 14.99, 200);
INSERT INTO Products VALUES (4, 'Bluetooth Speaker', 'Electronics', 29.99, 60);
INSERT INTO Products VALUES (5, 'LED Monitor 24"', 'Electronics', 129.99, 40);

INSERT INTO Products VALUES (6, 'Wooden Chair', 'Furniture', 45.00, 0);
INSERT INTO Products VALUES (7, 'Office Desk', 'Furniture', 120.00, 15);
INSERT INTO Products VALUES (8, 'Bookshelf', 'Furniture', 60.00, 30);
INSERT INTO Products VALUES (9, 'Sofa 3-Seater', 'Furniture', 399.99, 10);
INSERT INTO Products VALUES (10, 'Dining Table Set', 'Furniture', 299.99, 8);

INSERT INTO Products VALUES (11, 'Notebook A5', 'Stationery', 2.50, 500);
INSERT INTO Products VALUES (12, 'Gel Pen Pack', 'Stationery', 3.99, 300);
INSERT INTO Products VALUES (13, 'Highlighter Set', 'Stationery', 4.99, 250);
INSERT INTO Products VALUES (14, 'Stapler', 'Stationery', 6.49, 100);
INSERT INTO Products VALUES (15, 'Whiteboard Marker', 'Stationery', 1.99, 400);

INSERT INTO Products VALUES (16, 'Running Shoes', 'Clothing', 59.99, 80);
INSERT INTO Products VALUES (17, 'T-Shirt Cotton', 'Clothing', 14.99, 0);
INSERT INTO Products VALUES (18, 'Denim Jeans', 'Clothing', 39.99, 90);
INSERT INTO Products VALUES (19, 'Winter Jacket', 'Clothing', 89.99, 45);
INSERT INTO Products VALUES (20, 'Baseball Cap', 'Clothing', 12.99, 70);

INSERT INTO Products VALUES (21, 'Toothpaste', 'Personal Care', 2.49, 180);
INSERT INTO Products VALUES (22, 'Shampoo 500ml', 'Personal Care', 5.99, 140);
INSERT INTO Products VALUES (23, 'Face Wash', 'Personal Care', 4.75, 130);
INSERT INTO Products VALUES (24, 'Deodorant Stick', 'Personal Care', 3.99, 100);
INSERT INTO Products VALUES (25, 'Hand Sanitizer', 'Personal Care', 2.99, 160);

INSERT INTO Products VALUES (26, 'Coffee Maker', 'Home Appliances', 49.99, 35);
INSERT INTO Products VALUES (27, 'Toaster 2-Slice', 'Home Appliances', 24.99, 50);
INSERT INTO Products VALUES (28, 'Electric Kettle', 'Home Appliances', 29.99, 45);
INSERT INTO Products VALUES (29, 'Vacuum Cleaner', 'Home Appliances', 89.99, 20);
INSERT INTO Products VALUES (30, 'Air Fryer', 'Home Appliances', 99.99, 25);

SELECT Category, MAX(Price) AS MostExpensive FROM Products
GROUP BY Category

SELECT Stock,
	IIF (Stock = 0, 'out of stock',
		IIF (1 <= Stock AND Stock <= 10, 'low stock', 'stock'
		)
	)
	AS InventoryStatus 
FROM Products
ORDER BY Price DESC
OFFSET 5 ROWS FETCH NEXT 10000 ROWS ONLY;