SELECT
    'alter database [' + name + '] set single_user with rollback immediate;'
FROM
    sys.databases
WHERE
    database_id > 6

SELECT
    'exec master.dbo.sp_detach_db @dbname = ''' + name
    + ''', @keepfulltextindexfile=''true'''
FROM
    sys.databases
WHERE
    database_id > 6


-- the > 6 is to skip the system database