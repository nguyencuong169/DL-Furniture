-- =============================================
-- 02_DML/17_site_settings.sql
-- Seed: dbo.site_settings
-- =============================================
-- Idempotent: sử dụng MERGE.
MERGE INTO dbo.site_settings AS target
USING (VALUES
    (N'company_name', N'D&L Furniture'),
    (N'phone', N'(+84) 961-109-897'),
    (N'email', N'info@dl-furniture.com')
) AS source (key_name, value_text)
ON target.key_name = source.key_name
WHEN MATCHED THEN
    UPDATE SET
        target.value_text = source.value_text
WHEN NOT MATCHED THEN
    INSERT (key_name, value_text)
    VALUES (source.key_name, source.value_text);
GO

PRINT 'Seed site_settings: done.';
GO
