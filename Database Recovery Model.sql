SELECT name, recovery_model_desc FROM sys.databases WHERE recovery_model_desc <> 'SIMPLE'

SELECT 'ALTER DATABASE [' + name + '] SET RECOVERY SIMPLE WITH NO_WAIT'  FROM sys.databases WHERE recovery_model_desc <> 'SIMPLE'


--ALTER DATABASE [EMK3EntEd_APP_Test] SET RECOVERY SIMPLE WITH NO_WAIT
--ALTER DATABASE [EMK3EntEd_DAL_Test] SET RECOVERY SIMPLE WITH NO_WAIT
--ALTER DATABASE [MasterView_20110207] SET RECOVERY SIMPLE WITH NO_WAIT
--ALTER DATABASE [Petrolook] SET RECOVERY SIMPLE WITH NO_WAIT
--ALTER DATABASE [Petrolook_Dev] SET RECOVERY SIMPLE WITH NO_WAIT
--ALTER DATABASE [Petrolook_Test] SET RECOVERY SIMPLE WITH NO_WAIT