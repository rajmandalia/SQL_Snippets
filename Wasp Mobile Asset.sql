USE wasptrackasset

SELECT
    dbo.employees.employee_id
   ,dbo.employees.first_name
   ,dbo.employees.last_name
   ,dbo.asset_transactions.trans_date
   ,dbo.asset_transactions.trans_type
   ,dbo.asset_transactions.serial_number
   ,dbo.asset_transactions.record_status
   ,dbo.item.item_id
   ,dbo.item.description
   ,dbo.asset.asset_tag
   ,dbo.transaction_types.trans_description
FROM
    dbo.asset
    INNER JOIN dbo.item
        ON dbo.asset.item_id = dbo.item.item_id
    INNER JOIN dbo.asset_transactions
        ON dbo.asset.asset_id = dbo.asset_transactions.asset_id
    INNER JOIN dbo.employees
        ON dbo.asset_transactions.employee_id = dbo.employees.employee_id
    INNER JOIN dbo.transaction_types
        ON dbo.asset_transactions.trans_type = dbo.transaction_types.trans_type_no
WHERE
    ( dbo.employees.last_name = 'Mandalia' )
    AND ( dbo.asset_transactions.record_status = 1 )