
-- ------------------------------------------
-- Name    : Job Notification
-- Date    : 2007-01-09
-- Author  : Raj Mandalia
-- Purpose : Notify operator via email on job failure
-- Modifications (Date \ By \ Purpose)
--    1.
--    2.
-- ------------------------------------------


USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name='<jobname,sysname,>', 
		@notify_level_email=2, -- 0-Never, 1-Sucess, 2-Failure, 3-Always
		@notify_level_netsend=0,  
		@notify_level_page=0, 
		@notify_email_operator_name='<operator,sysname,Raj Mandalia>'
GO