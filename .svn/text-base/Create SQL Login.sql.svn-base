
--<Username,sysname,>

USE [Master]
GO
CREATE LOGIN [<Username,sysname,>] 
	WITH PASSWORD='<Password,sysname,*>', 
	DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
USE [Master]
GO
CREATE USER [<Username,sysname,>] FOR LOGIN [<Username,sysname,>]
GO
USE [Masterview]
GO
EXEC sp_addrolemember N'db_datareader', N'<Username,sysname,>'
EXEC sp_addrolemember N'db_datawriter', N'<Username,sysname,>'
GO

