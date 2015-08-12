-- =======================================================================
-- Name			: cp_
-- Author		: $USER$ on $MACHINE$ against $SERVER$.$DBNAME$
-- Create Date	: $DATE(MM/dd/yyyy)$ - $TIME(HH:mm)$
-- Description	: Procedure used to ...
-- 
-- Parameters	: /* Params */
-- 					@pResultID int output, @pResultMsg varchar(500) output
-- Returns		: /* Return Params */
--					@pResultID : -ve = error, 0 = successful, +ve = warning /info
--					@pResultMsg : appro. message or NULL
-- =======================================================================
-- Modification History
-- --------------------
-- 01/01/2004,Raj Mandalia : Created
-- 
-- =======================================================================

-- Verify correct target server and database
-- -----------------------------------------

USE $DBNAME$
GO

WHILE ( SERVERPROPERTY('servername') NOT IN ( '$SERVER$' ) )
    OR ( DB_NAME() NOT IN ( '$DBNAME$' ) )
    BEGIN
        PRINT 'WRONG SERVER OR DATABASE: ' + CONVERT(VARCHAR,SERVERPROPERTY('servername')) + '.' + DB_NAME()
    END


-- Drop Existing Process
-- ---------------------
IF OBJECT_ID('<Procedure Name, varchar, cp_>') IS NOT NULL
    DROP PROCEDURE <Procedure Name, varchar, cp_>
GO

$CURSOR$
-- Create Process
-- --------------
CREATE PROCEDURE <Procedure Name, varchar, cp_> 
	<Parameters, varchar, /* Params */>
  , @ResultID INT OUTPUT
  , @ResultMsg VARCHAR(500) OUTPUT
AS
    SET NOCOUNT ON
	
    DECLARE @mError INT
      , @mRowCount INT
	
    SELECT 
		@ResultID = 0, @ResultMsg = '', @mError = 0, @mRowCount = 0
	
	
    BEGIN TRY
        SELECT *
            FROM sys.tables
        SELECT @mError = @@error, @mRowCount = @@rowcount
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState,
                ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
        
	
	
    SELECT @mError = @@error, @mRowCount = @@rowcount
    IF @mError <> 0
        OR @mRowCount = 0
        BEGIN
            SELECT 
			@ResultID = 0, @ResultMsg = ''
            GOTO exitpoint
        END
	

    exitpoint:

    SET NOCOUNT OFF

    RETURN @ResultID

-- End of File : <Procedure Name, varchar, cp_>

GO
    