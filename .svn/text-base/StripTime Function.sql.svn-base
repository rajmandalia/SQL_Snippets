--USE [master]
--GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sf_StripTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[sf_StripTime]
GO

USE [master]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Create Process
-- --------------
CREATE FUNCTION [dbo].[sf_StripTime] ( @pDateTime DATETIME )
RETURNS DATETIME
AS BEGIN

    RETURN CONVERT(DATETIME, CONVERT(VARCHAR, @pDateTime, 112))

   END



-- end of file : sf_StripTime


GO

