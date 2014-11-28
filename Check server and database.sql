IF ( @@servername NOT IN ( 'SERVERNAME' ) )
    OR ( DB_NAME() NOT IN ( 'DatabaseName' ) ) 
    BEGIN
        GOTO ErrorPoint
    END	
PRINT 'Server and Database verified as ' + @@servername + '.' + DB_NAME()

GOTO ExitPoint
ErrorPoint:
PRINT 'WRONG SERVER OR DATABASE: ' + @@servername + '.' + DB_NAME()
ExitPoint:
PRINT 'DONE'

---------------

WHILE ( @@servername NOT IN ( 'SERVERNAME' ) )
    OR ( DB_NAME() NOT IN ( 'DatabaseName' ) )
    BEGIN
        PRINT 'WRONG SERVER OR DATABASE: ' + @@servername + '.' + DB_NAME()
    END	