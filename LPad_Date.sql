IF OBJECT_ID('LPad_Date') IS NOT NULL
    DROP FUNCTION dbo.LPad_Date

GO

CREATE FUNCTION LPad_Date ( @str VARCHAR(MAX)	-- string to be padded
                            )
RETURNS DATETIME
AS
    BEGIN
	-- Declare the return variable here
        DECLARE @Result DATETIME

        SELECT @str = LTRIM(RTRIM(@str))
        IF LEN(@str) BETWEEN 5 AND 6
            BEGIN
                SELECT @str = REPLICATE('0', 6 - LEN(@str)) + @str
                SELECT @str = LEFT(@str, 2) + '/' + SUBSTRING(@str, 3, 2)
                        + '/' + RIGHT(@str, 2) 
						SELECT @result = CONVERT(DATETIME, @str, 1)

            END
        ELSE
            SELECT @Result = NULL


	-- Return the result of the function
        RETURN @Result

    END
GO


-- usage examples

SELECT dbo.lpad_date('92614'), dbo.lpad_date('100314'), dbo.lpad_date('1192614'), dbo.lpad_date('9914')