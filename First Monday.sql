

-- get First Monday, or another day, after the 15th of each month

DECLARE @mdate DATETIME
   ,@rdate DATETIME
SET @mdate = '20110323'

SET NOCOUNT ON

--WHILE DATEPART(yyyy, @mdate) < 2013 
    BEGIN

        --SELECT @rdate = DATEADD(wk, DATEDIFF(wk, 0, DATEADD(dd, ( 15 + 6 ) - DATEPART(day, @mDate), @mDate)), 0)
        SELECT DATEPART(day, @mDate) -- get the day eg 23
        SELECT ( 15 + 6 ) - DATEPART(day, @mDate) -- offset from the 21st of the month, which is 15th of the month plus 6 days eg -2
        SELECT DATEADD(dd, ( 15 + 6 ) - DATEPART(day, @mDate), @mDate)  -- add that offset to the date eg 03/21
        SELECT DATEDIFF(wk, 0, DATEADD(dd, ( 15 + 6 ) - DATEPART(day, @mDate), @mDate)) -- offset from date 0 in weeks eg 5803
        SELECT DATEADD(wk, DATEDIFF(wk, 0, DATEADD(dd, ( 15 + 6 ) - DATEPART(day, @mDate), @mDate)), 0) -- add that back to week 0 returns 1st day (Mon) of week 5803 eg 03/21/2011
        SELECT DATEADD(dd, 2, DATEADD(wk, DATEDIFF(wk, 0, DATEADD(dd, ( 15 + 6 ) - DATEPART(day, @mDate), @mDate)), 0)) -- add days 2 to calculate another day (wed) eg: 03/23/2011
        
        
        
        PRINT @rdate
        SET @mdate = DATEADD(dd, 1, @mDate)
    END       

