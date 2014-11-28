-- =======================================================================
-- Name 			: <Function Name, varchar, cf_>
-- Author			: <Author, varchar, Raj Mandalia>
-- Create Date		: <Create Date, datetime, 01/01/2002>
-- Description		: <Description, varchar, Function used to ...>
-- 
-- Parameters		:
-- Returns			:
-- =======================================================================
-- Modification History
-- --------------------
-- <Create Date, datetime, 01/01/2002> : Created
-- 
-- =======================================================================

-- Target Database
-- ---------------

use <Target Database, varchar, SGI_Cylinder>
go


-- Drop Existing Process
-- ---------------------
if object_id('<Function Name, varchar, cf_>') is not null
	drop function <Function Name, varchar, cf_>
go


-- Create Process
-- --------------
create function <Function Name, varchar, cf_> 
	(<@param1, sysName, @p1> <data_type_for_param1, , int>, 
	 <@param2, sysName, @p2> <data_type_for_param2, , int>)
returns <function_data_type, ,int>
as
begin

	<function_body, , RETURN @p1 + @p2 >

end



-- end of file : <Function Name, varchar, cf_>

go
