-- ============================================================
-- Update services.image to match service content
-- (Villa / Apartment / Office / Showroom)
-- ============================================================
SET NOCOUNT ON;

-- 1. Nội thất biệt thự -> luxury walnut villa living room
UPDATE dbo.services
SET image = N'/media/gallery/walnut-villa-living.webp'
WHERE id = 1;

-- 2. Nội thất chung cư -> compact walnut bedroom (apartment-style)
UPDATE dbo.services
SET image = N'/media/gallery/villa-bedroom-lounge.webp'
WHERE id = 2;

-- 3. Nội thất văn phòng -> walnut home library / study (office-style)
UPDATE dbo.services
SET image = N'/media/gallery/walnut-home-library.webp'
WHERE id = 3;

-- 4. Showroom & Trung tâm -> walnut joinery detail (showroom display)
UPDATE dbo.services
SET image = N'/media/gallery/walnut-joinery-detail.webp'
WHERE id = 4;

PRINT 'Services images updated successfully.';

