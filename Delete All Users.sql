--SELECT  'exec sp_dropuser ''' + name + ''' '
--FROM    sysusers
--WHERE   name <> 'dbo'
--        AND islogin = 1


SELECT  'DROP USER [' + name + ']'
FROM    sysusers
WHERE   name <> 'dbo'
        AND islogin = 1