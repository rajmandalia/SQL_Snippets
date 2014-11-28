


-- create login from ActiveDirectory 
-- and add as user to database
-- Raj Mandalia - 2007-01-23

use [master]
go
create login [<Username,sysname,>] from windows with default_database=[<Database,sysname,>]
go


use [<Database,sysname,>]
go
create user [<Username,sysname,>] for login [<Username,sysname,>]
go
