/* TASK_1 */

DROP TABLE IF EXISTS Groupings

CREATE TABLE Groupings (
	[Step Number] INT,
	Status VARCHAR(50) CHECK (Status IN('Passed', 'Failed'))
);

INSERT INTO Groupings 
VALUES
	(1, 'Passed'),
	(2, 'Passed'),
	(3, 'Passed'),
	(4, 'Passed'),
	(5, 'Failed'),
	(6, 'Failed'),
	(7, 'Failed'),
	(8, 'Failed'),
	(9, 'Failed'),
	(10, 'Passed'),
	(11, 'Passed'),
	(12, 'Passed')

SELECT * FROM Groupings

SELECT 
	MIN(g.[Step Number]) AS [Min Step Number],
	MAX(g.[Step Number]) AS [Max Step Number],
	g.Status,
	COUNT(*) AS [Consecutive Count]
FROM (
	SELECT 
		[Step Number],
		Status,
		ROW_NUMBER() OVER(ORDER BY [Step Number]) -
		ROW_NUMBER() OVER(PARTITION BY Status ORDER BY [Step Number]) AS G
	FROM Groupings
) AS g
GROUP BY g.G, g.Status
ORDER BY [Min Step Number];


/* TASK_2 */
CREATE TABLE [dbo].[EMPLOYEES_N]
(
    [EMPLOYEE_ID] [int] NOT NULL,
    [FIRST_NAME] [varchar](20) NULL,
    [HIRE_DATE] [date] NOT NULL
);

INSERT INTO EMPLOYEES_N (EMPLOYEE_ID, FIRST_NAME, HIRE_DATE)
VALUES
(1, 'Alice', '1975-06-10'),
(2, 'Bob', '1976-03-15'),
(3, 'Charlie', '1977-07-21'),
(4, 'David', '1979-11-09'),
(5, 'Eve', '1980-04-12'),
(6, 'Frank', '1982-05-23'),
(7, 'Grace', '1983-08-30'),
(8, 'Hannah', '1984-01-05'),
(9, 'Ivan', '1985-09-17'),
(10, 'Jack', '1990-02-28'),
(11, 'Karen', '1997-06-14'),
(12, 'Leo', '2000-12-31'),
(13, 'Mia', '2005-07-11'),
(14, 'Nina', '2010-09-19'),
(15, 'Oscar', '2011-10-22'),
(16, 'Pam', '2012-01-03'),
(17, 'Quinn', '2015-04-08'),
(18, 'Raj', '2016-11-11'),
(19, 'Sara', '2019-06-06'),
(20, 'Tom', '2020-03-03');

SELECT
	MIN(YEAR) AS StartYear,
	MAX(YEAR) AS EndYear
FROM (
	SELECT
		all_years.Year,
		all_years.Year - ROW_NUMBER() OVER(ORDER BY all_years.Year) AS grp
	FROM (
		SELECT TOP (YEAR(GETDATE()) - 1975 + 1)
			1975 + ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) - 1 AS Year
		FROM master.dbo.spt_values
	) AS all_years
	LEFT JOIN (
		SELECT DISTINCT YEAR(HIRE_DATE) AS HireYear FROM EMPLOYEES_N
	) AS HiredYears
	ON all_years.Year = HiredYears.HireYear
	WHERE HiredYears.HireYear IS NULL 
) AS MissingYear
GROUP BY grp
ORDER BY StartYear