

select * from dbo.sysjobs

select 'delete from dbo.sysmaintplan_log where subplan_id = ''' + convert(varchar(36),subplan_id) + '''' 
	from dbo.sysmaintplan_subplans where job_id in 
	(select job_id from sysjobs where name like 'Footprints%')
	

--delete from dbo.sysmaintplan_log where subplan_id = '70384223-8618-4CA8-9FD5-605977D06FAD'
--delete from dbo.sysmaintplan_log where subplan_id = 'FABEDA53-8452-460C-A702-8068E625C1DB'
--delete from dbo.sysmaintplan_log where subplan_id = '4092B0DD-84F5-4C23-820F-AE206793512E'
--delete from dbo.sysmaintplan_log where subplan_id = '3F3F4AA6-A8DC-4C2E-BAD5-C43C083D6D35'
--delete from dbo.sysmaintplan_log where subplan_id = '08655D48-BF46-4638-84EA-C727633CA1A0'

--delete from dbo.sysmaintplan_subplans where subplan_id = '70384223-8618-4CA8-9FD5-605977D06FAD'
--delete from dbo.sysmaintplan_subplans where subplan_id = 'FABEDA53-8452-460C-A702-8068E625C1DB'
--delete from dbo.sysmaintplan_subplans where subplan_id = '4092B0DD-84F5-4C23-820F-AE206793512E'
--delete from dbo.sysmaintplan_subplans where subplan_id = '3F3F4AA6-A8DC-4C2E-BAD5-C43C083D6D35'
--delete from dbo.sysmaintplan_subplans where subplan_id = '08655D48-BF46-4638-84EA-C727633CA1A0'