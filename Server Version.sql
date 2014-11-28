SELECT
    @@SERVERNAME AS 'Server'
   ,@@VERSION AS 'Version'
   ,SERVERPROPERTY('productversion') AS 'Version #'
   ,SERVERPROPERTY('productlevel') AS 'Product Level'
   ,SERVERPROPERTY('edition') AS 'Edition'