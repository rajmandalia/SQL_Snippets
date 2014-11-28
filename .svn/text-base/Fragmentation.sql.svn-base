
USE <Databasename, SYSNAME, >
GO


-- Raw results:   
--SELECT p.database_id, p.[object_id], p.index_id, p.partition_number, p.index_type_desc, p.alloc_unit_type_desc, p.index_depth, p.index_level, p.avg_fragmentation_in_percent, p.fragment_count, p.avg_fragment_size_in_pages, p.page_count, p.avg_page_space_used_in_percent, p.record_count, p.ghost_record_count, p.version_ghost_record_count, p.min_record_size_in_bytes, p.max_record_size_in_bytes, p.avg_record_size_in_bytes, p.forwarded_record_count
--	FROM sys.dm_db_index_physical_stats(DB_ID('<Databasename, SYSNAME, >'), NULL, NULL,NULL, 'LIMITED') p
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
    sys.dm_db_index_physical_stats(DB_ID('<Databasename, SYSNAME, >'), NULL, NULL, NULL, 'DETAILED') p
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


