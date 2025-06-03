-- Input: Provide the date in 'YYYY-MM-DD' format
DECLARE @InputDate VARCHAR(20) = '2024-07-03';
DECLARE @Date DATE = TRY_CONVERT(DATE, @InputDate);

-- Extract first and last day of the month
DECLARE @FirstOfMonth DATE = DATEFROMPARTS(YEAR(@Date), MONTH(@Date), 1);
DECLARE @LastOfMonth DATE = EOMONTH(@FirstOfMonth);

-- Recursive CTE to build list of dates in the month
WITH Dates AS (
    SELECT @FirstOfMonth AS [Date]
    UNION ALL
    SELECT DATEADD(DAY, 1, [Date])
    FROM Dates
    WHERE DATEADD(DAY, 1, [Date]) <= @LastOfMonth
),
-- Add week and weekday info
LabeledDates AS (
    SELECT 
        [Date],
        DATENAME(WEEKDAY, [Date]) AS WeekDayName,
        DATEPART(WEEK, [Date]) - DATEPART(WEEK, @FirstOfMonth) + 1 AS WeekNumber,
        DATEPART(WEEKDAY, [Date]) AS DayOfWeek
    FROM Dates
),
-- Pivot the result: one row per week, columns for Sunday–Saturday
Calendar AS (
    SELECT 
        WeekNumber,
        [Date] AS ActualDate,
        CASE WHEN DATEPART(WEEKDAY, [Date]) = 1 THEN DAY([Date]) END AS Sunday,
        CASE WHEN DATEPART(WEEKDAY, [Date]) = 2 THEN DAY([Date]) END AS Monday,
        CASE WHEN DATEPART(WEEKDAY, [Date]) = 3 THEN DAY([Date]) END AS Tuesday,
        CASE WHEN DATEPART(WEEKDAY, [Date]) = 4 THEN DAY([Date]) END AS Wednesday,
        CASE WHEN DATEPART(WEEKDAY, [Date]) = 5 THEN DAY([Date]) END AS Thursday,
        CASE WHEN DATEPART(WEEKDAY, [Date]) = 6 THEN DAY([Date]) END AS Friday,
        CASE WHEN DATEPART(WEEKDAY, [Date]) = 7 THEN DAY([Date]) END AS Saturday
    FROM LabeledDates
)
SELECT 
    WeekNumber,
    MAX(Sunday)    AS Sunday,
    MAX(Monday)    AS Monday,
    MAX(Tuesday)   AS Tuesday,
    MAX(Wednesday) AS Wednesday,
    MAX(Thursday)  AS Thursday,
    MAX(Friday)    AS Friday,
    MAX(Saturday)  AS Saturday
FROM Calendar
GROUP BY WeekNumber
ORDER BY WeekNumber
OPTION (MAXRECURSION 1000);
