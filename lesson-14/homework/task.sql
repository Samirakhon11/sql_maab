DECLARE @tableHTML NVARCHAR(MAX);

-- 1. Build the HTML table with styling
SET @tableHTML =
    N'<html>
    <head>
        <style>
            table { font-family: Arial; border-collapse: collapse; width: 100%; }
            th, td { border: 1px solid #dddddd; padding: 8px; text-align: left; }
            th { background-color: #f2f2f2; }
        </style>
    </head>
    <body>
        <h2>SQL Server Index Metadata Report</h2>
        <table>
            <tr>
                <th>Table Name</th>
                <th>Index Name</th>
                <th>Index Type</th>
                <th>Column Name</th>
            </tr>';

-- 2. Append rows to the HTML table
SELECT @tableHTML +=
    N'<tr>
        <td>' + s.name + '.' + t.name + N'</td>
        <td>' + i.name + N'</td>
        <td>' + i.type_desc + N'</td>
        <td>' + c.name + N'</td>
    </tr>'
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN sys.tables t ON i.object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE i.type_desc <> 'HEAP'
ORDER BY s.name, t.name, i.name;

-- 3. Close HTML
SET @tableHTML += N'</table></body></html>';

-- 4. Send email using Database Mail
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'GoogleMail',  -- Replace with your mail profile name
    @recipients = 'miraculously510@gmail.com',  -- Replace with actual recipient
    @subject = 'SQL Server Index Metadata Report',
    @body = @tableHTML,
    @body_format = 'HTML';


--SELECT sent_status, * 
--FROM msdb.dbo.sysmail_allitems
--ORDER BY send_request_date DESC;