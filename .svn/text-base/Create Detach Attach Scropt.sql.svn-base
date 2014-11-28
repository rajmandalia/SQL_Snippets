--********************************************************************************************************
--*	Author:  	Adam Wiedenhafer
--*	Date Written:	1/24/2002
--*	SQL Platform:	7.0/2000
--*
--*	Description:	This script will dynamically generate SQL code to attach and detach all user databases 
--*			from a server. Edits can be made to change and update destination (see area below).
--*			
--*
--*********************************************************************************************************

/***********Must first run this script in a database used for administrative purposes***************

use master
go
CREATE TABLE [dbo].[dbfiles] (
	[dbname] [varchar] (30) NOT NULL ,
	[fileid] [smallint] NOT NULL ,
	[filename] [nvarchar] (260) NULL 
) ON [PRIMARY]
go

*/



---------------------------------Generate Dynamic SQL to detach all user databases
print '                   SP_DETACH_DB STATEMENTS'

select
	'alter database [' + name + '] set single_user with rollback immediate'
from master..sysdatabases
where name not in ('master','model','msdb','pubs','northwind', 'tempdb', 'ReportServer', 'ReportServerTempDB')
order by name

select
	'EXEC master.dbo.sp_detach_db @dbname = ''' + name + ''', @keepfulltextindexfile=''true'''
	
from master..sysdatabases
where name not in ('master','model','msdb','pubs','northwind', 'tempdb', 'ReportServer', 'ReportServerTempDB')
order by name



go

---------------------------------Populate the dbfiles table with original file information
use master  -- Select database where above table (dbfiles) is created. DDL is above.

set nocount on

declare @dbasename varchar (1000)
truncate table dbfiles -- Empty all records in DBfiles table

--Open cursor with all user db names
declare cur_databasetab cursor local for
select name 
from master..sysdatabases
where name not in ('master','model','msdb','pubs','northwind', 'tempdb', 'endorse_db')
order by name

open cur_databasetab 
fetch next from cur_databasetab
into @dbasename
WHILE (@@FETCH_STATUS = 0) 
BEGIN 

declare @sqlstmt varchar(200)


select @sqlstmt = ('insert into dbfiles select ' + ''''+@dbasename + ''','+ ' fileid, ltrim(rtrim(filename)) from ' +'['+ @dbasename +']'+ '..sysfiles')
exec (@sqlstmt)

fetch next from cur_databasetab
into @dbasename

END
close cur_databasetab
deallocate cur_databasetab

/*


Add in an update statement to change file location information, if needed.

example:   Transaction Logs original location 	- c:\mssql7\data
	   Transaction Logs new location 	- e:\mssql7\data

update dbfiles
set filename = 'E' + substring(filename,2,200)
from dbfiles 
where fileid = 2 ----Move only transaction logs to new drive

I used this to move tran logs to new RAID 1 disk set. I had 74 database logs to move.
*/


--------------------------------This statement returns dynamically built sql to reattach all user dbs
print '                   SP_ATTACH_DB STATEMENTS'


select 'exec sp_attach_db @dbname = ''' + dbname + ''' ,'
+ char(13) + char(10) + char(9) + --spacing and tabs
'@filename1 ='''+(select b.filename from dbfiles b where b.fileid = 1 and a.dbname = b.dbname)+''','
+ char(13) + char(10) + char(9) + --spacing and tabs
'@filename2 ='''+ (select b.filename from dbfiles b where b.fileid = 2 and a.dbname = b.dbname)+'''' 
+ char(13) + char(10) +  char(10) --spacing and tabs
from dbfiles a
where dbname not in ('master','model','msdb','tempdb','pubs')
and fileid = 1 --so records are not listed twice
