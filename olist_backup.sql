USE Olist;
GO

BACKUP DATABASE Olist
TO DISK = 'C:\SQLBackups\Olist_Backup.bak'
WITH FORMAT,
     MEDIANAME = 'SQLServerBackups',
     NAME = 'Full Backup of Olist Dataset';
GO