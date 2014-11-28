use <Database, varchar, pubs>
go

select ' <--' as [Direction], left(object_name(id),50) as [<Object Name, varchar, cp_>]
	from sysdepends
	where object_name(depid) = '<Object Name, varchar, cp_>'

union 

select '     -->', left(object_name(depid),50)
	from sysdepends
	where object_name(id) = '<Object Name, varchar, cp_>'