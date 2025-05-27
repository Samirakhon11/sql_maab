DECLARE @SQL NVARCHAR(MAX) = ''

CREATE TABLE #AllColumns (
    DatabaseName SYSNAME,
    SchemaName SYSNAME,
    TableName SYSNAME,
    ColumnName SYSNAME,
    DataType SYSNAME
);

DECLARE db_cursor CURSOR FOR
SELECT name 
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')
  AND state = 0

OPEN db_cursor;

DECLARE @dbname SYSNAME;

FETCH NEXT FROM db_cursor INTO @dbname;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = '
    INSERT INTO #AllColumns (DatabaseName, SchemaName, TableName, ColumnName, DataType)
    SELECT 
        ''' + QUOTENAME(@dbname, '''') + ''' AS DatabaseName,
        sch.name AS SchemaName,
        tbl.name AS TableName,
        col.name AS ColumnName,
        typ.name AS DataType
    FROM ' + QUOTENAME(@dbname) + '.sys.columns col
    INNER JOIN ' + QUOTENAME(@dbname) + '.sys.tables tbl ON col.object_id = tbl.object_id
    INNER JOIN ' + QUOTENAME(@dbname) + '.sys.schemas sch ON tbl.schema_id = sch.schema_id
    INNER JOIN ' + QUOTENAME(@dbname) + '.sys.types typ ON col.user_type_id = typ.user_type_id
    WHERE tbl.is_ms_shipped = 0
    ';

    EXEC sp_executesql @SQL;

    FETCH NEXT FROM db_cursor INTO @dbname;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;

SELECT * FROM #AllColumns
ORDER BY DatabaseName, SchemaName, TableName, ColumnName;

DROP TABLE #AllColumns;
