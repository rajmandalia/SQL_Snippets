-- Script to cursor through all tables in a database

set nocount on

declare 
	@TableName sysname
	,@TableDatabase sysname
	,@TableSchema sysname
	,@ProcedureID int

declare tables_cursor cursor for
	select distinct table_catalog, table_schema, table_name
		from information_schema.tables
		where table_type = 'BASE TABLE'
		order by table_name

open tables_cursor

fetch next from tables_cursor into @TableDatabase, @TableSchema, @TableName

while @@fetch_status = 0
begin
	select @TableName, @TableDatabase, @TableSchema

	-- code here

	fetch next from tables_cursor into @TableDatabase, @TableSchema, @TableName
end

close tables_cursor
deallocate tables_cursor
