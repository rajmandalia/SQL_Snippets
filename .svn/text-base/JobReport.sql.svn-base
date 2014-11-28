

    SELECT
        ( CASE run_status
            WHEN 0 THEN 'Failed'
            WHEN 1 THEN 'Succeeded'
            WHEN 2 THEN 'Retry'
            WHEN 3 THEN 'Cancelled'
            ELSE 'In Progress'
          END ) AS [Status]
       ,run_date AS [RunDate]
       ,run_time AS [RunTime]
        --,left(j.name,150) AS [JobName]
       ,CASE h.step_id
          WHEN 0 THEN LEFT(j.name, 50)
          ELSE SPACE(5) + LEFT(h.step_name, 50)
        END AS [JobStep]
    FROM
        msdb..sysjobhistory h
        JOIN msdb..sysjobs j
            ON h.job_id = j.job_id
    WHERE
        j.enabled = 1
        AND run_date >= CONVERT(VARCHAR(8), DATEADD(dd, -3, GETDATE()), 112)
        --AND h.step_id = 0
    ORDER BY
        run_date DESC,
        run_time
       ,j.name
       ,h.step_id




	
