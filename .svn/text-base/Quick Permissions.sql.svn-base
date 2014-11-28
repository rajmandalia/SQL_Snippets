SELECT t2.name,t1.* FROM sys.server_permissions t1 , sys.server_principals 
t2 where t1.grantee_principal_id = t2.principal_id and t1.type<>'R'  
and t1.state = 'D' -- DENY