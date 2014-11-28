
/* error handling code snippet */
/* used with oplog - refer to Standards ER diagram */
/* Author : Raj Mandalia */
/* Date   : 09/15/2002 */


declare 
	@mError int, 
	@mRowCount int,
	@mBatch int,
	@mProcessID varchar(50)

select 	
	@ResultID = 0, 
	@ResultMsg = '',
	@mError = 0, 
	@mRowCount = 0,
	@mBatch = convert(int,getdate()),
	@mProcessID = <Process ID, varchar, ct_my_trigger>

	
		-- error checking
		select 
            @mError = @@error, 
            @mRowCount = @@rowcount

		if @mError <> 0 begin

			select 
                @ResultID = -1, 
				@ResultMsg = <Error Message, varchar, Error Message>

            exec dbo.cp_write_oplog
                @optype= 'internal', 						-- internal, private, public, debug
                @batch= @mBatch,	 						-- jdate
                @opcode= convert(varchar(@mError))			-- error code
                @opsubcode= convert(varchar(@ResultID)),	-- result id
                @msg= @ResultMsg,							-- result message
                @processid= @mProcessID,					-- calling process
                @ResultID= null,
                @ResultMsg= null

		end -- error checking