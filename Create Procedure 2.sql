-- =======================================================================
-- Name			: <Procedure Name, varchar, cp_>
-- Author		: <Author, varchar, Raj Mandalia>
-- Create Date	: <Create Date, datetime, 01/01/2004>
-- Description	: <Description, varchar, Procedure used to ...>
-- 
-- Parameters	: <Parameters, varchar, /* Params */>
-- 					@pResultID int output, @pResultMsg varchar(500) output
-- Returns		: <Returns, varchar, /* Return Params */>
--					@pResultID : -ve = error, 0 = successful, +ve = warning /info
--					@pResultMsg : appro. message or NULL
-- =======================================================================
-- Modification History
-- --------------------
-- <Create Date, datetime, 01/01/2004>,<Author, varchar, Raj Mandalia> : Created
-- 
-- =======================================================================

-- Target Database
-- ---------------

use <Target Database, varchar, SGI_Cylinder>
go


-- Drop Existing Process
-- ---------------------
if object_id('<Procedure Name, varchar, cp_>') is not null
	drop procedure <Procedure Name, varchar, cp_>
go


-- Create Process
-- --------------
create procedure <Procedure Name, varchar, cp_>

	<Parameters, varchar, /* Params */>, 
	@ResultID int output, 
	@ResultMsg varchar(500) output

as

	set nocount on
	
	declare 
		@mError int, 
		@mRowCount int
	
	select 
		@ResultID = 0, 
		@ResultMsg = '',
		@mError = 0, 
		@mRowCount = 0
	
	
	
	
	select @mError = @@error , @mRowCount = @@rowcount
	if @mError <> 0 or @mRowCount = 0 begin
		select 
			@ResultID = 0, 
			@ResultMsg = ''
		goto exitpoint
	end
	

exitpoint:

	set nocount off

Return @ResultID

-- End of File : <Procedure Name, varchar, cp_>

go
