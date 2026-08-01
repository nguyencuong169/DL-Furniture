-- ============================================================
-- Revert services.image back to original pricing images
-- (Restore 05_PricingComponent original state)
-- ============================================================
SET NOCOUNT ON;

UPDATE dbo.services SET image = N'/src/assets/img/pricing/1.jpg' WHERE id = 1;
UPDATE dbo.services SET image = N'/src/assets/img/pricing/2.jpg' WHERE id = 2;
UPDATE dbo.services SET image = N'/src/assets/img/pricing/3.jpg' WHERE id = 3;
UPDATE dbo.services SET image = N'/src/assets/img/pricing/4.jpg' WHERE id = 4;

PRINT 'Services images reverted successfully.';

