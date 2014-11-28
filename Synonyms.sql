

-- generate script to drop and create synonyms for tables and procs for an entire database

SET NOCOUNT ON

SELECT 'USE <TargetDatabase,sysname,>' + CHAR(10) +
'GO '  + CHAR(10) +
'WHILE ( + @@SERVERNAME NOT IN ( ''<TargetServer,sysname,>'' ) )' + CHAR(10) +
'    OR ( DB_NAME() NOT IN ( ''<TargetDatabase,sysname,>'' ) )'  + CHAR(10) +
'    BEGIN'  + CHAR(10) +
'        PRINT ''WRONG SERVER OR DATABASE: '' + @@SERVERNAME + ''.'' + DB_NAME()'  + CHAR(10) +
'    END'
SELECT 
'IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N''' + '<Prefix, varchar,>' + NAME + '<Suffix, varchar,>' + ''') ' + 'DROP SYNONYM [dbo].[' + '<Prefix, varchar,>' + NAME + '<Suffix, varchar,>' + '];'
AS '-- Drop Table Synonyms'
FROM sys.tables where TYPE = 'U'

SELECT 
'CREATE SYNONYM [dbo].[' + '<Prefix, varchar,>' + NAME + '<Suffix, varchar,>' + '] FOR [' + @@SERVERNAME + '].['  +  DB_NAME() + ']..[' + '<Prefix, varchar,>' + NAME + '<Suffix, varchar,>' + '];'
AS '-- Create Table Synonyms'
FROM sys.tables where TYPE = 'U'

SELECT 'GO'

SELECT 
'SELECT TOP 10 * FROM [' + '<Prefix, varchar,>' + NAME + '<Suffix, varchar,>' + ']'
AS '-- Testing Synonyms'
FROM sys.tables where TYPE = 'U'

SELECT 
'IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N''' + '<Prefix, varchar,>' + NAME + '<Suffix, varchar,>' + ''') ' + 'DROP SYNONYM [dbo].[' + '<Prefix, varchar,>' + NAME + '<Suffix, varchar,>' + '];'
AS '-- Drop Proc Synonyms'
FROM sys.procedures WHERE type = 'P'

SELECT 
'CREATE SYNONYM [dbo].[' + '<Prefix, varchar,>' + NAME + '<Suffix, varchar,>' + '] FOR [' + @@SERVERNAME + '].['  +  DB_NAME() + ']..[' + '<Prefix, varchar,>' + NAME + '<Suffix, varchar,>' + '];'
AS '-- Create Proc Synonyms'
FROM sys.procedures WHERE type = 'P'





