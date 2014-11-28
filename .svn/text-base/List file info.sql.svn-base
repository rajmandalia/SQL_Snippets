	select 	
		fileid
		,left(name,25) as LogicalName
		,left(filename,100) as PhysicalName
		,convert(nvarchar(15), convert(bigint, size)*8) + ' KB' as Size
		,(case maxsize when -1 then 'Unlimited'
			else convert(nvarchar(15), convert (bigint, maxsize) * 8) + ' KB' 
		end) as MaxSize
		,(case status & 0x100000 
			when 0x100000 then convert(nvarchar(15), growth) + '%'
			else convert(nvarchar(15), convert (bigint, growth) * 8) + ' KB' 
		end) as Growth
		,(case status & 0x40 
			when 0x40 then 'log only' 
			else 'data only' 
		end) as Usage
	from sysfiles
--	where filename = case 
--						when @filename is null then filename
--						else @filename
--					end
	order by fileid
