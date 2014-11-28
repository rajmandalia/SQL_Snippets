
-- list logins and databases

DECLARE @chkname  sysname
DECLARE @SQLstr VARCHAR(2000)

SELECT @chkname = N'<Username,sysname,>'

SELECT * FROM sys.server_principals WHERE name = @chkname
SELECT @SQLstr = 'SELECT "?" FROM ?.sys.database_principals WHERE name = N''' + @chkname + ''''


EXEC sp_msforeachdb @SQLstr