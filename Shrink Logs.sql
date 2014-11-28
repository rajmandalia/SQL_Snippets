


-- Shrink log files by running this repeatedly
-- do NOT USE in PRODUCTION Environment!!!!!


use master
go

-- find the log file name
sp_helpdb master
go

-- check for open trans
dbcc opentran


-- backup the log and shrink the file
-- run repeatedly until no furthur backups occur
BACKUP LOG  master TO DISK='C:\DeleteMe.bak'
go
DBCC SHRINKFILE ('mastlog' , 0)
go

-- drop extra logs if required
--ALTER DATABASE [master]  REMOVE FILE [script_v32.6.7 (F)_log2]
--go