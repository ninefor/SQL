ALTER PROCEDURE [dbo].next_bh
@colname varchar(100),
@entity varchar(100),
@dm varchar(100),
@ls_len int =4


AS
BEGIN
Declare @sql nvarchar(1000)
Declare @str varchar(100)

 set @sql=' select @nbh=isnull(max('+@colname+'),'''+@dm+'''+CONVERT(varchar(100), GETDATE(), 112)+''-''+left(''0000000000'','+convert(varchar(5),@ls_len)+')) from '+@entity+' where SUBSTRING('+@colname+',1,'+convert(varchar(5),len(@dm))+'+8)='''+@dm+'''+CONVERT(varchar(100), GETDATE(), 112)'
exec sp_executesql @sql,N'@nbh nvarchar(100) output',@str output
set @str=@dm+SUBSTRING(@str,len(@dm)+1,8)+'-'+right('0000000000'+ltrim(right(@str,CHARINDEX(REVERSE(@dm+CONVERT(varchar(100), GETDATE(), 112)),REVERSE(@str))-2)+1),@ls_len)
select @str
END
