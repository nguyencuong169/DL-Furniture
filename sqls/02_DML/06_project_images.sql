-- =============================================
-- 02_DML/06_project_images.sql
-- Seed: dbo.project_images
-- =============================================
-- Idempotent: sử dụng MERGE. Cần projects có id 1, 2.
MERGE INTO dbo.project_images AS target
USING (VALUES
    (1, N'/src/assets/img/slider/4.jpg', N'Saroma Villa', 1),
    (2, N'/src/assets/img/slider/3.jpg', N'Vinhomes Grand Park', 1)
) AS source (project_id, image_url, caption, sort_order)
ON (target.project_id = source.project_id AND target.image_url = source.image_url)
WHEN NOT MATCHED THEN
    INSERT (project_id, image_url, caption, sort_order)
    VALUES (source.project_id, source.image_url, source.caption, source.sort_order);
GO

PRINT 'Seed project_images: done.';
GO
