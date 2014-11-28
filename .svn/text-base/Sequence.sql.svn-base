

SELECT
    ( SELECT
        RIGHT(REPLICATE('0', <StringLength,int,5>) + CONVERT(VARCHAR, COUNT(1) + <StartFrom,int,100>), <StringLength,int,5>)
      FROM
        <TableName,sysname,sys.sysfiles> B
      WHERE
        B.<UniqueKey,sysname,fileid> <LessThan,CHAR(1),<> a.<UniqueKey,sysname,fileid>
    ) AS NUMSEQ, A.*
FROM
    <TableName,sysname,sys.sysfiles> A
ORDER BY
    A.<UniqueKey,sysname,fileid>
         
