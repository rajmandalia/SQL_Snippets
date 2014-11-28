select 'msdb.dbo.sp_delete_job @job_id=N''' +
	convert(varchar(36),job_id) + ''' , @delete_unused_schedule=1'
 from msdb..sysjobs where name like 'EIS%'
order by date_created 