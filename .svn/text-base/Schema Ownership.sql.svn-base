

-- Schema ownership
-- Raj Mandalia - 2007-01-17


--select left(name,30), schema_id
--	from sys.schemas

select 
		left(ss.name,30) as Schemaname
		,left(so.type_desc,30) as ObjectType
		,count(1) as [Count]
	from sys.objects so
		join sys.schemas ss
			on so.schema_id = ss.schema_id

	group by left(ss.name,30), so.type_desc
	order by left(ss.name,30)


select 
		left(so.name,30) as ObjectName
		,left(so.type_desc,30) as ObjectType
		,left(ss.name,30) as SchemaName
	
	from sys.objects so
		join sys.schemas ss
			on so.schema_id = ss.schema_id
	where ss.name = '<Schema Name,sysname,>'
