--BEGIN TRAN
--ROLLBACK

USE msdb

GO
WHILE ( @@servername NOT IN ( '<ServerName,sysname,EX30SQL>' ) )
    OR ( DB_NAME() NOT IN ( 'msdb' ) )
    BEGIN
        PRINT 'WRONG SERVER OR DATABASE: ' + @@servername + '.' + DB_NAME()
    END


DECLARE @PlanID AS VARCHAR(255)

BEGIN TRAN DeleteOldMaintenancePlans

SELECT @PlanID = id
FROM sysmaintplan_plans
WHERE name LIKE '<MaintenancePlan Name,sysname,>'

DELETE FROM sysmaintplan_log
    WHERE plan_id = @PlanID

DELETE FROM sysmaintplan_subplans
    WHERE plan_id = @PlanID

DELETE FROM sysmaintplan_plans
    WHERE id = @PlanID

IF @@ERROR = 0
 COMMIT TRAN DeleteOldMaintenancePlans
ELSE
 ROLLBACK TRAN DeleteOldMaintenancePlans

GO