
/* Two ways to drop all the FKs to truncate tables
Method 1 - disable all the constraints, will allow DELETE but not TRUNCATE
Method 2 - drop and recreate, will allow TRUNCATE
With Method 2 you can also be selective like below it does it just for the table "Events"

Reference: http://goo.gl/HoId8F

*/

/*Method 1*/

- Disable all the constraint in database
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

-- Enable all the constraint in database
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

/*Method 2*/
SET NOCOUNT ON

DECLARE @table TABLE
    (
      RowId INT PRIMARY KEY
                IDENTITY(1, 1)
    , ForeignKeyConstraintName NVARCHAR(200)
    , ForeignKeyConstraintTableSchema NVARCHAR(200)
    , ForeignKeyConstraintTableName NVARCHAR(200)
    , ForeignKeyConstraintColumnName NVARCHAR(200)
    , PrimaryKeyConstraintName NVARCHAR(200)
    , PrimaryKeyConstraintTableSchema NVARCHAR(200)
    , PrimaryKeyConstraintTableName NVARCHAR(200)
    , PrimaryKeyConstraintColumnName NVARCHAR(200) )

INSERT INTO @table
        ( ForeignKeyConstraintName
        , ForeignKeyConstraintTableSchema
        , ForeignKeyConstraintTableName
        , ForeignKeyConstraintColumnName )
    SELECT
            U.CONSTRAINT_NAME
          , U.TABLE_SCHEMA
          , U.TABLE_NAME
          , U.COLUMN_NAME
        FROM
            INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
        INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
            ON U.CONSTRAINT_NAME = C.CONSTRAINT_NAME
        WHERE
            C.CONSTRAINT_TYPE = 'FOREIGN KEY'

UPDATE
        @table
    SET
        PrimaryKeyConstraintName = UNIQUE_CONSTRAINT_NAME
    FROM
        @table T
    INNER JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS R
        ON T.ForeignKeyConstraintName = R.CONSTRAINT_NAME

UPDATE
        @table
    SET
        PrimaryKeyConstraintTableSchema = TABLE_SCHEMA
      , PrimaryKeyConstraintTableName = TABLE_NAME
    FROM
        @table T
    INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
        ON T.PrimaryKeyConstraintName = C.CONSTRAINT_NAME

UPDATE
        @table
    SET
        PrimaryKeyConstraintColumnName = COLUMN_NAME
    FROM
        @table T
    INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
        ON T.PrimaryKeyConstraintName = U.CONSTRAINT_NAME

SELECT
        *
    FROM
        @table
 WHERE
        PrimaryKeyConstraintTableName = 'Events'

--DROP CONSTRAINT:
SELECT
        '
ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + ']
DROP CONSTRAINT ' + ForeignKeyConstraintName + '

GO'
    FROM
        @table
    WHERE
        PrimaryKeyConstraintTableName = 'Events'


--ADD CONSTRAINT:
SELECT
        '
ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + ']
ADD CONSTRAINT ' + ForeignKeyConstraintName + ' FOREIGN KEY(' + ForeignKeyConstraintColumnName + ') REFERENCES ['
        + PrimaryKeyConstraintTableSchema + '].[' + PrimaryKeyConstraintTableName + ']('
        + PrimaryKeyConstraintColumnName + ')

GO'
    FROM
        @table
    WHERE
        PrimaryKeyConstraintTableName = 'Events'

GO

/*Example Result from Method 2*/

/*
  ALTER TABLE [dbo].[AlertEvents]  DROP CONSTRAINT FK_AlertEvents_Events    
  ALTER TABLE [dbo].[EventParamDateTimes]  DROP CONSTRAINT FK_EventParamDateTimes_Events    
  ALTER TABLE [dbo].[EventParamIntegers]  DROP CONSTRAINT FK_EventParamIntegers_Events    
  ALTER TABLE [dbo].[EventParamStrings]  DROP CONSTRAINT FK_EventParamStrings_Events    
  ALTER TABLE [dbo].[EventParamUndefined]  DROP CONSTRAINT FK_EventParamUndefined_Events    
  GO
  
  TRUNCATE TABLE dbo.Events
  GO
  TRUNCATE TABLE dbo.AlertEvents
  GO
  TRUNCATE TABLE dbo.EventParamIntegers
  GO
  TRUNCATE TABLE dbo.EventParamDateTimes
  GO
  TRUNCATE TABLE dbo.EventParamStrings
  GO
  TRUNCATE TABLE dbo.EventParamUndefined
  GO
  
  ALTER TABLE [dbo].[AlertEvents]  ADD CONSTRAINT FK_AlertEvents_Events FOREIGN KEY(EventFK) REFERENCES [dbo].[Events](EventPK)    
  ALTER TABLE [dbo].[EventParamDateTimes]  ADD CONSTRAINT FK_EventParamDateTimes_Events FOREIGN KEY(EventFK) REFERENCES [dbo].[Events](EventPK)    
  ALTER TABLE [dbo].[EventParamIntegers]  ADD CONSTRAINT FK_EventParamIntegers_Events FOREIGN KEY(EventFK) REFERENCES [dbo].[Events](EventPK)    
  ALTER TABLE [dbo].[EventParamStrings]  ADD CONSTRAINT FK_EventParamStrings_Events FOREIGN KEY(EventFK) REFERENCES [dbo].[Events](EventPK)    
  ALTER TABLE [dbo].[EventParamUndefined]  ADD CONSTRAINT FK_EventParamUndefined_Events FOREIGN KEY(EventFK) REFERENCES [dbo].[Events](EventPK)    
  GO
  */