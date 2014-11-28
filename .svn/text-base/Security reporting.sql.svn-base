-- select 
--		left(name,25) as ObjectName, 
--		left(type_desc,10) as TypeDesc, 
--		left(user_name(grantee_principal_id),25) UserName, 
--		left(permission_name,10) as PermissionName,
--		state_desc
--		
--	from  sys.database_permissions dp
--	left outer join sys.all_objects ao
--	on dp.major_id = ao.object_id
--	where ao.type = 'V' -- only views
--		and grantee_principal_id <> 0 -- dont include public
--
-- go


--use sp_helprotect instead