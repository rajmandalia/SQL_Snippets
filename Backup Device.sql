-- Purpose : Script to create a dump device and dump a database to it
-- Author	: Raj Mandalia
-- Date	: 04/02/2002


sp_addumpdevice 
	'disk', 
	'<Db name,varchar,pubs>_<Ansi Date YYYYMMDD,varchar,20020101>', 
	'<Device path,varchar,C:\Program Files\Microsoft SQL Server\MSSQL\BACKUP\><Db name,varchar,pubs>_<Ansi Date YYYYMMDD,varchar,20020101>'
go

backup database <Db name,varchar,pubs> 
	to <Db name,varchar,pubs>_<Ansi Date YYYYMMDD,varchar,20020101>
go



