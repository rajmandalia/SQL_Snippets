IF OBJECT_ID('LPad') IS NOT NULL
	DROP FUNCTION dbo.LPad

GO

CREATE FUNCTION LPad 
(
	@str VARCHAR(max),	-- string to be padded
    @len INT,			-- padded size
	@pad CHAR(1)		-- padding character
)
RETURNS VARCHAR(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result VARCHAR(max)

	SELECT @str = LTRIM(RTRIM(@str))
	IF LEN(@str) < @len
		SELECT @Result =  REPLICATE(ISNULL(@pad,'0'),@len - LEN(@str)) + @str
	ELSE 
		SELECT @Result = @str

	-- Return the result of the function
	RETURN @Result

END
GO


-- usage examples

SELECT dbo.LPad('aa',6,null)
SELECT dbo.lpad('12',6,'a')
SELECT dbo.lpad('123456',6,'0')
SELECT dbo.lpad('12345678',6,'x')

