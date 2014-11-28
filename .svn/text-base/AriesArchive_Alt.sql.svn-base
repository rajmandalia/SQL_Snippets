USE Aries_SQL_Working
GO

WHILE ( @@servername NOT IN ( 'EX30SQLARI02' ) )
    OR ( DB_NAME() NOT IN ( 'Aries_SQL_Working' ) )
    BEGIN
        PRINT 'WRONG SERVER OR DATABASE: ' + @@servername + '.' + DB_NAME()
    END
-- check for people who might be connected

SELECT 
    spid
   ,LEFT(loginame, 30) AS Loginame
   ,LEFT(hostname, 30) AS Hostname
   ,CASE WHEN dbid = 0 THEN NULL
         WHEN dbid <> 0 THEN LEFT(DB_NAME(dbid), 30)
    END AS DBName
   ,cmd AS Command
FROM
    master.dbo.sysprocesses
WHERE
    spid BETWEEN 0 AND 32767
    AND DB_NAME(dbid) = DB_NAME()
ORDER BY
    loginame
go

-- check locks if necessary
--EXEC sp_lock
--go


USE Master
go

-- kill call connections to Working if necessary
--exec master.dbo.usp_killDBConnections Aries_SQL_Working
--go


BACKUP DATABASE [Aries_SQL_Working] TO DISK =
    N'D:\SQL\Backups\Aries_SQL_Working\BackupForArchive.BAK'
    WITH COPY_ONLY, NOFORMAT, INIT, NAME =
    N'Aries_SQL_Working-Full Database Backup', SKIP, NOREWIND,
    NOUNLOAD, STATS = 10
GO


-- create new database:
CREATE DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] ON PRIMARY 
( NAME = N'Aries_SQL_Working', FILENAME = N'D:\SQL\ARIES_USER\Database\<Archive Database Name,sysname,Aries_SQL_ _20100101>.mdf' , SIZE = 3072KB , FILEGROWTH = 1024KB )
    LOG ON 
( NAME = N'Aries_SQL_Working_Log', FILENAME = N'D:\SQL\ARIES_USER\Logs\<Archive Database Name,sysname,Aries_SQL_ _20100101>_log.ldf' , SIZE = 9216KB , FILEGROWTH = 10%)
GO
EXEC dbo.sp_dbcmptlevel @dbname = N'Aries_SQL_SPOT123109_010510',
    @new_cmptlevel = 90
GO
IF ( 1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled') ) 
    BEGIN
        EXEC [<Archive Database Name,sysname,Aries_SQL_ _20100101>].[dbo].[sp_fulltext_database] @action = 'disable'
    END
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET ARITHABORT OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET CURSOR_DEFAULT GLOBAL 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET AUTO_UPDATE_STATISTICS_ASYNC
    OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET DATE_CORRELATION_OPTIMIZATION
    OFF 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET READ_WRITE 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET RECOVERY FULL 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET MULTI_USER 
GO
ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] SET PAGE_VERIFY CHECKSUM  
GO
USE [<Archive Database Name,sysname,Aries_SQL_ _20100101>]
GO
IF NOT EXISTS ( SELECT
                    name
                FROM
                    sys.filegroups
                WHERE
                    is_default = 1
                    AND name = N'PRIMARY' ) 
    ALTER DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] MODIFY FILEGROUP [PRIMARY]
        DEFAULT
GO

-- first backup:
BACKUP DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] TO DISK =
    N'NUL' --N'D:\SQL\Backups\<Archive Database Name,sysname,Aries_SQL_ _20100101>.bak'
    WITH NOFORMAT, NOINIT, NAME =
    N'Aries_SQL_SPOT123109_010510-Full Database Backup', SKIP, NOREWIND,
    NOUNLOAD, STATS = 5
GO


-- restore from backup:
USE Master
go

RESTORE DATABASE [<Archive Database Name,sysname,Aries_SQL_ _20100101>] FROM DISK =
    N'D:\SQL\Backups\Aries_SQL_Working\BackupForArchive.BAK' WITH FILE = 1, 
    MOVE 'Aries_SQL_Working' TO 'D:\SQL\ARIES_USER\Database\<Archive Database Name,sysname,Aries_SQL_ _20100101>.mdf', 
    MOVE 'Aries_SQL_Working_Log' TO 'D:\SQL\ARIES_USER\Logs\<Archive Database Name,sysname,Aries_SQL_ _20100101>_Log.ldf', 
    NOUNLOAD, REPLACE, STATS = 5
GO



-- reset all security
USE [<Archive Database Name,sysname,Aries_SQL_ _20100101>]
go

CREATE USER [EXCO\Aries_ArchiveData]
GO
EXEC sp_addrolemember N'db_datareader', N'EXCO\Aries_ArchiveData'
GO
EXEC sp_addrolemember N'db_datawriter', N'EXCO\Aries_ArchiveData'
GO


-- Permissions
USE [<Archive Database Name,sysname,Aries_SQL_ _20100101>]
go

--11.	 Create views for the ARIES tablesets to use on specific tables so that we can control access by DBS. 
--			We will “control” the AC_PROPERTY, AC_ECONOMIC, and AC_PRODUCT tables.
DROP VIEW ariesadmin.exco_ac_property
go
CREATE VIEW ariesadmin.exco_ac_property
AS  SELECT
        *
    FROM
        ariesadmin.ac_property
    WHERE
        dbskey = 'EXCO' ;
GO
DROP VIEW ariesadmin.nce_ac_property
go
CREATE VIEW ariesadmin.nce_ac_property
AS  SELECT
        *
    FROM
        ariesadmin.ac_property
    WHERE
        dbskey = 'NCE' ;
GO
DROP VIEW ariesadmin.epop_ac_property
go
CREATE VIEW ariesadmin.epop_ac_property
AS  SELECT
        *
    FROM
        ariesadmin.ac_property
    WHERE
        dbskey = 'EPOP' ;
GO
DROP VIEW ariesadmin.exco_ac_product
go
CREATE VIEW ariesadmin.exco_ac_product
AS  SELECT
        *
    FROM
        ariesadmin.ac_product
    WHERE
        propnum IN ( SELECT
                        propnum
                     FROM
                        ariesadmin.ac_property
                     WHERE
                        dbskey = 'EXCO' ) ;
GO
DROP VIEW ariesadmin.epop_ac_product
go
CREATE VIEW ariesadmin.epop_ac_product
AS  SELECT
        *
    FROM
        ariesadmin.ac_product
    WHERE
        propnum IN ( SELECT
                        propnum
                     FROM
                        ariesadmin.ac_property
                     WHERE
                        dbskey = 'EPOP' ) ;
GO
DROP VIEW ariesadmin.nce_ac_product
go
CREATE VIEW ariesadmin.nce_ac_product
AS  SELECT
        *
    FROM
        ariesadmin.ac_product
    WHERE
        propnum IN ( SELECT
                        propnum
                     FROM
                        ariesadmin.ac_property
                     WHERE
                        dbskey = 'NCE' ) ;
GO
DROP VIEW ariesadmin.exco_ac_economic
go
CREATE VIEW ariesadmin.exco_ac_economic
AS  SELECT
        *
    FROM
        ariesadmin.ac_economic
    WHERE
        propnum IN ( SELECT
                        propnum
                     FROM
                        ariesadmin.ac_property
                     WHERE
                        dbskey = 'EXCO' ) ;
GO
DROP VIEW ariesadmin.epop_ac_economic
go
CREATE VIEW ariesadmin.epop_ac_economic
AS  SELECT
        *
    FROM
        ariesadmin.ac_economic
    WHERE
        propnum IN ( SELECT
                        propnum
                     FROM
                        ariesadmin.ac_property
                     WHERE
                        dbskey = 'EPOP' ) ;
GO
DROP VIEW ariesadmin.nce_ac_economic
go
CREATE VIEW ariesadmin.nce_ac_economic
AS  SELECT
        *
    FROM
        ariesadmin.ac_economic
    WHERE
        propnum IN ( SELECT
                        propnum
                     FROM
                        ariesadmin.ac_property
                     WHERE
                        dbskey = 'NCE' ) ;
GO



DROP VIEW [ariesadmin].[ADMIN]
	GO
CREATE VIEW [ariesadmin].[ADMIN]
AS  SELECT
        *
    FROM
        ariesadmin.AC_PROPERTY
	GO

DROP VIEW [ariesadmin].[EPOP]
	GO
CREATE VIEW [ariesadmin].[EPOP]
AS  SELECT
        *
    FROM
        ariesadmin.AC_PROPERTY
    WHERE
        ( DBSKEY = 'EPOP' )
	GO

DROP VIEW 	[ariesadmin].[EXCO]
	go
CREATE VIEW [ariesadmin].[EXCO]
AS  SELECT
        *
    FROM
        ariesadmin.AC_PROPERTY
    WHERE
        ( DBSKEY = 'EXCO' )
	GO

DROP VIEW [ariesadmin].[NorthCoast]
	go
CREATE VIEW [ariesadmin].[NorthCoast]
AS  SELECT
        *
    FROM
        ariesadmin.AC_PROPERTY
    WHERE
        ( DBSKEY = 'NCE' )
	GO
	
--13.	Assign core permissions to objects.

GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_AOFTEST TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_CALC TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.TBLSETS TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.SUMPROPS TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT ON ariesadmin.AC_PROPERTY_AUDIT_COLUMNS TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_ECOSUM TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT ON ariesadmin.AC_PROPERTY_AUDIT TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_NOTE TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT ON ariesadmin.EXCO_RSV_CATS TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.PZCALCINS TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT ON ariesadmin.AC_PRODUCT TO [EXCO\Aries_Admin], [EXCO\Aries_Epop],
    [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_PZFCST TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_RATIO TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_RESERVES TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.PROJLIST TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_DAILY TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.PROJECT TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_ONELINE TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_SCENARIO TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_TEST TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARCURVE TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_DETAIL TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.GROUPTEST TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_SETUP TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARFILTER TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_SETUPDATA TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.GROUPTABLE TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.GROUPS TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARFILTERS TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.GROUPLIST TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ECOSTRM TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ECOPHASE TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARGRAPH TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARENDDATE TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARLOCK TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARLOOKUP TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARGRAPHCURVE TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARIESSCHEMAVERSION TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARPLOT TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARREPORTFORMAT TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT ON ariesadmin.DBSLIST TO [EXCO\Aries_Admin], [EXCO\Aries_Epop],
    [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARTREND TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARSTREAM TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.BKTITLES TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.BATCHMACROS TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARUNITTYPES TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARUNITS TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARSYSCOL TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_MONTHLY TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARSYSTBL TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT ON ariesadmin.AC_ECONOMIC TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARI_SCRIPT TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.AC_OWNER TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ARI_SCRIPTHDR TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.SELFILTERS TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.SORTFILTERS TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.SORTTITLE TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;
GRANT SELECT ON ariesadmin.AC_PROPERTY TO [EXCO\Aries_Admin],
    [EXCO\Aries_Epop], [EXCO\Aries_Exco], [EXCO\Aries_Nce] ;


--14.	Assign specific privileges.

GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.exco_ac_property TO [EXCO\Aries_Exco] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.nce_ac_property TO [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.epop_ac_property TO [EXCO\Aries_Epop] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.exco_ac_product TO [EXCO\Aries_Exco] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.epop_ac_product TO [EXCO\Aries_Epop] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.nce_ac_product TO [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.exco_ac_economic TO [EXCO\Aries_Exco] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.epop_ac_economic TO [EXCO\Aries_Epop] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.nce_ac_economic TO [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.EPOP TO [EXCO\Aries_Epop] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.NorthCoast TO [EXCO\Aries_Nce] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.EXCO TO [EXCO\Aries_Exco] ;
GRANT SELECT, INSERT, UPDATE, DELETE ON ariesadmin.ADMIN TO [EXCO\Aries_Admin] ;


-- Raj 03/31/2009, add insert permission to ac_property_audit to allow
-- trigger to add records when database is unlocked
GRANT INSERT ON  [ariesadmin].[AC_PROPERTY_AUDIT] TO [EXCO\Aries_Admin]
GRANT INSERT ON  [ariesadmin].[AC_PROPERTY_AUDIT] TO [EXCO\Aries_EPOP]
GRANT INSERT ON  [ariesadmin].[AC_PROPERTY_AUDIT] TO [EXCO\Aries_EXCO]
GRANT INSERT ON  [ariesadmin].[AC_PROPERTY_AUDIT] TO [EXCO\Aries_NCE]


-- shrink the log
-- backup log
BACKUP LOG [<Archive Database Name,sysname,Aries_SQL_ _20100101>]
TO DISK = 'NUL' 
WITH NOFORMAT, NOINIT,  
NAME = 'NUL', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- check Logical Lgs (2=In use, 0 = free)
DBCC LOGINFO

-- shrink Log
DBCC SHRINKFILE ('Aries_SQL_Working_Log' , 0, TRUNCATEONLY)

-- check shrinkage
DBCC LOGINFO



-- Done
PRINT 'Done creating [<Archive Database Name,sysname,Aries_SQL_ _20100101>]'


