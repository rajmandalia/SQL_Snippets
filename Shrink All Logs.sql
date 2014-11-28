

DECLARE
    @DBName VARCHAR(255)
   ,@DBLogicalFileName VARCHAR(255)
   ,@DATABASES_Fetch INT

DECLARE DATABASES_CURSOR CURSOR
    FOR SELECT
            DATABASE_NAME = DB_NAME(MaTableMasterFiles.database_id)
           ,MaTableMasterFiles.name
        FROM
            sys.master_files MaTableMasterFiles
        WHERE
            -- ONLINE
            MaTableMasterFiles.state = 0
			-- Only look at databases to which we have access
            AND HAS_DBACCESS(DB_NAME(MaTableMasterFiles.database_id)) = 1
			-- Not master, tempdb or model
            AND DB_NAME(MaTableMasterFiles.database_id) NOT IN ( 'Master', 'tempdb', 'model' )
            AND type_desc LIKE 'log'
            -- and not EMK3
            AND LEFT(DB_NAME(MaTableMasterFiles.database_id),3) <> 'EMK'
        GROUP BY
            MaTableMasterFiles.database_id
           ,MaTableMasterFiles.name
        ORDER BY
            1


OPEN DATABASES_CURSOR

FETCH NEXT FROM DATABASES_CURSOR INTO @DBName, @DBLogicalFileName

WHILE @@FETCH_STATUS = 0

    BEGIN

		PRINT @DBName
		
        EXEC ( 'BACKUP LOG [' + @DBName + '] WITH TRUNCATE_ONLY'
            )

        EXEC
            ( 'Use [' + @DBName + '] DBCC SHRINKFILE ("' + @DBLogicalFileName
              + '")'
            )

        FETCH NEXT FROM DATABASES_CURSOR INTO @DBName, @DBLogicalFileName

    END



CLOSE DATABASES_CURSOR
DEALLOCATE DATABASES_CURSOR