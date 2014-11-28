
select 
	left(dp1.name,35) as RoleName, 
	left(dp2.name,35) as UserName
from sys.database_role_members drm
	inner join sys.database_principals dp1
		on drm.role_principal_id = dp1.principal_id
	inner join sys.database_principals dp2
		on drm.member_principal_id = dp2.principal_id
	order by 1, 2