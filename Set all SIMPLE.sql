SELECT name, recovery_model_desc,* FROM sys.databases WHERE recovery_model = 1


SELECT 'ALTER DATABASE [' + name + '] SET RECOVERY SIMPLE WITH NO_WAIT' FROM sys.databases WHERE recovery_model = 1
 AND LEFT(name,3) <> 'EMK' AND database_id  > 6