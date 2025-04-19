/* task 1 */
DROP TABLE IF EXISTS test_identity
CREATE TABLE test_identity (
	id int IDENTITY,
	name VARCHAR(50)
);

INSERT INTO test_identity(name)
VALUES ('adam'), ('john'), ('smith'), ('brown'), ('steve')

SELECT * FROM test_identity

DELETE FROM test_identity

INSERT INTO test_identity(name)
VALUES ('bill'), ('anna')
SELECT * FROM test_identity

TRUNCATE TABLE test_identity
DROP TABLE test_identity


/* task 2 */
CREATE TABLE data_types_demo (
    id INT PRIMARY KEY,                        -- Int
    name VARCHAR(100),                         -- String
    birth_date DATE,                           -- Date
    height FLOAT,                              -- Float
    registered_at DATETIME,                    -- Date and time
    notes TEXT,                                -- Long text
    balance DECIMAL(10, 2),                    -- Decimal
    profile_picture VARBINARY(MAX)             -- Binary
);

INSERT INTO data_types_demo (id, name, birth_date, height,  registered_at, notes, balance, profile_picture) 
VALUES (
    1, 'Alice Smith', '2000-05-15', 1.65, '2025-04-19 10:30:00', 'First entry.', 2500.75, NULL
);

INSERT INTO data_types_demo (id, name, birth_date, height,  registered_at, notes, balance, profile_picture) 
VALUES (
    2, 'Bob Johnson', '1995-08-22', 1.78, '2025-04-18 09:15:00', 'Inactive user.', 0.00, NULL
);

SELECT * FROM data_types_demo;


/* task 3 */
CREATE TABLE photos (
	id INT PRIMARY KEY,
	photo varbinary(max)
);

INSERT INTO photos
SELECT 1, * FROM OPENROWSET (BULK 'D:\New folder\sql_maab\apple.jpg', SINGLE_BLOB) AS img_file

SELECT * FROM photos

SELECT @@SERVERNAME


/* task 4 */
CREATE TABLE student (
	name VARCHAR(50),
	student_id INT PRIMARY KEY,
	classes INT,
	tuition_per_class DECIMAL(10, 2),
	total_tuition AS (classes * tuition_per_class)
);

INSERT INTO student (student_id, name, classes, tuition_per_class)
VALUES (1, 'Alice', 4, 500.00), (2, 'Bob', 3, 400.00), (3, 'Charlie', 5, 450.00);

SELECT * FROM student;


/* task 5 */
CREATE TABLE worker (
	id INT,
	name VARCHAR(50)
);

BULK INSERT worker FROM 'D:\New folder\sql_maab\worker.csv' WITH (
	firstrow = 2,
	fieldterminator = ',',
	rowterminator = '\n'
)

SELECT * FROM worker