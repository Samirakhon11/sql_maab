/* 1.Table student */
CREATE TABLE student (
	id INT,
	name VARCHAR(50),
	age INT CHECK (age > 0)
);

ALTER TABLE student
ALTER COLUMN id INT NOT NULL;


/* 2.Table product */
CREATE TABLE product (
	product_id INT,
	product_name VARCHAR(100),
	price DECIMAL
	CONSTRAINT uq_product_id UNIQUE (product_id)
);

ALTER TABLE product
DROP CONSTRAINT uq_product_id;

ALTER TABLE product
ADD CONSTRAINT uq_product_id UNIQUE (product_id);	


/* 3.Tabel orders */
CREATE TABLE orders (
	order_id INT,
	customer_name VARCHAR(50),
	order_date INT
	CONSTRAINT key_order_id PRIMARY KEY (order_id)
);

ALTER TABLE orders
DROP CONSTRAINT key_order_id;

ALTER TABLE orders
ADD CONSTRAINT key_order_id PRIMARY KEY (order_id);


/* 4.FOREIGN KEY */
/* Table category */
CREATE TABLE category (
	category_id INT PRIMARY KEY,
	category_nama VARCHAR(100)
);

/* Table item */
CREATE TABLE item (
	item_id INT PRIMARY KEY,
	item_name VARCHAR(100),
	category_id INT,
	CONSTRAINT key_category_id FOREIGN KEY (category_id) REFERENCES category(category_id)
);

ALTER TABLE item
DROP CONSTRAINT key_category_id;

ALTER TABLE item
ADD CONSTRAINT key_category_id FOREIGN KEY (category_id) REFERENCES category(category_id)


/* 5.Check */
CREATE TABLE account (
	key_category_id INT PRIMARY KEY,
	balance DECIMAL,
	account_type VARCHAR(50)
	CONSTRAINT check_balance CHECK (balance >= 0),
	CONSTRAINT check_account_type CHECK (account_type IN ('Saving', 'Cheking'))
);

ALTER TABLE account
DROP CONSTRAINT check_balance;

ALTER TABLE account
DROP CONSTRAINT check_account_type;

ALTER TABLE account
ADD CONSTRAINT check_balance CHECK (balance >= 0);

ALTER TABLE account
ADD CONSTRAINT check_account_type CHECK (account_type IN ('Saving', 'Cheking'));


/* 6.Default */
CREATE TABLE customer (
	customer_id INT PRIMARY KEY,
	name VARCHAR(50),
	city VARCHAR(50)
	CONSTRAINT default_city DEFAULT ('Unknown') 
);

ALTER TABLE customer
DROP CONSTRAINT default_city;

ALTER TABLE customer
ADD CONSTRAINT default_city DEFAULT ('Unknown');


/* 7.Identity */
CREATE TABLE invoice (
	invoice_id INT IDENTITY PRIMARY KEY,
	amount DECIMAL
);

INSERT INTO invoice (amount) VALUES (100.50)
INSERT INTO invoice (amount) VALUES (80.54)
INSERT INTO invoice (amount) VALUES (150.00);
INSERT INTO invoice (amount) VALUES (80.20);
INSERT INTO invoice (amount) VALUES (300.10);

SET IDENTITY_INSERT invoice ON;

INSERT INTO invoice (invoice_id, amount) VALUES (100, 999.99) 

SET IDENTITY_INSERT invoice OFF;

SELECT * FROM invoice;


/* 8.All */
DROP TABLE IF EXISTS books;
CREATE TABLE books (
	book_id INT PRIMARY KEY IDENTITY,
	title VARCHAR(200) NOT NULL,
	price DECIMAL CHECK (price > 0),
	genre VARCHAR(100) DEFAULT ('Unknown') 
);

INSERT INTO books (title, price, genre) VALUES ('The Alchemist', 15.99, 'Fiction');
INSERT INTO books (title, price) VALUES ('Atomic Habits', 18.50); -- genre will be 'Unknown'
INSERT INTO books (title, price, genre) VALUES ('Clean Code', 25.00, 'Programming');
INSERT INTO books (title, price, genre) VALUES ('Dune', 22.30, 'Sci-Fi');
INSERT INTO books (title, price) VALUES ('Ikigai', 10.00); -- genre will be 'Unknown'

SELECT * FROM books


/* Library Management System */
CREATE TABLE Book (
	book_id INT PRIMARY KEY,
	title VARCHAR(100),
	author VARCHAR(100),
	published_year INT
);

CREATE TABLE Member (
	member_id INT PRIMARY KEY,
	name VARCHAR(50),
	email VARCHAR(250),
	phone_number VARCHAR(50)
);

CREATE TABLE Loan (
	loan_id INT PRIMARY KEY,
	book_id INT,
	member_id INT,
	loan_date DATE NOT NULL,
	return_date DATE
	CONSTRAINT ref_book_id FOREIGN KEY (book_id) REFERENCES Book(book_id),
	CONSTRAINT ref_member_id FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

-- Insert into Book
INSERT INTO Book (book_id, title, author, published_year) VALUES (1, '1984', 'George Orwell', 1949);
INSERT INTO Book (book_id, title, author, published_year) VALUES (2, 'To Kill a Mockingbird', 'Harper Lee', 1960);
INSERT INTO Book (book_id, title, author, published_year) VALUES (3, 'The Great Gatsby', 'F. Scott Fitzgerald', 1925);

-- Insert into Member
INSERT INTO Member (member_id, name, email, phone_number) VALUES (1, 'Alice Smith', 'alice@example.com', '123-456-7890');
INSERT INTO Member (member_id, name, email, phone_number) VALUES (2, 'Bob Johnson', 'bob@example.com', '234-567-8901');

-- Insert into Loan
INSERT INTO Loan (loan_id, book_id, member_id, loan_date, return_date) VALUES (1, 1, 1, '2025-04-01', '2025-04-10');
INSERT INTO Loan (loan_id, book_id, member_id, loan_date, return_date) VALUES (2, 2, 2, '2025-04-05', NULL);
INSERT INTO Loan (loan_id, book_id, member_id, loan_date, return_date) VALUES (3, 3, 1, '2025-04-08', NULL);

SELECT * FROM Book
SELECT * FROM Member
SELECT * FROM Loan