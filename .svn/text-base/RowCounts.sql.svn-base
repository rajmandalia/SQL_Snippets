select convert(varchar(30),object_name(id)) [Table Name], rows from sysindexes
where object_name(id) not like 'sys%' and indid = 1
order by object_name(id)