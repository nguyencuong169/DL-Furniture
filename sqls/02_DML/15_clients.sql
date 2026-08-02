-- =============================================
-- 02_DML/15_clients.sql
-- Seed: dbo.clients
-- =============================================
-- Idempotent: sử dụng MERGE.
MERGE INTO dbo.clients AS target
USING (VALUES
    (N'Client A', N'/src/assets/img/clients/1.png', N'#', 1, 1),
    (N'Client B', N'/src/assets/img/clients/2.png', N'#', 2, 1)
) AS source (name, logo_url, website_url, display_order, is_active)
ON target.name = source.name
WHEN MATCHED THEN
    UPDATE SET
        target.logo_url = source.logo_url,
        target.website_url = source.website_url,
        target.display_order = source.display_order,
        target.is_active = source.is_active
WHEN NOT MATCHED THEN
    INSERT (name, logo_url, website_url, display_order, is_active)
    VALUES (source.name, source.logo_url, source.website_url, source.display_order, source.is_active);
GO

PRINT 'Seed clients: done.';
GO
