use AriesStagingDatabase
go

select 
LogID, EventID, Priority, Severity, Title, Timestamp, MachineName, AppDomainName, ProcessID, ProcessName, ThreadName, Win32ThreadId, [Message], 
convert(varchar(6000),FormattedMessage) as FormattedMessage
 from dbo.[Log] 
	where Timestamp > dateadd(dd,-3, getdate())  -- 3 days
	order by Timestamp desc