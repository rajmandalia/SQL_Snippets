USE [master]
GO


GO
WHILE ( @@servername NOT IN ( '<Host Server Name,sysname,EX30SQL>' ) )
    OR ( DB_NAME() NOT IN ( 'master' ) )
    BEGIN
        PRINT 'WRONG SERVER OR DATABASE: ' + @@servername + '.' + DB_NAME()
    END
-- drop if it exists
IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'<Target Server Name,sysname,EX30SQL>')
	EXEC master.dbo.sp_dropserver @server=N'<Target Server Name,sysname,EX30SQL>', @droplogins='droplogins'
GO


-- create linked server
EXEC master.dbo.sp_addlinkedserver @server = N'<Target Server Name,sysname,EX30SQL>', @srvproduct=N'SQL Server'
GO

-- all defaults except rpc and rpc out

EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'pub', @optvalue=N'false'
GO


EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'<Target Server Name,sysname,EX30SQL>', @optname=N'use remote collation', @optvalue=N'true'
GO

USE [master]
GO
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'<Target Server Name,sysname,EX30SQL>', @locallogin = NULL , @useself = N'True'
GO
