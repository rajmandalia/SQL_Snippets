select @mPeriodStart = dateadd(mm, datediff(mm,0,getdate()), 0) -- gets you the first date of the current month