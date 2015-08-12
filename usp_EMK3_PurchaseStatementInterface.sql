USE EMK3_Interfaces;
GO

GO
WHILE ( @@servername NOT IN ( 'EX30SQLEMK301' ) )
    OR ( DB_NAME() NOT IN ( 'EMK3_Interfaces' ) )
    BEGIN
        PRINT 'WRONG SERVER OR DATABASE: ' + @@servername + '.' + DB_NAME()
    END
UPDATE dbo.tb_Defaults SET 
	defaultValue = 'dbadmins@excoresources.com;fholt@excoresources.com',
	defaultDescription = 'Purchase Statement Interface Email Recepients'
WHERE defaultKey = 'usp_EMK3_PurchaseStatementInterface_Recepients'
GO


IF (EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_EMK3_PurchaseStatementInterface]') AND type IN (N'P', N'PC')))
  DROP PROCEDURE usp_EMK3_PurchaseStatementInterface;
GO
-- ==============================================================================
-- Author:		Foster Holt
-- Create date: 5.19.2010
-- Description:	Takes the Purchase Statement data from the EMK3_Interfaces 
--              database and loads it into EMK3.
--              It will process all available records.  It will determine if all 
--              pieces for a single production month are available.  If so,
--              usp_EMK3_PurchaseStatementInterface_ByMonth is called to perform
--              the import task.
-- 
-- Date        Version Who            Description
-- ----------- ------- -------------- -------------------------------------------
-- 5.19.2010   1.0     Foster Holt    Initial version.
-- 10.25.2010  1.1     Foster Holt    Moved all code from this procedure to 
--                                    usp_EMK3_PurchaseStatementInterface_ByMonth 
--                                    and changed this procedure to call it.
-- ==============================================================================
CREATE PROCEDURE dbo.usp_EMK3_PurchaseStatementInterface   
AS
BEGIN
SET NOCOUNT ON --added to prevent extra result sets from interfering with SELECT statements.


DECLARE @DataExist            CHAR(1)
       ,@SourceId             VARCHAR(MAX)
       ,@Production_Date      VARCHAR(MAX)
       ,@ProductionYear       INT
       ,@ProductionMonth      INT
       ,@Residue_Data         INT
       ,@Liquid_Data          INT
       ,@Comment              VARCHAR(MAX)
       ,@RTN                  INT
       ,@ProcessResult        VARCHAR(MAX)
       ,@Subject              VARCHAR(255)
       ,@mSource              VARCHAR(100)
       ,@mCode                INT
       ,@mMessage             VARCHAR(500)
	   ,@ResultID             INT
       ,@ResultMsg            VARCHAR(500)
       ,@mRowCnt              BIGINT
       ,@StartTime            DATETIME
       ,@EndTime              DATETIME
       ,@ElapsedTime          VARCHAR(10);

SET @DataExist = 'N';
SET @StartTime = GETDATE();
SET @mSource = 'usp_EMK3_PurchaseStatementInterface';
SET @Subject = 'Purchase Statement interface into EMK3 - Summary';

SET @mCode = 0;
SET @mMessage = 'Start of usp_EMK3_PurchaseStatementInterface';
EXEC cp_WriteLog @mSource,@mCode,@mMessage,@ResultID OUTPUT,@ResultMsg OUTPUT;

-- Retrieve Email Recipients.
DECLARE @EmailBody        VARCHAR(MAX)
	   ,@Recipients       VARCHAR(MAX)
       ,@MailProfile      VARCHAR(500);
SET @EmailBody = '';
SELECT @Recipients = dbo.cf_GetDefault('usp_EMK3_PurchaseStatementInterface_Recepients');
PRINT @Recipients;
SELECT @MailProfile = dbo.cf_GetDefault('MailProfile');

SET @mCode = 0;
SET @mMessage = 'Email Recipients:' + SUBSTRING(@Recipients,1,80);
EXEC cp_WriteLog @mSource,@mCode,@mMessage,@ResultID OUTPUT,@ResultMsg OUTPUT;

SET @EmailBody = @EmailBody
               + '<table style="font-family: Verdana; width: 100%;" class="MsoNormalTable" border="1" cellpadding="2" cellspacing="0">'
               + '<tr>'
               + '<th style="background-color: #ffff99;">SourceId</th>'
               + '<th style="background-color: #ffff99;">Production Date</th>'
               + '<th style="background-color: #ffff99;">Comments</th>'
               + '<th style="background-color: #ffff99;">Processing Results</th>'
               + '</tr>';

DECLARE cur CURSOR LOCAL READ_ONLY FOR 
SELECT t.SourceId
      ,t.Production_Date
      ,SUM(t.Residue_Data) Residue_Data
      ,SUM(t.Liquid_Data) Liquid_Data
  FROM (SELECT r.SourceId
              ,r.Production_Date
              ,1 Residue_Data
              ,0 Liquid_Data
          FROM EMK3_Residue r
        GROUP BY r.SourceId, r.Production_Date
        UNION
        SELECT l.SourceId
              ,l.Production_Date
              ,0 Residue_Data
              ,1 Liquid_Data
          FROM EMK3_Liquid l
        GROUP BY l.SourceId, l.Production_Date) t
GROUP BY SourceId, Production_Date
ORDER BY SourceId, Production_Date;

BEGIN TRY
  OPEN cur;

  FETCH NEXT FROM cur
    INTO @SourceId,@Production_Date,@Residue_Data,@Liquid_Data;

  WHILE @@FETCH_STATUS = 0
  BEGIN  
    SET @DataExist = 'Y';
    SET @mCode = 0;
    IF (@Residue_Data = 1 AND @Liquid_Data = 1)
      BEGIN
        SET @Comment = 'Residue and Liquids data exist...qualified for processing.';
        BEGIN TRY
          SET @ProductionYear = YEAR(CONVERT(DATETIME,@Production_Date));
          SET @ProductionMonth = MONTH(CONVERT(DATETIME,@Production_Date));
          EXECUTE @RTN = usp_EMK3_PurchaseStatementInterface_ByMonth @SourceID,@ProductionYear,@ProductionMonth;
          IF (@RTN = 0)
            SET @ProcessResult = 'Successful';
          ELSE
            SET @ProcessResult = 'Failed';
        END TRY
        BEGIN CATCH
          SET @ProcessResult = 'Failed. ' + ERROR_MESSAGE();
        END CATCH;
      END
    ELSE IF (@Residue_Data = 1)
      BEGIN
        SET @Comment = 'Residue data exist but missing Liquids';
        SET @ProcessResult = 'Skipped.';
      END
    ELSE IF (@Liquid_Data = 1)
      BEGIN
        SET @Comment = 'Liquids data exist but missing Residue';
        SET @ProcessResult = 'Skipped.';
      END
    SET @EmailBody = @EmailBody
                   + '<tr>'
                   + '<td>' + ISNULL(@SourceId,'null') + '</td>'
                   + '<td>' + ISNULL(@Production_Date,'null') + '</td>'
                   + '<td>' + ISNULL(@Comment,'null') + '</td>'
                   + '<td>' + ISNULL(@ProcessResult,'null') + '</td>'
                   + '</tr>';
    FETCH NEXT FROM cur
     INTO @SourceId,@Production_Date,@Residue_Data,@Liquid_Data;
  END;

  CLOSE cur;
  DEALLOCATE cur; 
  SET @EmailBody = @EmailBody + '</table>';

  IF (@DataExist = 'N')
    SET @EmailBody = @EmailBody + 'No Purchase Statement data available for upload into EMK3.<BR />'; 

  EXECUTE msdb.dbo.sp_send_dbmail 
          @profile_name = @MailProfile
         ,@recipients = @Recipients
         ,@body = @EmailBody
         ,@body_format = 'HTML'
         ,@subject = @Subject;

END TRY
BEGIN CATCH
    SET @EmailBody = ISNULL(@EmailBody,'') + '<p /><p />usp_EMK3_PurchaseStatementInterface failed...<p /><p style="color: red">' + ERROR_MESSAGE() + '</p>';
	SET @Subject = 'Purchase Statement interface into EMK3 ** FAILED **';
	EXECUTE msdb.dbo.sp_send_dbmail 
			@profile_name = @MailProfile
           ,@recipients = @Recipients
		   ,@body = @EmailBody
		   ,@body_format = 'HTML'
		   ,@subject = @Subject;
END CATCH;		   

END;
GO