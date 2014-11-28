USE [master]
GO
ALTER DATABASE [<sysname,Databasename,>] SET RECOVERY SIMPLE WITH NO_WAIT
GO

USE [<sysname,Databasename,>]
GO
DBCC SHRINKDATABASE(N'<sysname,Databasename,>' )
GO

USE [master]
GO
ALTER DATABASE [<sysname,Databasename,>] SET RECOVERY FULL WITH NO_WAIT
GO

