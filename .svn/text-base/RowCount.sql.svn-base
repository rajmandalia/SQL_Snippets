--SQL 2005 or 2008
select sum (spart.rows)
from sys.partitions spart
where spart.object_id = object_id('<Table name, SYSNAME, >')
and spart.index_id < 2

--SQL 2000
select max(ROWS) from sysindexes
where id = object_id('<Table name, SYSNAME, >')
