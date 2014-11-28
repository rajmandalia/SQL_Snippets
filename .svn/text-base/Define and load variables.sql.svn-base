

sp_declarevars <Table Name, varchar, xxx>
go
sp_loadvars <Table Name, varchar, xxx>
go
sp_select <Table Name, varchar, xxx>
go

select name from syscolumns
	where object_name(id) = '<Table Name, varchar, xxx>'
	order by colorder
go

/* make sure the table has a primary key defined and that the output is set to 8000 chars / line */
-- sp_GenScript <Table Name, varchar, xxx>
-- go