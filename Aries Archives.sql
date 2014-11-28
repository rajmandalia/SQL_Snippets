


-- From: <Source Db,sysname,>
-- To:   <Destination Db,sysname,>

-- Steps: 
	--Backup Source Database
	--Create Destination Database
	--Backup Destination Database
	--Restore Destination from Source Database
	--Shrink Destination Database Logs
	--Optimize Destination Indexes
	

USE Master
GO

GO
WHILE ( @@servername NOT IN ( 'EX30SQLARI02' ) )
    OR ( DB_NAME() NOT IN ( 'master' ) )
    BEGIN
        PRINT 'WRONG SERVER OR DATABASE: ' + @@servername + '.' + DB_NAME()
    END

SELECT 
	-- distinct
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
    AND DB_NAME(dbid) = '<Source Db,sysname,>'
ORDER BY
    loginame
go


--exec master.dbo.usp_killDBConnections USE <Source Db,sysname,>
--go


BACKUP DATABASE [<Source Db,sysname,>] 
	TO DISK = N'\\EX30SQLARI02\d$\SQL\Backups\BackupForArchive.BAK'
    WITH COPY_ONLY, NOFORMAT, INIT, 
    NAME = N'<Source Db,sysname,> - Full Database Backup For Archive', SKIP, NOREWIND,
    NOUNLOAD, STATS = 5
GO


-- create new database:
CREATE DATABASE [<Destination Db,sysname,>] 
	ON PRIMARY 
		( NAME = N'<Destination Db,sysname,>', FILENAME = N'd:\SQL\Aries_Archive\Database\<Destination Db,sysname,>.mdf', 
		SIZE = 3072KB , FILEGROWTH = 1024KB )
    LOG ON 
		( NAME = N'<Destination Db,sysname,>_Log', FILENAME = N'd:\SQL\Aries_Archive\Logs\<Destination Db,sysname,>_log.ldf',
		SIZE = 9216KB , FILEGROWTH = 10%)
GO

EXEC dbo.sp_dbcmptlevel @dbname = N'<Destination Db,sysname,>',
    @new_cmptlevel = 90
GO

BACKUP DATABASE [<Destination Db,sysname,>] TO DISK =
    N'\\EX30SQLARI02\d$\SQL\Backups\<Destination Db,sysname,>.bak'
    WITH NOFORMAT, NOINIT, NAME =
    N'<Destination Db,sysname,> - First Empty Database Backup', SKIP, NOREWIND,
    NOUNLOAD, STATS = 5
GO


-- restore from backup:
USE Master
go


RESTORE FILELISTONLY FROM DISK = N'\\EX30SQLARI02\d$\SQL\Backups\BackupForArchive.BAK'
    WITH FILE = 1
    
RESTORE DATABASE [<Destination Db,sysname,>] 
	FROM DISK = N'\\EX30SQLARI02\d$\SQL\Backups\BackupForArchive.BAK'
    WITH FILE = 1, MOVE N'Aries_SQL_Working' TO
    N'D:\SQL\Aries_Archive\Database\<Destination Db,sysname,>.mdf', MOVE
    N'Aries_SQL_Working_Log' TO
    N'D:\SQL\Aries_Archive\Logs\<Destination Db,sysname,>_log.ldf',
    NOUNLOAD, REPLACE, STATS = 10
GO

-- reset all security
USE [<Destination Db,sysname,>]
go


-- Emergency
--sp_detach_db [<Destination Db,sysname,>]
--restore database [<Destination Db,sysname,>] with RECOVERY

execute sp_refreshview N'ariesadmin.exco_ac_property'
execute sp_refreshview N'ariesadmin.nce_ac_property'
execute sp_refreshview N'ariesadmin.epop_ac_property'
execute sp_refreshview N'ariesadmin.exco_ac_product'
execute sp_refreshview N'ariesadmin.epop_ac_product'
execute sp_refreshview N'ariesadmin.nce_ac_product'
execute sp_refreshview N'ariesadmin.exco_ac_economic'
execute sp_refreshview N'ariesadmin.epop_ac_economic'
execute sp_refreshview N'ariesadmin.nce_ac_economic'
execute sp_refreshview N'ariesadmin.ADMIN'
execute sp_refreshview N'ariesadmin.EPOP'
execute sp_refreshview N'ariesadmin.EXCO'
execute sp_refreshview N'ariesadmin.NorthCoast'
	
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


-- disable locking
exec [ariesadmin].[SP_DIS_ENA_PROPERTY_LOCKDOWN] 'DISABLE'



-- shrink database logs
USE [<Destination Db,sysname,>]
GO


sp_helpdb [<Destination Db,sysname,>]
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
BACKUP LOG <Destination Db,sysname,>
TO DISK = 'd:\sql\backups\ShrinkLog.trn' 
WITH NOFORMAT, NOINIT,  
NAME = 'ShrinkLog', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- check Logical Lgs (2=In use, 0 = free)
DBCC LOGINFO

-- shrink Log
DBCC SHRINKFILE ('<Destination Db,sysname,>_Log' , 0, TRUNCATEONLY)
DBCC SHRINKFILE ('Aries_SQL_Working_Log' , 0, TRUNCATEONLY)

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





-- rebuild indexes

USE <Destination Db,sysname,>
GO


-- Raw results:   
--SELECT p.database_id, p.[object_id], p.index_id, p.partition_number, p.index_type_desc, p.alloc_unit_type_desc, p.index_depth, p.index_level, p.avg_fragmentation_in_percent, p.fragment_count, p.avg_fragment_size_in_pages, p.page_count, p.avg_page_space_used_in_percent, p.record_count, p.ghost_record_count, p.version_ghost_record_count, p.min_record_size_in_bytes, p.max_record_size_in_bytes, p.avg_record_size_in_bytes, p.forwarded_record_count
--	FROM sys.dm_db_index_physical_stats(DB_ID('<Destination Db,sysname,>'), NULL, NULL,NULL, 'LIMITED') p
--ORDER BY
--    p.avg_fragmentation_in_percent DESC
--   ,OBJECT_NAME(p.[object_id])


DECLARE @mResults TABLE (
	tDB_NAME sysname,
	tOBJ_ID INT,
	tTB_NAME sysname,
	tROWS_CNT BIGINT,
	tIX_NAME sysname,
	tIX_TYPE NVARCHAR(60),
	tALLOC_TYPE NVARCHAR(60),
	tAVG_FRAG FLOAT,
	tFRAG_CNT BIGINT,
	tPAGE_CNT BIGINT)
	
	

-- Report:
INSERT INTO @mResults
        ( tDB_NAME ,
		  tOBJ_ID, 
          tTB_NAME ,
          tROWS_CNT ,
          tIX_NAME ,
          tIX_TYPE ,
          tALLOC_TYPE ,
          tAVG_FRAG ,
          tFRAG_CNT ,
          tPAGE_CNT
        )
SELECT        
    DB_NAME(p.database_id)
   ,p.OBJECT_ID
   ,OBJECT_NAME(p.OBJECT_ID)
   ,p.record_count
   ,i.NAME AS IndexName
   ,p.index_type_desc
   ,p.alloc_unit_type_desc
   ,p.avg_fragmentation_in_percent
   ,p.fragment_count
   ,p.page_count
FROM
    sys.dm_db_index_physical_stats(DB_ID('<Destination Db,sysname,>'), NULL, NULL, NULL, 'DETAILED') p
    JOIN sys.indexes i
        ON p.object_id = i.object_id
           AND p.index_id = i.index_id
WHERE
    p.alloc_unit_type_desc <> 'LOB_DATA'
    AND p.avg_fragmentation_in_percent >= 10
    AND i.type_desc <> 'HEAP'
    ORDER BY p.avg_fragmentation_in_percent DESC, OBJECT_NAME(p.OBJECT_ID)

SELECT * from @mResults ORDER BY tAVG_FRAG DESC, tTB_NAME
   
-- Repair:
SET NOCOUNT ON

SELECT
'ALTER INDEX [' + r.tIX_NAME + '] ON [' + SCHEMA_NAME(t.schema_id) + '].['+ r.tTB_NAME + '] REORGANIZE'
    FROM @mResults r JOIN sys.tables t ON r.tOBJ_ID = t.object_id WHERE tAVG_FRAG < 30
    ORDER BY tAVG_FRAG DESC, tTB_NAME

SELECT
'ALTER INDEX [' + r.tIX_NAME + '] ON [' + SCHEMA_NAME(t.schema_id) + '].['+ r.tTB_NAME + '] REBUILD'
    + ' WITH (FILLFACTOR=80, ONLINE=OFF)'
    FROM @mResults r JOIN sys.tables t ON r.tOBJ_ID = t.object_id WHERE tAVG_FRAG >= 30
    ORDER BY tAVG_FRAG DESC, tTB_NAME

-- Table based Repair:
SELECT distinct
'ALTER INDEX ALL ON [' + SCHEMA_NAME(t.schema_id) + '].['+ r.tTB_NAME + '] REORGANIZE'
    FROM @mResults r JOIN sys.tables t ON r.tOBJ_ID = t.object_id WHERE tAVG_FRAG < 30

SELECT
'ALTER INDEX ALL ON [' + SCHEMA_NAME(t.schema_id) + '].['+ r.tTB_NAME + '] REBUILD'
    + ' WITH (FILLFACTOR=80, ONLINE=OFF)'
    FROM @mResults r JOIN sys.tables t ON r.tOBJ_ID = t.object_id WHERE tAVG_FRAG >= 30



