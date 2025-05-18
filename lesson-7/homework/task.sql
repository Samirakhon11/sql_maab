CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Customers (CustomerID, CustomerName)
VALUES
(1, 'Alice Johnson'),
(2, 'Bob Smith'),
(3, 'Charlie Davis'),
(4, 'Diana Carter'),
(5, 'Ethan Clark'),
(6, 'Fiona Lee'),
(7, 'George Miller'),
(8, 'Hannah Kim'),
(9, 'Ivan Petrov'),
(10, 'Julia Park');

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate)
VALUES
(101, 1, '2024-05-01'),
(102, 2, '2024-05-02'),
(103, 3, '2024-05-03'),
(104, 1, '2024-05-04'),
(105, 5, '2024-05-05'),
(106, 6, '2024-05-06'),
(107, 7, '2024-05-07'),
(108, 8, '2024-05-08'),
(109, 9, '2024-05-09'),
(110, 10, '2024-05-10');

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price)
VALUES
(301, 101, 201, 1, 1200.00),
(302, 101, 205, 3, 5.50),
(303, 102, 202, 2, 650.00),
(304, 103, 203, 1, 180.00),
(305, 104, 204, 2, 15.00),
(306, 105, 206, 5, 3.20),
(307, 106, 208, 1, 45.00),
(308, 107, 207, 1, 99.99),
(309, 108, 209, 2, 35.00),
(310, 109, 210, 1, 250.00);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

INSERT INTO Products (ProductID, ProductName, Category)
VALUES
(201, 'Laptop', 'Electronics'),
(202, 'Smartphone', 'Electronics'),
(203, 'Desk Chair', 'Furniture'),
(204, 'Water Bottle', 'Accessories'),
(205, 'Notebook', 'Stationery'),
(206, 'Pen Set', 'Stationery'),
(207, 'Bluetooth Speaker', 'Electronics'),
(208, 'Backpack', 'Accessories'),
(209, 'Desk Lamp', 'Furniture'),
(210, 'Monitor', 'Electronics');

SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM OrderDetails
SELECT * FROM Products


/* 1 */
SELECT
	c.CustomerID,
	c.CustomerName,
	o.OrderID,
	o.OrderDate
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.CustomerID = o.CustomerID


/* 2 */
SELECT
	c.CustomerID,
	c.CustomerName,
	o.OrderID,
	o.OrderDate
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.CustomerID = o.CustomerID
WHERE O.OrderID IS NULL


/* 3 */
SELECT
	o.OrderID,
	o.OrderDate,
	p.ProductName,
	od.Quantity
FROM Orders AS o
JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
JOIN Products AS p
	ON p.ProductID = od.ProductID

/* 4 */
SELECT
	c.CustomerID,
	c.CustomerName,
	COUNT(o.OrderID) AS NumberOfOrders
FROM Customers AS c
JOIN Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 1	


/* 5 */
SELECT
    od.OrderID,
    od.ProductID,
    p.ProductName,
    od.Price
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
JOIN (
    SELECT 
		OrderID, MAX(Price) AS MaxPrice
    FROM OrderDetails
    GROUP BY OrderID
) maxPrice ON od.OrderID = maxPrice.OrderID AND od.Price = maxPrice.MaxPrice
ORDER BY od.Price DESC;

/* 6 */
SELECT
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate = (
    SELECT MAX(OrderDate)
    FROM Orders
    WHERE o.CustomerID = c.CustomerID
);


/* 7 */
SELECT
    c.CustomerID,
    c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING
    COUNT(DISTINCT CASE WHEN p.Category <> 'Electronics' THEN p.Category END) = 0;



/* 8 */
SELECT
	c.CustomerID, 
	c.CustomerName,
	o.OrderID,
	o.OrderDate
FROM Customers AS c
JOIN Orders AS o ON o.CustomerID = c.CustomerID
JOIN OrderDetails AS od ON od.OrderID = o.OrderID
JOIN Products AS p ON p.ProductID = od.ProductID
WHERE p.Category = 'Stationery'


/* 9 */
SELECT 
	c.CustomerID, 
	c.CustomerName,
	SUM(od.Price * od.Quantity) AS TotalSpent
FROM Customers AS c
JOIN Orders AS o ON o.CustomerID = c.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC;
