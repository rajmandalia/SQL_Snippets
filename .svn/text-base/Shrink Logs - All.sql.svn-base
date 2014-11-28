

-- Generic shrink all database logs on a server

SELECT 'BACKUP LOG [' + NAME + '] TO DISK = ''DeleteMe.trn'' WITH NOFORMAT, NOINIT, NAME = ''DeleteME'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'
	FROM sys.databases WHERE database_id > 6


SELECT 'DBCC LOGINFO; USE [' + NAME + ']; DBCC SHRINKFILE (N''Procount33_Log'' , 0, TRUNCATEONLY); DBCC LOGINFO'
	FROM sys.databases WHERE database_id > 6