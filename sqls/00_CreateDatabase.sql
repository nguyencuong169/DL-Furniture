-- =============================================
-- 00. Create DL-Furniture Database (SQL Server)
-- =============================================
-- Idempotent: an toàn khi chạy lại.
-- Chạy bằng sqlcmd (nên dùng -f 65001 cho tiếng Việt UTF-8):
--   sqlcmd -S localhost -U sa -P your_password -b -f 65001 -i sqls\00_CreateDatabase.sql

SET NOCOUNT ON;

USE master;
GO

IF DB_ID(N'DLFurniture') IS NULL
BEGIN
    CREATE DATABASE DLFurniture;
    PRINT 'Database DLFurniture created successfully.';
END
ELSE
    PRINT 'Database DLFurniture already exists.';
GO

USE DLFurniture;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

PRINT '00_CreateDatabase.sql completed.';

