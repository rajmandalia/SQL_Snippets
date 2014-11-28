if @@error <> 0 goto handleerror



handleerror:
	if object_id('tempdb..#keycolumns') is not null drop table #keycolumns
	if object_id('tempdb..#columns') is not null drop table #columns
	if object_id('tempdb..#output') is not null drop table #output


	if @@error <> 0 begin
		raiserror('update failed',16,1)
		set @returnid = 0
	end