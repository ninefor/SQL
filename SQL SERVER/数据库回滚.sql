--杀进程获取访问权
declare @dbname varchar(50)
set @dbname='lf_erp_ys'
declare @sql varchar(50)
declare cs_result cursor local for select 'kill '+cast(spid as varchar(50)) from sys.sysprocesses where db_name(dbid)=@dbname 
open cs_result
fetch next from cs_result into @sql
while @@fetch_status=0
begin
    execute(@sql)
    fetch next from cs_result into @sql
end
close cs_result
deallocate cs_result

--备份日志文件
BACKUP LOG [lf_erp_ys] TO disk= N'D:\test.bak' WITH NORECOVERY
--还原以前的完整备份
RESTORE DATABASE [lf_erp_ys] FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Backup\lf_erp_ys.bak' WITH NORECOVERY,  REPLACE
--回滚日志
RESTORE LOG [lf_erp_ys] FROM  DISK = N'D:\test.bak' WITH   STOPAT = N'2016-03-20 11:15:00' , RECOVERY
--取消数据库的还原状态
RESTORE database   [lf_erp_ys] with recovery 
