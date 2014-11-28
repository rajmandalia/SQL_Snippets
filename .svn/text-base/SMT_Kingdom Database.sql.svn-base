--BEGIN TRAN
--ROLLBACK

USE master

GO
WHILE ( @@servername NOT IN ( 'EX73SQL01V' ) )
    OR ( DB_NAME() NOT IN ( 'master' ) )
    BEGIN
        PRINT 'WRONG SERVER OR DATABASE: ' + @@servername + '.' + DB_NAME()
    END



CREATE DATABASE [<Databasename, SYSNAME, db_name()>] ON  PRIMARY 
( NAME = N'<Databasename, SYSNAME, db_name()>', FILENAME = N'D:\SQL\SMTKingdom\Database\<Databasename, SYSNAME, db_name()>.mdf' , SIZE = 2048KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'<Databasename, SYSNAME, db_name()>_log', FILENAME = N'D:\SQL\SMTKingdom\Logs\<Databasename, SYSNAME, db_name()>_log.ldf' , SIZE = 1024KB , FILEGROWTH = 10%)
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET COMPATIBILITY_LEVEL = 100
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET ARITHABORT OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET  DISABLE_BROKER 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET  READ_WRITE 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET RECOVERY FULL 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET  MULTI_USER 
GO
ALTER DATABASE [<Databasename, SYSNAME, db_name()>] SET PAGE_VERIFY CHECKSUM  
GO
USE [<Databasename, SYSNAME, db_name()>]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [<Databasename, SYSNAME, db_name()>] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO



-- configure user [sql<Databasename, SYSNAME, db_name()>]

USE [master]
GO
CREATE LOGIN [sql<Databasename, SYSNAME, db_name()>] 
	WITH PASSWORD=N'<Password, SYSNAME, sdhfklje1$>', 
	DEFAULT_DATABASE=[<Databasename, SYSNAME, db_name()>], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [<Databasename, SYSNAME, db_name()>]
GO
CREATE USER [sql<Databasename, SYSNAME, db_name()>] FOR LOGIN [sql<Databasename, SYSNAME, db_name()>] WITH DEFAULT_SCHEMA=[dbo]
GO

EXEC sp_addrolemember N'db_owner', N'sql<Databasename, SYSNAME, db_name()>'
GO
