DECLARE
    @backdate DATETIME
   ,@trndate DATETIME
   ,@repdate DATETIME
   ,@nowdate DATETIME

SELECT
    @nowdate = GETDATE()

SELECT
    @backdate = DATEADD(dd, -3, @nowdate)
   ,@trndate = DATEADD(dd, -1, @nowdate)
   ,@repdate = DATEADD(dd, -3, @nowdate)
	

EXECUTE master.dbo.xp_delete_file 0, N'\\ex30sqlari02\d$\SQL\FilerBackups', N'BAK', @backdate,1
EXECUTE master.dbo.xp_delete_file 0, N'\\ex30sqlari02\d$\SQL\Backups', N'TRN', @trndate, 1
EXECUTE master.dbo.xp_delete_file 1, N'\\ex30sqlari02\d$\SQL\Backups', N'txt', @repdate, 1