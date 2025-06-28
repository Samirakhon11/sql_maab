/* TASK_1 */

DROP TABLE IF EXISTS Groupings

CREATE TABLE Groupings (
	[Step Number] INT,
	Status VARCHAR(50) CHECK (Status IN('Passed', 'Failed'))
);

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