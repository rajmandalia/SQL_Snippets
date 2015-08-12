USE EMK3_Interfaces;
GO


USE EMK3_Interfaces;
GO

GO
WHILE ( @@servername NOT IN ( 'EX30SQLEMK301' ) )
    OR ( DB_NAME() NOT IN ( 'EMK3_Interfaces' ) )
    BEGIN
        PRINT 'WRONG SERVER OR DATABASE: ' + @@servername + '.' + DB_NAME()
    END
    
    
IF (EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_EMK3_PurchaseStatementInterface_ByMonth]') AND type IN (N'P', N'PC')))
  DROP PROCEDURE usp_EMK3_PurchaseStatementInterface_ByMonth;
GO
-- ==============================================================================
-- Author:		Foster Holt
-- Create date: 8.23.2010
-- Description:	Takes the Purchase Statement data from the EMK3_Interfaces 
--              database and loads and attempts to load it into the EMK3 
--              database using EMK3's interface procedures.
-- 
-- Date        Version Who            Description
-- ----------- ------- -------------- -------------------------------------------
-- 8.23.2010   1.0     Foster Holt    Initial version.
-- ==============================================================================
CREATE PROCEDURE dbo.usp_EMK3_PurchaseStatementInterface_ByMonth
  @SourceID             VARCHAR(MAX)
 ,@ProductionYear       INT
 ,@ProductionMonth	    INT
AS
BEGIN
SET NOCOUNT ON --added to prevent extra result sets from interfering with SELECT statements.

DECLARE @ProductionStartDate  DATETIME
       ,@ProductionEndDate    DATETIME
       ,@Subject              VARCHAR(255)
       ,@mSource              VARCHAR(100)
       ,@mCode                INT
       ,@mMessage             VARCHAR(100)
	   ,@ResultID             INT
       ,@ResultMsg            VARCHAR(500)
       ,@mRowCnt              BIGINT
       ,@StartTime            DATETIME
       ,@EndTime              DATETIME
       ,@ElapsedTime          VARCHAR(10);


SET @ProductionStartDate = CONVERT(DATETIME,CONVERT(VARCHAR,@ProductionMonth) + '/01/' + CONVERT(VARCHAR,@ProductionYear));
SET @ProductionEndDate = DATEADD(dd,-1,DATEADD(mm,1,@ProductionStartDate));

SET @StartTime = GETDATE();
SET @mSource = 'usp_EMK3_PurchaseStatementInterface_ByMonth';
SET @Subject = 'Purchase Statement interface into EMK3 for ' + @SourceId + ' ' + CONVERT(VARCHAR,@ProductionMonth) + '/' + CONVERT(VARCHAR,@ProductionYear);

SET @mCode = 0;
SET @mMessage = 'Start of usp_EMK3_PurchaseStatementInterface_ByMonth';
EXEC cp_WriteLog @mSource,@mCode,@mMessage,@ResultID OUTPUT,@ResultMsg OUTPUT;

-- Retrieve Email Recipients.
DECLARE @EmailBody        VARCHAR(MAX)
	   ,@Recipients       VARCHAR(MAX)
       ,@MailProfile      VARCHAR(500);
SELECT @Recipients = dbo.cf_GetDefault('usp_EMK3_PurchaseStatementInterface_Recepients');
SELECT @MailProfile = dbo.cf_GetDefault('MailProfile');

SET @mCode = 0;
SET @mMessage = 'Email Recipients:' + SUBSTRING(@Recipients,1,80);
EXEC cp_WriteLog @mSource,@mCode,@mMessage,@ResultID OUTPUT,@ResultMsg OUTPUT;

	   
BEGIN TRY
    DECLARE @DUP_CNT  INT;
    SELECT @DUP_CNT = COUNT(1)
      FROM (SELECT Plant,Meter,Party_Id,CONTRACT_NUMBER,WELLHEAD_GROSS_MCF,WELLHEAD_GROSS_MMBTU,CONTRACT_PCT,RESIDUE_PRODUCED_MMBTU
                  ,RESIDUE_POP_PCT,RESIDUE_TIK_MMBTU,RESIDUE_MMBTU_TO_PRODUCER,RESIDUE_PRICE,TOTAL_LIQUIDS_VALUE
                  ,LIQUIDS_TOTAL_VALUE_TO_PRODUCER,TOTAL_FEES,TOTAL_TAX,RESIDUE_VALUE,RESIDUE_VALUE_TO_PRODUCER,RESIDUE_MMBTU
                  ,RESIDUE_MCF,RESIDUE_LRU_MMBTU,RESIDUE_LRU_MCF,RESIDUE_SOLD_MCF,RESIDUE_SOLD_MMBTU
                  ,COUNT(1) CNT
              FROM EMK3_Residue r
             WHERE r.SourceId = @SourceId
               AND CASE WHEN ISDATE(r.Production_Date) = 1 THEN CONVERT(DATETIME,r.Production_Date) 
                        ELSE DATEADD(dd,-1,@ProductionStartDate) 
                   END BETWEEN @ProductionStartDate AND @ProductionEndDate
            GROUP BY Plant,Meter,Party_Id,CONTRACT_NUMBER,WELLHEAD_GROSS_MCF,WELLHEAD_GROSS_MMBTU,CONTRACT_PCT,RESIDUE_PRODUCED_MMBTU
                    ,RESIDUE_POP_PCT,RESIDUE_TIK_MMBTU,RESIDUE_MMBTU_TO_PRODUCER,RESIDUE_PRICE,TOTAL_LIQUIDS_VALUE
                    ,LIQUIDS_TOTAL_VALUE_TO_PRODUCER,TOTAL_FEES,TOTAL_TAX,RESIDUE_VALUE,RESIDUE_VALUE_TO_PRODUCER,RESIDUE_MMBTU
                    ,RESIDUE_MCF,RESIDUE_LRU_MMBTU,RESIDUE_LRU_MCF,RESIDUE_SOLD_MCF,RESIDUE_SOLD_MMBTU) t
    WHERE t.CNT > 1;
    IF (@DUP_CNT > 0)
      BEGIN
        SET @EmailBody = 'Duplicates found in the Residue table (EMK3_Residue).  Processing failed.';
        SET @Subject = @Subject + ' ** ERRORS EXIST **';
        EXECUTE msdb.dbo.sp_send_dbmail 
			@profile_name = @MailProfile
		   ,@recipients = @Recipients
		   ,@body = @EmailBody
		   ,@body_format = 'HTML'
		   ,@subject = @Subject;
        RETURN 1;
       END;
    SELECT @DUP_CNT = COUNT(1)
      FROM (SELECT Plant,Meter,Party_Id,Product_Code,Dispostion_Code,GALLONS,GALLONS_TO_PRODUCER,TAKE_IN_KIND_GALLONS
                  ,THEORETICAL_GALLONS,STATEMENT_PRICE,PERCENT_OF_PROCEEDS_PCT,LBS,LBS_TO_PRODUCER,THEORETICAL_LBS
                  ,[VALUE],VALUE_TO_PRODUCER,UOM_PCT, COUNT(1) CNT
              FROM EMK3_Liquid l
             WHERE l.SourceId = @SourceId
               AND CASE WHEN ISDATE(l.Production_Date) = 1 THEN CONVERT(DATETIME,l.Production_Date) 
                        ELSE DATEADD(dd,-1,@ProductionStartDate) 
                   END BETWEEN @ProductionStartDate AND @ProductionEndDate
            GROUP BY Plant,Meter,Party_Id,Product_Code,Dispostion_Code,GALLONS,GALLONS_TO_PRODUCER,TAKE_IN_KIND_GALLONS
                  ,THEORETICAL_GALLONS,STATEMENT_PRICE,PERCENT_OF_PROCEEDS_PCT,LBS,LBS_TO_PRODUCER,THEORETICAL_LBS
                  ,[VALUE],VALUE_TO_PRODUCER,UOM_PCT) t
    WHERE t.CNT > 1;
    IF (@DUP_CNT > 0)
      BEGIN
        SET @EmailBody = 'Duplicates found in the Liquids table (EMK3_Liquid).  Processing failed.';
        SET @Subject = @Subject + ' ** ERRORS EXIST **';
        EXECUTE msdb.dbo.sp_send_dbmail 
			@profile_name = @MailProfile
		   ,@recipients = @Recipients
		   ,@body = @EmailBody
		   ,@body_format = 'HTML'
		   ,@subject = @Subject;
        RETURN 1;
       END;

	DECLARE @ImportID             UNIQUEIDENTIFIER
		   ,@CurrentDateTime      DATETIME
		   ,@SellerID             INT
		   ,@ProductType          TINYINT
		   ,@ModuleType           TINYINT
		   ,@ComponentCategory    TINYINT
		   ,@ComponentImportID    UNIQUEIDENTIFIER
		   ,@SPParam1             VARCHAR(255)
		   ,@SPParam2             VARCHAR(255)
		   ,@SPParam3             VARCHAR(255)
		   ,@SPParam4             VARCHAR(255)
		   ,@ErrorInd             CHAR(1);
	       
	SET @CurrentDateTime = GETDATE();
	SET @ErrorInd = 'N';

	SELECT @SellerID = ci.SellerID
		  ,@ProductType = ci.ProductType
		  ,@ModuleType = ci.ModuleType
		  ,@ComponentCategory = ci.ComponentCategory
		  ,@ComponentImportID = ci.ComponentImportID
		  ,@SPParam1 = ci.SPParam1
		  ,@SPParam2 = ci.SPParam2
		  ,@SPParam3 = ci.SPParam3
		  ,@SPParam4 = ci.SPParam4
	  FROM am_componentimport_dal ci
	 WHERE SPName = 'sp_gmm_Import_EMK3_PurchaseStatements'; 

	EXECUTE EMK3EntEd_DAL.dbo.sp_am_importPut @SellerID, @ProductType, @ModuleType
	   ,@ComponentCategory, @ComponentImportID, null, @CurrentDateTime
	   ,'Import', null, null, null, null, @CurrentDateTime, 'Import'
	   ,null, null, @ImportID OUTPUT;

	INSERT INTO am_importitem_DAL (SellerID,ImportID,ImportItemID,RecordNumber,C1,C2
	   ,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C20,C21,C22
	   ,C23,C24,C25,C26,C27,Created,CreatedBy)
	SELECT @SellerID, @ImportID, NEWID(), 1
		  ,r.Meter XID
		  ,null SupplyPointName
		  ,r.Production_Date AccountingDate
		  ,MONTH(r.Production_Date) StatementMonth
		  ,YEAR(r.Production_Date) StatementYear
		  ,CONVERT(NUMERIC(18,2),ISNULL(r.RESIDUE_VALUE_TO_PRODUCER,'0')) ResidueValue
		  ,(SELECT SUM(CONVERT(NUMERIC(18,2),ISNULL(l.VALUE_TO_PRODUCER,'0'))) FROM EMK3_Liquid l WHERE l.Plant = r.Plant AND l.Meter = r.Meter AND l.Production_Date = r.Production_Date AND l.Party_Id = r.Party_Id AND l.Dispostion_Code = 'PROD') ProductValue
		  ,(CONVERT(NUMERIC(18,2),ISNULL(r.TOTAL_FEES,'0')) + CONVERT(NUMERIC(18,2),ISNULL(r.TOTAL_TAX,'0'))) FeeAdjustmentValue
		  ,ROUND(CONVERT(NUMERIC(18,2),ISNULL(r.WELLHEAD_GROSS_MMBTU,'0')) - CONVERT(NUMERIC(18,2),ISNULL(r.WELLHEAD_GROSS_MMBTU,'0')) * .0625,2) NetDeliveredMMBtu
		  ,CONVERT(NUMERIC(18,2),ISNULL(r.RESIDUE_LRU_MMBTU,'0')) Shrink -- Residue Shrink (not Product Shrink)
		  ,null FuelFlair -- Possibly PlantFuel = NetDeliveredMMBtu * 2.50%; PlantFlare = NetDeliveredMMBtu * 0.00%
		  ,CONVERT(NUMERIC(18,2),ISNULL(r.RESIDUE_MMBTU,'0')) TheoreticalResidue
		  ,CONVERT(NUMERIC(18,2),ISNULL(r.RESIDUE_MMBTU,'0')) AllocatedResidue
		  ,null AllocatedFuel
		  ,null PlantBypass
		  ,null ContractualLineLoss
		  ,CONVERT(NUMERIC(18,2),ISNULL(r.RESIDUE_MMBTU,'0')) NetResidueMMBtu
		  ,CONVERT(NUMERIC(18,4),ISNULL(r.RESIDUE_POP_PCT,'0')) PercentProceeds
		  ,ROUND(CONVERT(NUMERIC(18,2),ISNULL(r.RESIDUE_MMBTU,'0')) * (CONVERT(NUMERIC(18,2),ISNULL(r.RESIDUE_POP_PCT,'0'))/100),2) SettlementResidue
		  ,CONVERT(NUMERIC(18,8),ISNULL(r.RESIDUE_PRICE,'0')) ResiduePrice
		  ,CASE WHEN CONVERT(NUMERIC(18,2),ISNULL(r.WELLHEAD_GROSS_MCF,'0')) = 0 THEN 0 
				ELSE ROUND(CONVERT(NUMERIC(18,2),ISNULL(r.WELLHEAD_GROSS_MMBTU,'0')) / CONVERT(NUMERIC(18,2),ISNULL(r.WELLHEAD_GROSS_MCF,'0')),4)
				END BTUValue
		  ,2 GasBeingProcessed
		  ,2 SellingResidueGasToPlant
		  ,r.CONTRACT_NUMBER BaseContract
		  ,'' Buyer
		  ,'' Seller
		  ,1 ContractType
		  ,@CurrentDateTime
		  ,'Import'
	 FROM EMK3_Residue r
    WHERE r.SourceId = @SourceId
      AND r.Production_Date BETWEEN @ProductionStartDate AND @ProductionEndDate;
    SET @mRowCnt = @@ROWCOUNT;
    SET @mCode = 0;
    SET @mMessage = 'Inserted ' + CONVERT(VARCHAR,@mRowCnt) + ' into am_importitem_DAL table.';
    EXEC cp_WriteLog @mSource,@mCode,@mMessage,@ResultID OUTPUT,@ResultMsg OUTPUT;
	 
    SET @mCode = 0;
    SET @mMessage = 'Calling sp_gmm_Import_EMK3_PurchaseStatements_DAL';
    EXEC cp_WriteLog @mSource,@mCode,@mMessage,@ResultID OUTPUT,@ResultMsg OUTPUT;
	EXECUTE EMK3EntEd_DAL.dbo.sp_gmm_Import_EMK3_PurchaseStatements @SellerID,@ComponentImportID
	  ,@ImportID,@SPParam1,@SPParam2,@SPParam3,@SPParam4;

    -- Cleanup.
    EXECUTE EMK3EntEd_DAL.dbo.sp_am_importitemdelall @SellerID, @ImportID;

	DECLARE @ProcessingNote   VARCHAR(500)
		   ,@NumRecProcessed  BIGINT
		   ,@NumRecSuccess    BIGINT
		   ,@NumRecFail       BIGINT
		   ,@RowCnt           BIGINT;
	       
	SET @RowCnt = 0; 

	SELECT TOP 1
		   @NumRecProcessed = i.NumRecProcessed
		  ,@NumRecSuccess = i.NumRecSuccess
		  ,@NumRecFail = i.NumRecFail
	  FROM am_import_DAL i
	 WHERE i.ImportID = @ImportID; 
	       
	SET @EmailBody = '<body style="font-size: smaller; font-family: Arial">'
                   + '<p>The following are results from two interfaces into EMK3.  The first is Purchase Statement information and the second is Purchase Statement Liquids information.</p>'
                   + '<H2 style="font-family: Verdana">EMK Interface Report for ' + @Subject + ' (Part 1 - Header)</H2>'
                   + '<table style="font-family: Verdana; width: 100%; height: 56px;" border="1" cellpadding="10" cellspacing="0">'
                   + '<tbody>'
                   + '<tr>'
                   + '<td>'
                   + '<h4>SellerID: ' + convert(varchar,@SellerID) + '</h4>'
                   + '</td>'
                   + '<td>'
                   + '<h4>ImportID: ' + convert(varchar(36),@ImportID) + '</h4>'
                   + '</td>'
                   + '</tr>'
                   + '</tbody>'
                   + '</table>'
                   + '<br />'
                   + '<table style="font-family: Verdana; width: 100%" border="1" cellpadding="10" cellspacing="0">'
                   + '<tbody>'
                   + '<tr>'
                   + '<td>Processed: ' + convert(varchar,@NumRecProcessed) + '</td>'
                   + '<td style="color: rgb(0, 153, 0);">Successful: ' + convert(varchar,@NumRecSuccess) + '</td>'
                   + '<td style="color: rgb(255, 0, 0);">Failed: ' + convert(varchar,@NumRecFail) + N'</td>'
                   + '</tr>'
                   + '</tbody>'
                   + '</table>'
                   + '<br />';

-- If errors are found, then add them to the email.
    IF ((SELECT COUNT(1) FROM dbo.am_import_dal AS i JOIN dbo.am_importitemexception_dal AS e ON i.SellerID = e.SellerID AND i.ImportID = e.ImportID WHERE convert(varchar(36),i.ImportID) = @ImportID) > 0)
      BEGIN
        SET @ErrorInd = 'Y';
        SET @EmailBody = @EmailBody 
                       + '<table style="font-family: Verdana; width: 100%; height: 618px;" class="MsoNormalTable" border="1" cellpadding="2" cellspacing="0">'
                       + '<tr>'
                       + '<th>ImportItemID</th>' 
                       + '<th>ProcessingNote</th>'
                       + '<th>XID</th>'
                       + '<th>Supply Point Name</th>'
                       + '<th>Accounting Date</th>'
                       + '<th>Statement for Month</th>'
                       + '<th>Statement for Year</th>'
                       + '<th>Total Residue Gas Value ($)</th>'
                       + '<th>Total NGL Value ($)</th>'
                       + '<th>Total Fees ($)</th>'
                       + '<th>Net Delivered volume in MMBtu (before FL and U)</th>'
                       + '<th>Shrink or L and U volume</th>'
                       + '<th>Fuel/Flare volume</th>'
                       + '<th>Theoretical Residue volume</th>'
                       + '<th>Allocated Residue volume</th>'
                       + '<th>Allocated Fuel volume</th>'
                       + '<th>Plant Bypass volume</th>'
                       + '<th>Contractual Line Loss volume</th>'
                       + '<th>Net Gas (Residue) volume</th>'
                       + '<th>Percent of Proceeds (POP)</th>'
                       + '<th>Settlement Gas (Residue) volume</th>'
                       + '<th>Settlement Gas (Residue) price in $/MMBtu</th>'
                       + '<th>BTU Value</th>'
                       + '<th>Gas being processed</th>'
                       + '<th>Selling Residue Gas to Plant</th>'
                       + '<th>XID (for Base Contract)</th>'
                       + '<th>XID (for Buyer)</th>'
                       + '<th>XID (for Seller)</th>'
                       + '<th>Contract Type</th>'
                       + '</tr>'
                       + CAST ( ( SELECT 
										td = isnull(e.ImportItemID,''), '',
										td = isnull(e.ProcessingNote,''), '',
										td = isnull(e.C1,''), '',
										td = isnull(e.C2,''), '',
										td = isnull(e.C3,''), '',
										td = isnull(e.C4,''), '',
										td = isnull(e.C5,''), '',
										td = isnull(e.C6,''), '',
										td = isnull(e.C7,''), '',
										td = isnull(e.C8,''), '',
										td = isnull(e.C9,''), '',
										td = isnull(e.C10,''), '',
										td = isnull(e.C11,''), '',
										td = isnull(e.C12,''), '',
										td = isnull(e.C13,''), '',
										td = isnull(e.C14,''), '',
										td = isnull(e.C15,''), '',
										td = isnull(e.C16,''), '',
										td = isnull(e.C17,''), '',
										td = isnull(e.C18,''), '',
										td = isnull(e.C19,''), '',
										td = isnull(e.C20,''), '',
										td = isnull(e.C21,''), '',
										td = isnull(e.C22,''), '',
										td = isnull(e.C23,''), '',
										td = isnull(e.C24,''), '',
										td = isnull(e.C25,''), '',
										td = isnull(e.C26,''), '',
										td = isnull(e.C27,''), ''
									from dbo.am_import_dal
										AS i JOIN dbo.am_importitemexception_dal AS e 
											ON i.SellerID = e.SellerID AND i.ImportID = e.ImportID
									where convert(varchar(36),i.ImportID) = @ImportID
								  FOR XML PATH('tr'), TYPE 
						        ) AS NVARCHAR(MAX) 
                              )
                       + '</table>'
                       + '<BR />';
      END;

	/************************************************************************

	*************************************************************************/

	SELECT @SellerID = ci.SellerID
		  ,@ProductType = ci.ProductType
		  ,@ModuleType = ci.ModuleType
		  ,@ComponentCategory = ci.ComponentCategory
		  ,@ComponentImportID = ci.ComponentImportID
		  ,@SPParam1 = ci.SPParam1
		  ,@SPParam2 = ci.SPParam2
		  ,@SPParam3 = ci.SPParam3
		  ,@SPParam4 = ci.SPParam4
	  FROM am_componentimport_dal ci
	 WHERE SPName = 'sp_gmm_Import_EMK3_PurchaseStatementsLiquids'; 
	 
	EXECUTE EMK3EntEd_DAL.dbo.sp_am_importPut @SellerID, @ProductType, @ModuleType
	   ,@ComponentCategory, @ComponentImportID, null, @CurrentDateTime
	   ,'Import', null, null, null, null, @CurrentDateTime, 'Import'
	   ,null, null, @ImportID OUTPUT; 

	INSERT INTO am_importitem_DAL (SellerID,ImportID,ImportItemID,RecordNumber,C1,C2
	   ,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16,Created,CreatedBy)
	SELECT @SellerID, @ImportID, NEWID(), 1
		  ,l.Meter XID
		  ,null SupplyPointName
		  ,l.Production_Date AccountingDate
		  ,MONTH(l.Production_Date) StatementMonth
		  ,YEAR(l.Production_Date) StatementYear
		  ,18 LiquidID -- 18 = All Products
		  ,null EstGals -- l.THEORETICAL_GALLONS is not matching
		  ,SUM(CONVERT(NUMERIC(18,2),ISNULL(l.GALLONS,'0'))) AllocatedGals
		  ,(SELECT CONVERT(NUMERIC(10,2),ROUND(((CONVERT(NUMERIC(10,2),ISNULL(r.WELLHEAD_GROSS_MMBTU,'0')) - (CONVERT(NUMERIC(10,2),ISNULL(r.WELLHEAD_GROSS_MMBTU,'0')) * 0.0625)) - ((CONVERT(NUMERIC(10,2),ISNULL(r.WELLHEAD_GROSS_MMBTU,'0')) - (CONVERT(NUMERIC(10,2),ISNULL(r.WELLHEAD_GROSS_MMBTU,'0')) * 0.0625)) * 0.0267)) - CONVERT(NUMERIC(10,2),ISNULL(r.RESIDUE_MMBTU,'0')),2)) FROM EMK3_Residue r WHERE r.Plant = l.Plant AND r.Meter = l.Meter AND r.SourceId = @SourceId AND r.Production_Date = l.Production_Date AND r.Party_Id = l.Party_Id) Shrink 
		  ,100 PercentOfProceeds
		  ,SUM(CONVERT(NUMERIC(18,2),ISNULL(l.GALLONS,'0'))) SettlementGals
		  ,CASE WHEN SUM(CONVERT(NUMERIC(18,2),ISNULL(l.GALLONS,'0'))) = 0 THEN 0
				ELSE SUM(CONVERT(NUMERIC(18,2),ISNULL(l.VALUE_TO_PRODUCER,'0'))) / SUM(CONVERT(NUMERIC(18,2),ISNULL(l.GALLONS,'0')))
		   END ProductPrice
		  ,(SELECT r.CONTRACT_NUMBER FROM EMK3_Residue r WHERE r.Plant = l.Plant AND r.Meter = l.Meter AND r.SourceId = @SourceId AND r.Production_Date = l.Production_Date AND r.Party_Id = l.Party_Id) BaseContract
		  ,'' Buyer
		  ,'' Seller
		  ,1 ContractType
		  ,@CurrentDateTime
		  ,'Import'
	  FROM EMK3_Liquid l
	 WHERE l.Dispostion_Code = 'PROD'
       AND l.SourceId = @SourceId
       AND l.Production_Date BETWEEN @ProductionStartDate AND @ProductionEndDate
	GROUP BY l.Plant,l.Meter,l.Production_Date,l.Party_Id;
	 
	EXECUTE EMK3EntEd_DAL.dbo.sp_gmm_Import_EMK3_PurchaseStatementsLiquids @SellerID,@ComponentImportID
	  ,@ImportID,@SPParam1,@SPParam2,@SPParam3,@SPParam4;

    -- Cleanup.
    EXECUTE EMK3EntEd_DAL.dbo.sp_am_importitemdelall @SellerID, @ImportID;

	SET @RowCnt = 0; 

	SELECT TOP 1
		   @NumRecProcessed = i.NumRecProcessed
		  ,@NumRecSuccess = i.NumRecSuccess
		  ,@NumRecFail = i.NumRecFail
	  FROM am_import_DAL i
	 WHERE i.ImportID = @ImportID;      
       
    SET @EmailBody = @EmailBody 
                   + '<H2 style="font-family: Verdana">EMK Interface Report for ' + @Subject + ' (Part 2 - Liquids)</H2>'
                   + '<table style="font-family: Verdana; width: 100%; height: 56px;" border="1" cellpadding="10" cellspacing="0">'
                   + '<tbody>'
                   + '<tr>'
                   + '<td>'
                   + '<h4>SellerID: ' + convert(varchar,@SellerID) + '</h4>'
                   + '</td>'
                   + '<td>'
                   + '<h4>ImportID: ' + convert(varchar(36),@ImportID) + '</h4>'
                   + '</td>'
                   + '</tr>'
                   + '</tbody>'
                   + '</table>'
                   + '<br />'
                   + '<table style="font-family: Verdana; width: 100%" border="1" cellpadding="10" cellspacing="0">'
                   + '<tbody>'
                   + '<tr>'
                   + '<td>Processed: ' + convert(varchar,@NumRecProcessed) + '</td>'
                   + '<td style="color: rgb(0, 153, 0);">Successful: ' + convert(varchar,@NumRecSuccess) + '</td>'
                   + '<td style="color: rgb(255, 0, 0);">Failed: ' + convert(varchar,@NumRecFail) + '</td>'
                   + '</tr>'
                   + '</tbody>'
                   + '</table>'
                   + '<br />';

-- If errors are found, then add them to the email.
    IF ((SELECT COUNT(1) FROM dbo.am_import_dal AS i JOIN dbo.am_importitemexception_dal AS e ON i.SellerID = e.SellerID AND i.ImportID = e.ImportID WHERE convert(varchar(36),i.ImportID) = @ImportID) > 0)
      BEGIN
        SET @ErrorInd = 'Y';
        SET @EmailBody = @EmailBody 
                       + '<table style="font-family: Verdana; width: 100%; height: 618px;" class="MsoNormalTable" border="1" cellpadding="2" cellspacing="0">'
                       + '<tr>'
                       + '<th>ImportItemID</th>'
                       + '<th>ProcessingNote</th>'
                       + '<th>XID</th>'
                       + '<th>Supply Point Name</th>'
                       + '<th>Accounting Date</th>'
                       + '<th>Statement for Month</th>'
                       + '<th>Statement for Year</th>'
                       + '<th>Liquid ID</th>'
                       + '<th>Est. Gals ($)</th>'
                       + '<th>Total Fees ($)</th>'
                       + '<th>Net Delivered volume in MMBtu</th>'
                       + '<th>Shrink or L and U volume</th>'
                       + '<th>Fuel/Flare volume</th>'
                       + '<th>Theoretical Residue volume</th>'
                       + '<th>XID (for Base Contract)</th>'
                       + '<th>XID (for Buyer)</th>'
                       + '<th>XID (for Seller)</th>'
                       + '<th>Contract Type</th>'
                       + '</tr>'
                       + CAST ( ( SELECT 
										td = isnull(e.ImportItemID,''), '',
										td = isnull(e.ProcessingNote,''), '',
										td = isnull(e.C1,''), '',
										td = isnull(e.C2,''), '',
										td = isnull(e.C3,''), '',
										td = isnull(e.C4,''), '',
										td = isnull(e.C5,''), '',
										td = isnull(e.C6,''), '',
										td = isnull(e.C7,''), '',
										td = isnull(e.C8,''), '',
										td = isnull(e.C9,''), '',
										td = isnull(e.C10,''), '',
										td = isnull(e.C11,''), '',
										td = isnull(e.C12,''), '',
										td = isnull(e.C13,''), '',
										td = isnull(e.C14,''), '',
										td = isnull(e.C15,''), '',
										td = isnull(e.C16,''), ''
									from dbo.am_import_dal
										AS i JOIN dbo.am_importitemexception_dal AS e 
											ON i.SellerID = e.SellerID AND i.ImportID = e.ImportID
									where convert(varchar(36),i.ImportID) = @ImportID
								  FOR XML PATH('tr'), TYPE 
						        ) AS NVARCHAR(MAX)
                              )
                       + '</table>'
                       + '<BR />';
      END;     

	IF (@ErrorInd = 'Y')
	  SET @Subject = @Subject + ' ** ERRORS EXIST **';

    SET @EndTime = GETDATE();
    SET @ElapsedTime = CONVERT(VARCHAR,DATEDIFF(hh,@StartTime,@EndTime)) + ':' + CONVERT(VARCHAR,DATEDIFF(mi,@StartTime,@EndTime)) + ':' + CONVERT(VARCHAR,DATEDIFF(ss,@StartTime,@EndTime)) + '.' + CONVERT(VARCHAR,DATEDIFF(ms,@StartTime,@EndTime));

    SET @EmailBody = @EmailBody 
                   + '<address style="font-family: Verdana;"><small><small>Processed by ' + @mSource + ' in ' + @ElapsedTime + ' seconds. </small></small></address>' + 
                   + '</body>';

    print '@Recipients =' + @Recipients;
	EXECUTE msdb.dbo.sp_send_dbmail 
			@profile_name = @MailProfile
		   ,@recipients = @Recipients
		   ,@body = @EmailBody
		   ,@body_format = 'HTML'
		   ,@subject = @Subject;

    -- Cleanup.
    DELETE r
      FROM EMK3_Residue r
     WHERE r.SourceId = @SourceId
       AND CASE WHEN ISDATE(r.Production_Date) = 1 THEN CONVERT(DATETIME,r.Production_Date) 
                ELSE DATEADD(dd,-1,@ProductionStartDate) 
           END BETWEEN @ProductionStartDate AND @ProductionEndDate;

    DELETE l
	  FROM EMK3_Liquid l
	 WHERE l.SourceId = @SourceId
       AND CASE WHEN ISDATE(l.Production_Date) = 1 THEN CONVERT(DATETIME,l.Production_Date) 
                ELSE DATEADD(dd,-1,@ProductionStartDate) 
           END BETWEEN @ProductionStartDate AND @ProductionEndDate;

    DELETE g
      FROM EMK3_Gas g
     WHERE g.SourceId = @SourceId
       AND CASE WHEN ISDATE(g.Production_Date) = 1 THEN CONVERT(DATETIME,g.Production_Date) 
                ELSE DATEADD(dd,-1,@ProductionStartDate) 
           END BETWEEN @ProductionStartDate AND @ProductionEndDate;
    
    DELETE f
      FROM EMK3_Fuel f
     WHERE f.SourceId = @SourceId
       AND CASE WHEN ISDATE(f.Production_Date) = 1 THEN CONVERT(DATETIME,f.Production_Date) 
                ELSE DATEADD(dd,-1,@ProductionStartDate) 
           END BETWEEN @ProductionStartDate AND @ProductionEndDate;

    DELETE p
      FROM EMK3_PDF p
     WHERE p.SourceId = @SourceId
       AND CASE WHEN ISDATE(p.Recorddate) = 1 THEN CONVERT(DATETIME,p.Recorddate) 
                ELSE DATEADD(dd,-1,@ProductionStartDate) 
           END BETWEEN @ProductionStartDate AND @ProductionEndDate;
     
     RETURN 0;

END TRY
BEGIN CATCH
    SET @EmailBody = ISNULL(@EmailBody,'') + '<p /><p />usp_EMK3_PurchaseStatementInterface_ByMonth failed...<p /><p style="color: red">' + ERROR_MESSAGE() + '</p>';
	SET @Subject = 'Purchase Statement interface into EMK3 ** FAILED **';
	EXECUTE msdb.dbo.sp_send_dbmail 
			@profile_name = @MailProfile
           ,@recipients = @Recipients
		   ,@body = @EmailBody
		   ,@body_format = 'HTML'
		   ,@subject = @Subject;
    RETURN -1;
END CATCH;		   

END;
GO