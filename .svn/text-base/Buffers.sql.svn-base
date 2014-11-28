USE master
GO

BEGIN
    DECLARE
        @MaxTransferSize FLOAT
       ,@BufferCount BIGINT
       ,@DBName VARCHAR(255)
       ,@BackupDevices BIGINT

-- Default value is zero. Value to be provided in MB.
    DECLARE @tDBList AS TABLE
        (
         dbname SYSNAME NOT NULL
        )

    INSERT INTO
        @tDBList ( dbname )
        SELECT
            NAME
        FROM
            sys.databases

    DECLARE cDBList CURSOR
        FOR SELECT
                *
            FROM
                @tDBList
            ORDER BY
                dbname


    SET @MaxTransferSize = 0
    SET @BufferCount = 0

    OPEN cDBList
    FETCH NEXT FROM cDBList INTO @DBName

    WHILE @@FETCH_STATUS = 0
        BEGIN

			-- Number of disk devices for backups
            SET @BackupDevices = 1

            DECLARE @DatabaseDeviceCount INT

            SELECT
                @DatabaseDeviceCount = COUNT(DISTINCT ( SUBSTRING(physical_name, 1, CHARINDEX(physical_name, ':') + 1) ))
            FROM
                sys.master_files
            WHERE
                database_id = DB_ID(@DBName)
                AND type_desc <> 'LOG'

            IF @BufferCount = 0 
                SET @BufferCount = ( @BackupDevices * 3 ) + @BackupDevices
                    + ( 2 * @DatabaseDeviceCount )

            IF @MaxTransferSize = 0 
                SET @MaxTransferSize = 1
	 
            PRINT @DBName + ' = '
                + CAST(( @Buffercount * @MaxTransferSize ) AS VARCHAR(10))
    
            FETCH NEXT FROM cDBList INTO @dbname
    
        END
    
    CLOSE cdblist
    
END