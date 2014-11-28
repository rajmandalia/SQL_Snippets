USE master

 select 
	-- distinct
    spid
   ,left(loginame, 30) as Loginame
   ,left(hostname, 30) as Hostname
   ,case when dbid = 0 then null
         when dbid <> 0 then left(db_name(dbid), 30)
    end as DBName
   ,cmd as Command
 from
    master.dbo.sysprocesses
 where
    spid between 0 and 32767
    and db_name(dbid) = '<Databasename, SYSNAME, db_name()>' -- current database only
	--	and upper(cmd) <> 'AWAITING COMMAND' -- active connections only
	--	and @sid = suser_sid('JohnDoe') -- specified user only
 order by
    loginame
go


select d.name, m.name, m.physical_name
from sys.master_files m 
inner join sys.databases d 
on (m.database_id = d.database_id) 
WHERE d.name = '<Databasename, SYSNAME, db_name()>'
order by d.name, m.name

-- KILL ALL:
-- exec master.dbo.usp_killDBConnections <Databasename, SYSNAME, db_name()>

-- LOCKS:
--exec sp_lock
--go
    
    

-- MORE INFORMATION:

--select 
--	left(sp.loginame,20) loginname
--	,left(db_name(sp.dbid),20) dbname
--	,sp.login_time              
--	,sp.last_batch              
--	,sp.open_tran 
--	,sp.status                         
--	,sp.hostname                                                                                                                         
--	,sp.program_name                                                                                                                     
--	,sp.hostprocess 
--	,sp.cmd              
--	,sp.nt_domain                                                                                                                        
--	,sp.nt_username                                                                                                                      
--                                                                                                                        
--	from sys.sysprocesses sp
--
--	order by sp.loginname



