use master
go

-- check for default databases that do not exist
select 'The following logins will error out on connection due to a bad default database'

select 
	sys.syslogins.name,
	sys.syslogins.dbname,
	sys.databases.name

from sys.syslogins
	left outer join sys.databases
	on sys.syslogins.dbname = sys.databases.name
where sys.databases.name is null
order by sys.databases.name