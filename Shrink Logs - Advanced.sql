USE [<Database Name,sysname,MyDatabase>]
GO


sp_helpdb [<Database Name,sysname,MyDatabase>]
go

-- check current connections
select 
	-- distinct
	left(loginame,30) as Loginame
	,left(hostname,30) as Hostname
	,case
		when dbid = 0 then null
		when dbid <> 0 then left(db_name(dbid),30)
	end as DBName
	,cmd as Command
from  master.dbo.sysprocesses
where spid between 0 and 32767
	and db_name(dbid) = db_name() -- current database only
order by loginame

-- check current open transactions
DBCC OPENTRAN

-- backup log
BACKUP LOG <Database Name,sysname,MyDatabase>
TO DISK = 'NUL' 
WITH NOFORMAT, NOINIT,  
NAME = 'NUL', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- check Logical Lgs (2=In use, 0 = free)
DBCC LOGINFO

-- shrink Log
declare @logname sysname

SELECT @logname = name
FROM sys.master_files
WHERE database_id = db_id()
  AND type = 1
  
DBCC SHRINKFILE (@logname , 0, TRUNCATEONLY)

-- check shrinkage
DBCC LOGINFO

-- repeate BACKUP and SHRINKFILE repeated until
-- size is acceptable

-- Individual File Size query
    SELECT name AS 'File Name' , physical_name AS 'Physical Name', size/128 AS 'Total Size in MB',
    size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS 'Available Space In MB'--, *
    FROM sys.database_files;

DBCC SQLPERF(LOGSPACE);
GO

