DECLARE @InputDate VARCHAR(8) = '05032025';

-- Set DATEFIRST to Sunday
SET DATEFIRST 7;

-- Parse input date
DECLARE @Date DATE = CONVERT(DATE, STUFF(STUFF(@InputDate, 5, 0, '-'), 3, 0, '-'));
DECLARE @Year INT = YEAR(@Date);
DECLARE @Month INT = MONTH(@Date);
DECLARE @FirstOfMonth DATE = DATEFROMPARTS(@Year, @Month, 1);
DECLARE @DaysInMonth INT = DAY(EOMONTH(@FirstOfMonth));

-- Calculate offset (days before the first day of the month, if it doesn't start on Sunday)
DECLARE @Offset INT = DATEPART(WEEKDAY, @FirstOfMonth) - 1;

-- Generate calendar grid (42 days = 6 weeks)
WITH Numbers AS (
    SELECT TOP (42) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM master.dbo.spt_values
),
Calendar AS (
    SELECT
        DATEADD(DAY, n - @Offset, @FirstOfMonth) AS CalendarDate,
        n / 7 AS WeekNum
    FROM Numbers
),
CalendarWithDay AS (
    SELECT 
        WeekNum,
        DATENAME(WEEKDAY, CalendarDate) AS WeekdayName,
        CASE 
            WHEN MONTH(CalendarDate) = @Month THEN DAY(CalendarDate)
            ELSE NULL
        END AS DayValue
    FROM Calendar
)
SELECT
    MAX(CASE WHEN WeekdayName = 'Sunday' THEN DayValue END) AS Sunday,
    MAX(CASE WHEN WeekdayName = 'Monday' THEN DayValue END) AS Monday,
    MAX(CASE WHEN WeekdayName = 'Tuesday' THEN DayValue END) AS Tuesday,
    MAX(CASE WHEN WeekdayName = 'Wednesday' THEN DayValue END) AS Wednesday,
    MAX(CASE WHEN WeekdayName = 'Thursday' THEN DayValue END) AS Thursday,
    MAX(CASE WHEN WeekdayName = 'Friday' THEN DayValue END) AS Friday,
    MAX(CASE WHEN WeekdayName = 'Saturday' THEN DayValue END) AS Saturday
FROM CalendarWithDay
GROUP BY WeekNum
ORDER BY WeekNum;
