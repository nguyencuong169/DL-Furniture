-- =============================================
-- 02_DML/09_contact_messages.sql
-- Seed: dbo.contact_messages
-- =============================================
-- Idempotent: chèn nếu chưa tồn tại (dựa trên email + name + message).
IF NOT EXISTS (SELECT 1 FROM dbo.contact_messages WHERE name = N'Nguyen Van A' AND email = N'a@example.com')
BEGIN
    INSERT INTO dbo.contact_messages (name, email, phone, subject, message, source, status)
    VALUES (N'Nguyen Van A', N'a@example.com', N'0901234567', N'Tư vấn thiết kế', N'Xin tư vấn thiết kế phòng khách 30m2', N'contact_form', N'new');
END;
GO

PRINT 'Seed contact_messages: done.';
GO
