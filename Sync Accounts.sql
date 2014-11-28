

SELECT  'sp_change_users_login ''Auto_Fix'', ''' + d.name + ''''
FROM    sys.database_principals d
        INNER JOIN sys.server_principals s ON d.name = s.name
WHERE   s.type_desc = 'SQL_USER' AND
        d.name NOT IN ( 'sys', 'dbo', 'guest', 'INFORMATION_SCHEMA' )
SELECT  'EXEC sp_change_users_login ''Report'''

