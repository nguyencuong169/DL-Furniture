-- =============================================
-- 02_DML/13_team_members.sql
-- Seed: dbo.team_members
-- =============================================
-- Idempotent: sử dụng MERGE.
-- Chuẩn cột theo DB hiện tại (API TeamMember):
--   full_name, role, avatar_image, email, facebook_url, twitter_url,
--   instagram_url, pinterest_url, sort_order, hidden, del_flag,
--   created_user, created_date, updated_user, updated_date.
MERGE INTO dbo.team_members AS target
USING (VALUES
    (N'Valentina Karla', N'General Manager', N'/src/assets/img/team/4.jpg', N'valentina@hotel.com', N'#', N'#', N'#', N'#', 1, 0, 0, N'seed', N'seed'),
    (N'Micheal White', N'Guest Service Department', N'/src/assets/img/team/1.jpg', N'micheal@hotel.com', N'#', N'#', N'#', N'#', 2, 0, 0, N'seed', N'seed'),
    (N'Olivia Martin', N'Reservations Manager', N'/src/assets/img/team/2.jpg', N'olivia@hotel.com', N'#', N'#', N'#', N'#', 3, 0, 0, N'seed', N'seed')
) AS source (full_name, role, avatar_image, email, facebook_url, twitter_url, instagram_url, pinterest_url, sort_order, hidden, del_flag, created_user, updated_user)
ON target.full_name = source.full_name
WHEN MATCHED THEN
    UPDATE SET
        target.role = source.role,
        target.avatar_image = source.avatar_image,
        target.email = source.email,
        target.facebook_url = source.facebook_url,
        target.twitter_url = source.twitter_url,
        target.instagram_url = source.instagram_url,
        target.pinterest_url = source.pinterest_url,
        target.sort_order = source.sort_order,
        target.hidden = source.hidden,
        target.del_flag = source.del_flag,
        target.updated_user = source.updated_user
WHEN NOT MATCHED THEN
    INSERT (full_name, role, avatar_image, email, facebook_url, twitter_url, instagram_url, pinterest_url, sort_order, hidden, del_flag, created_user, updated_user)
    VALUES (source.full_name, source.role, source.avatar_image, source.email, source.facebook_url, source.twitter_url, source.instagram_url, source.pinterest_url, source.sort_order, source.hidden, source.del_flag, source.created_user, source.updated_user);
GO

PRINT 'Seed team_members: done.';
GO
