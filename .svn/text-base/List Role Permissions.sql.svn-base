
select
	left(dpr.name,35) as RoleName 
	, left(object_name(dpe.major_id),35) as ObjectName
	, left(dpr.type_desc, 30) as RoleType
	, dpe.permission_name as PermissionName
	, dpe.state_desc as StateDesc
from sys.database_permissions dpe
	inner join sys.database_principals dpr
	on dpe.grantee_principal_id = dpr.principal_id
where dpe.class = 1 and dpr.name <> 'public'
order by 
	dpr.name
	, object_name(dpe.major_id)