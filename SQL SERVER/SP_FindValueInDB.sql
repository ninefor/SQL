CREATE PROCEDURE [dbo].[SP_FindValueInDB]
(
    @value VARCHAR(1024)
)        
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
SET NOCOUNT ON;
DECLARE @sql VARCHAR(1024) 
DECLARE @table VARCHAR(64) 
DECLARE @column VARCHAR(64) 

CREATE TABLE #t ( 
    tablename VARCHAR(64), 
    columnname VARCHAR(64) 
) 

DECLARE TABLES CURSOR 
FOR 

    SELECT o.name, c.name 
    FROM syscolumns c 
    INNER JOIN sysobjects o ON c.id = o.id 
    WHERE o.type = 'U' AND c.xtype IN (167, 175, 231, 239) 
    ORDER BY o.name, c.name 

OPEN TABLES 

FETCH NEXT FROM TABLES 
INTO @table, @column 

WHILE @@FETCH_STATUS = 0 
BEGIN 
    SET @sql = 'IF EXISTS(SELECT NULL FROM [' + @table + '] ' 
    SET @sql = @sql + 'WHERE RTRIM(LTRIM([' + @column + '])) LIKE ''%' + @value + '%'') ' 
    SET @sql = @sql + 'INSERT INTO #t VALUES (''' + @table + ''', ''' 
    SET @sql = @sql + @column + ''')' 

    EXEC(@sql) 

    FETCH NEXT FROM TABLES 
    INTO @table, @column 
END 

CLOSE TABLES 
DEALLOCATE TABLES 

SELECT * 
FROM #t 

DROP TABLE #t 


End


--调用 
--exec [SP_FindValueInDB] 查询的值