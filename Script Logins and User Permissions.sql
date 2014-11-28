-- work in progress, not completed

USE [MASTER]
GO



IF OBJECT_ID('master.dbo.cp_ScriptUserPermissions') IS NOT NULL 
    DROP PROCEDURE dbo.cp_ScriptUserPermissions
GO

CREATE PROCEDURE dbo.cp_ScriptUserPermissions
    @DatabaseUserName SYSNAME
AS 
    BEGIN
	--Written By Bradley Morris
	--In Query Analyzer be sure to go to
	--Query -> Current Connection Options -> Advanced (Tab)
	--and set Maximum characters per column
	--to a high number, such as 10000, so
	--that all the code will be displayed.

	--http://www.sql-server-performance.com/articles/dba/object_permission_scripts_p1.aspx


        DECLARE
            @errStatement [varchar](8000)
           ,@msgStatement [varchar](8000)
           ,@DatabaseUserID [smallint]
           ,@ServerUserName [sysname]
           ,@RoleName [varchar](8000)
           ,@ObjectID [int]
           ,@ObjectName [varchar](261)

        SELECT
            @DatabaseUserID = [sysusers].[uid]
           ,@ServerUserName = [master].[dbo].[syslogins].[loginname]
        FROM
            [dbo].[sysusers]
            INNER JOIN [master].[dbo].[syslogins]
                ON [sysusers].[sid] = [master].[dbo].[syslogins].[sid]
        WHERE
            [sysusers].[name] = @DatabaseUserName
        IF @DatabaseUserID IS NULL 
            BEGIN
                SET @errStatement = 'User ' + @DatabaseUserName
                    + ' does not exist in ' + DB_NAME() + CHAR(13)
                    + 'Please provide the name of a current user in '
                    + DB_NAME() + ' you wish to script.'
                RAISERROR ( @errStatement, 16, 1 )
            END
        ELSE 
            BEGIN
                SET @msgStatement = '--Security creation script for user '
                    + @ServerUserName + CHAR(13) + '--Created At: '
                    + CONVERT(VARCHAR, GETDATE(), 112)
                    + REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', '')
                    + CHAR(13) + '--Created By: ' + SUSER_NAME() + CHAR(13)
                    + '--Add User To Database' + CHAR(13) + 'USE ['
                    + DB_NAME() + ']' + CHAR(13) + 'EXEC [sp_grantdbaccess]'
                    + CHAR(13) + CHAR(9) + '@loginame = ''' + @ServerUserName
                    + ''',' + CHAR(13) + CHAR(9) + '@name_in_db = '''
                    + @DatabaseUserName + '''' + CHAR(13) + 'GO' + CHAR(13)
                    + '--Add User To Roles'
                PRINT @msgStatement
                DECLARE _sysusers CURSOR LOCAL FORWARD_ONLY READ_ONLY
                    FOR SELECT
                            [name]
                        FROM
                            [dbo].[sysusers]
                        WHERE
                            [uid] IN ( SELECT
                                        [groupuid]
                                       FROM
                                        [dbo].[sysmembers]
                                       WHERE
                                        [memberuid] = @DatabaseUserID )
                OPEN _sysusers
                FETCH NEXT FROM _sysusers INTO @RoleName
                WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @msgStatement = 'EXEC [sp_addrolemember]'
                            + CHAR(13) + CHAR(9) + '@rolename = '''
                            + @RoleName + ''',' + CHAR(13) + CHAR(9)
                            + '@membername = ''' + @DatabaseUserName + ''''
                        PRINT @msgStatement
                        FETCH NEXT FROM _sysusers INTO @RoleName
                    END
                SET @msgStatement = 'GO' + CHAR(13)
                    + '--Set Object Specific Permissions'
                PRINT @msgStatement
                DECLARE _sysobjects CURSOR LOCAL FORWARD_ONLY READ_ONLY
                    FOR SELECT DISTINCT
                            ( [sysobjects].[id] )
                           ,'[' + USER_NAME([sysobjects].[uid]) + '].['
                            + [sysobjects].[name] + ']'
                        FROM
                            [dbo].[sysprotects]
                            INNER JOIN [dbo].[sysobjects]
                                ON [sysprotects].[id] = [sysobjects].[id]
                        WHERE
                            [sysprotects].[uid] = @DatabaseUserID
                OPEN _sysobjects
                FETCH NEXT FROM _sysobjects INTO @ObjectID, @ObjectName
                WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @msgStatement = ''
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 193
                                        AND [protecttype] = 205 ) 
                            SET @msgStatement = @msgStatement + 'SELECT,'
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 195
                                        AND [protecttype] = 205 ) 
                            SET @msgStatement = @msgStatement + 'INSERT,'
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 197
                                        AND [protecttype] = 205 ) 
                            SET @msgStatement = @msgStatement + 'UPDATE,'
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 196
                                        AND [protecttype] = 205 ) 
                            SET @msgStatement = @msgStatement + 'DELETE,'
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 224
                                        AND [protecttype] = 205 ) 
                            SET @msgStatement = @msgStatement + 'EXECUTE,'
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 26
                                        AND [protecttype] = 205 ) 
                            SET @msgStatement = @msgStatement + 'REFERENCES,'
                        IF LEN(@msgStatement) > 0 
                            BEGIN
                                IF RIGHT(@msgStatement, 1) = ',' 
                                    SET @msgStatement = LEFT(@msgStatement,
                                                             LEN(@msgStatement)
                                                             - 1)
                                SET @msgStatement = 'GRANT' + CHAR(13)
                                    + CHAR(9) + @msgStatement + CHAR(13)
                                    + CHAR(9) + 'ON ' + @ObjectName + CHAR(13)
                                    + CHAR(9) + 'TO ' + @DatabaseUserName
                                PRINT @msgStatement
                            END
                        SET @msgStatement = ''
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 193
                                        AND [protecttype] = 206 ) 
                            SET @msgStatement = @msgStatement + 'SELECT,'
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 195
                                        AND [protecttype] = 206 ) 
                            SET @msgStatement = @msgStatement + 'INSERT,'
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 197
                                        AND [protecttype] = 206 ) 
                            SET @msgStatement = @msgStatement + 'UPDATE,'
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 196
                                        AND [protecttype] = 206 ) 
                            SET @msgStatement = @msgStatement + 'DELETE,'
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 224
                                        AND [protecttype] = 206 ) 
                            SET @msgStatement = @msgStatement + 'EXECUTE,'
                        IF EXISTS ( SELECT
                                        *
                                    FROM
                                        [dbo].[sysprotects]
                                    WHERE
                                        [id] = @ObjectID
                                        AND [uid] = @DatabaseUserID
                                        AND [action] = 26
                                        AND [protecttype] = 206 ) 
                            SET @msgStatement = @msgStatement + 'REFERENCES,'
                        IF LEN(@msgStatement) > 0 
                            BEGIN
                                IF RIGHT(@msgStatement, 1) = ',' 
                                    SET @msgStatement = LEFT(@msgStatement,
                                                             LEN(@msgStatement)
                                                             - 1)
                                SET @msgStatement = 'DENY' + CHAR(13) + CHAR(9)
                                    + @msgStatement + CHAR(13) + CHAR(9)
                                    + 'ON ' + @ObjectName + CHAR(13) + CHAR(9)
                                    + 'TO ' + @DatabaseUserName
                                PRINT @msgStatement
                            END
                        FETCH NEXT FROM _sysobjects INTO @ObjectID,
                            @ObjectName
                    END
                CLOSE _sysobjects
                DEALLOCATE _sysobjects
                PRINT 'GO'
            END
    END

GO
-- end: CREATE PROCEDURE cp_ScriptUserPermissions



IF OBJECT_ID('master.dbo.cp_hexadecimal') IS NOT NULL 
        DROP PROCEDURE dbo.cp_hexadecimal
GO

CREATE PROCEDURE dbo.cp_hexadecimal
    @binvalue VARBINARY(256)
   ,@hexvalue VARCHAR(514) OUTPUT
AS 
    DECLARE
        @charvalue VARCHAR(514)
       ,@i INT
       ,@length INT
       ,@hexstring CHAR(16)

    SELECT
        @charvalue = '0x'
       ,@i = 1
       ,@length = DATALENGTH(@binvalue)
       ,@hexstring = '0123456789ABCDEF'
        
    WHILE ( @i <= @length )
        BEGIN
            DECLARE
                @tempint INT
               ,@firstint INT
               ,@secondint INT
            SELECT
                @tempint = CONVERT(INT, SUBSTRING(@binvalue, @i, 1))
               ,@firstint = FLOOR(@tempint / 16)
               ,@secondint = @tempint - ( @firstint * 16 )
               ,@charvalue = @charvalue + SUBSTRING(@hexstring, @firstint + 1,
                                                    1) + SUBSTRING(@hexstring, @secondint + 1, 1)
               ,@i = @i + 1
        END

    SELECT
        @hexvalue = @charvalue
GO

-- End: CREATE PROCEDURE dbo.cp_hexadecimal


 
 
IF OBJECT_ID('master.dbo.cp_help_CreateLogins') IS NOT NULL 
    DROP PROCEDURE dbo.cp_help_CreateLogins
GO


CREATE PROCEDURE dbo.cp_help_CreateLogins
    @login_name SYSNAME = NULL
AS 
    DECLARE
        @name SYSNAME
       ,@type VARCHAR(1)
       ,@hasaccess INT
       ,@denylogin INT
       ,@is_disabled INT
       ,@PWD_varbinary VARBINARY(256)
       ,@PWD_string VARCHAR(514)
       ,@SID_varbinary VARBINARY(85)
       ,@SID_string VARCHAR(514)
       ,@tmpstr VARCHAR(1024)
       ,@is_policy_checked VARCHAR(3)
       ,@is_expiration_checked VARCHAR(3)
       ,@DatabaseUserName [sysname]
       ,@errStatement [varchar](8000)
       ,@msgStatement [varchar](8000)
       ,@DatabaseUserID [smallint]
       ,@ServerUserName [sysname]
       ,@RoleName [varchar](8000)
       ,@ObjectID [int]
       ,@ObjectName [varchar](261)


    DECLARE @defaultdb SYSNAME
 
    IF ( @login_name IS NULL ) 
        DECLARE login_curs CURSOR
            FOR SELECT
                    p.sid
                   ,p.name
                   ,p.type
                   ,p.is_disabled
                   ,p.default_database_name
                   ,l.hasaccess
                   ,l.denylogin
                FROM
                    sys.server_principals p
                    LEFT JOIN sys.syslogins l
                        ON ( l.name = p.name )
                WHERE
                    p.type IN ( 'S', 'G', 'U' )
                    AND p.name <> 'sa'
    ELSE 
        DECLARE login_curs CURSOR
            FOR SELECT
                    p.sid
                   ,p.name
                   ,p.type
                   ,p.is_disabled
                   ,p.default_database_name
                   ,l.hasaccess
                   ,l.denylogin
                FROM
                    sys.server_principals p
                    LEFT JOIN sys.syslogins l
                        ON ( l.name = p.name )
                WHERE
                    p.type IN ( 'S', 'G', 'U' )
                    AND p.name = @login_name
    OPEN login_curs

    FETCH NEXT FROM login_curs INTO @SID_varbinary, @name, @type, @is_disabled,
        @defaultdb, @hasaccess, @denylogin
    IF ( @@fetch_status = -1 ) 
        BEGIN
            PRINT 'No login(s) found.'
            CLOSE login_curs
            DEALLOCATE login_curs
            RETURN -1
        END
    SET @tmpstr = '/* user permissions script '
    PRINT @tmpstr
    SET @tmpstr = '** Generated ' + CONVERT (VARCHAR, GETDATE()) + ' on '
        + @@SERVERNAME + ' */'
    PRINT @tmpstr
    PRINT ''
    WHILE ( @@fetch_status <> -1 )
        BEGIN
            IF ( @@fetch_status <> -2 ) 
                BEGIN
                    PRINT ''
                    SET @tmpstr = '-- Login: ' + @name
                    PRINT @tmpstr
                    IF ( @type IN ( 'G', 'U' ) )

    --BEGIN -- NT authenticated account/group

    --  SET @tmpstr = 'CREATE LOGIN ' + QUOTENAME( @name ) + ' FROM WINDOWS WITH DEFAULT_DATABASE = [' + @defaultdb + ']'
    --END
    --ELSE BEGIN -- SQL Server authentication
    --    -- obtain password and sid
    --        SET @PWD_varbinary = CAST( LOGINPROPERTY( @name, 'PasswordHash' ) AS varbinary (256) )
    --    EXEC cp_hexadecimal @PWD_varbinary, @PWD_string OUT
    --    EXEC cp_hexadecimal @SID_varbinary,@SID_string OUT
 
    --    -- obtain password policy state
    --    SELECT @is_policy_checked = CASE is_policy_checked WHEN 1 THEN 'ON' WHEN 0 THEN 'OFF' ELSE NULL END FROM sys.sql_logins WHERE name = @name
    --    SELECT @is_expiration_checked = CASE is_expiration_checked WHEN 1 THEN 'ON' WHEN 0 THEN 'OFF' ELSE NULL END FROM sys.sql_logins WHERE name = @name
 
    --        SET @tmpstr = 'CREATE LOGIN ' + QUOTENAME( @name ) + ' WITH PASSWORD = ' + @PWD_string + ' HASHED, SID = ' + @SID_string + ', DEFAULT_DATABASE = [' + @defaultdb + ']'

    --    IF ( @is_policy_checked IS NOT NULL )
    --    BEGIN
    --      SET @tmpstr = @tmpstr + ', CHECK_POLICY = ' + @is_policy_checked
    --    END
    --    IF ( @is_expiration_checked IS NOT NULL )
    --    BEGIN
    --      SET @tmpstr = @tmpstr + ', CHECK_EXPIRATION = ' + @is_expiration_checked
    --    END
    --END
                        EXEC cp_ScriptUserPermissions @NAME


                    IF ( @denylogin = 1 ) 
                        BEGIN -- login is denied access
                            SET @tmpstr = @tmpstr + '; DENY CONNECT SQL TO '
                                + QUOTENAME(@name)
                        END
                    ELSE 
                        IF ( @hasaccess = 0 ) 
                            BEGIN -- login exists but does not have access
                                SET @tmpstr = @tmpstr
                                    + '; REVOKE CONNECT SQL TO '
                                    + QUOTENAME(@name)
                            END
                    IF ( @is_disabled = 1 ) 
                        BEGIN -- login is disabled
                            SET @tmpstr = @tmpstr + '; ALTER LOGIN '
                                + QUOTENAME(@name) + ' DISABLE'
                        END
                    PRINT @tmpstr
                END

            FETCH NEXT FROM login_curs INTO @SID_varbinary, @name, @type,
                @is_disabled, @defaultdb, @hasaccess, @denylogin
        END
    CLOSE login_curs
    DEALLOCATE login_curs
    RETURN 0
GO


-- End: CREATE PROCEDURE dbo.cp_help_CreateLogins


EXEC master.dbo.cp_help_CreateLogins
GO

-- list default databases
--SELECT
--    sys.syslogins.name
--   ,sys.syslogins.dbname
--   ,sys.databases.name
--FROM
--    sys.syslogins
--    LEFT OUTER JOIN sys.databases
--        ON sys.syslogins.dbname = sys.databases.name
--ORDER BY
--    sys.databases.name

--EXEC sp_change_users_login 'Report';
--exec sp_change_users_login 'Auto_fix', '%';
