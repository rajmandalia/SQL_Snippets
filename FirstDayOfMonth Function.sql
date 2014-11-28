--USE [master]
--GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sf_FirstDayOfMonth]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[sf_FirstDayOfMonth]
GO

USE [master]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- Create Process
-- --------------
CREATE FUNCTION [dbo].[sf_FirstDayOfMonth] ( @pDateTime DATETIME )
RETURNS DATETIME
AS BEGIN


    RETURN dbo.sf_StripTime(DATEADD(mm, DATEDIFF(mm, 0, @pDateTime), 0))

   END



-- end of file : sf_FirstDayOfMonth


GO

