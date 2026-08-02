-- =============================================
-- 02_DML/10_booking_requests.sql
-- Seed: dbo.booking_requests
-- =============================================
-- Idempotent: chèn nếu chưa tồn tại.
-- Chuẩn cột theo DB hiện tại (API): source default = 'consultation_form'.
IF NOT EXISTS (SELECT 1 FROM dbo.booking_requests WHERE full_name = N'Tran Thi B' AND email = N'b@example.com')
BEGIN
    INSERT INTO dbo.booking_requests (full_name, email, phone, message, checkin_date, checkout_date, adults, children, source, status)
    VALUES (N'Tran Thi B', N'b@example.com', N'0912345678', N'Tôi muốn tư vấn nội thất chung cư', NULL, NULL, NULL, NULL, N'consultation_form', N'pending');
END;
GO

PRINT 'Seed booking_requests: done.';
GO
