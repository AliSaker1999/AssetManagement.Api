USE [Assets]
GO

/*
  Adds EmailAddress to SEC.Users and updates user CRUD procedures.
  Safe to run multiple times.
*/

IF COL_LENGTH('SEC.Users', 'EmailAddress') IS NULL
BEGIN
    ALTER TABLE SEC.Users ADD EmailAddress NVARCHAR(255) NULL;
END
GO

UPDATE u
SET    EmailAddress = CONCAT(u.UserName, '@example.com')
FROM   SEC.Users u
WHERE  u.EmailAddress IS NULL OR LTRIM(RTRIM(u.EmailAddress)) = '';
GO

IF EXISTS (
    SELECT 1
    FROM sys.columns c
    INNER JOIN sys.objects o ON c.object_id = o.object_id
    INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
    WHERE s.name = 'SEC'
      AND o.name = 'Users'
      AND o.type = 'U'
      AND c.name = 'EmailAddress'
      AND c.is_nullable = 1
)
BEGIN
    ALTER TABLE SEC.Users ALTER COLUMN EmailAddress NVARCHAR(255) NOT NULL;
END
GO

CREATE OR ALTER PROCEDURE [SEC].[stpUsersI]
(
    @UserName      NVARCHAR(100),
    @Password      NVARCHAR(256),
    @FullName      NVARCHAR(100),
    @EmailAddress  NVARCHAR(255),
    @RoleID        TINYINT
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO SEC.Users (UserName, UserPassword, FullName, EmailAddress, RoleID)
    VALUES (@UserName, HASHBYTES('SHA2_256', @Password), @FullName, @EmailAddress, @RoleID);

    SELECT SCOPE_IDENTITY() AS UserID;
END
GO

CREATE OR ALTER PROCEDURE [SEC].[stpUsersU]
(
    @UserID        SMALLINT,
    @UserName      NVARCHAR(100),
    @Password      NVARCHAR(256) = NULL,
    @FullName      NVARCHAR(100),
    @EmailAddress  NVARCHAR(255),
    @RoleID        TINYINT
)
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE SEC.Users
    SET    UserName     = @UserName,
           FullName     = @FullName,
           EmailAddress = @EmailAddress,
           RoleID       = @RoleID,
           UserPassword = CASE
                              WHEN @Password IS NOT NULL AND @Password <> ''
                              THEN HASHBYTES('SHA2_256', @Password)
                              ELSE UserPassword
                          END
    WHERE  UserID = @UserID;
END
GO

CREATE OR ALTER PROCEDURE [SEC].[stpUsersS]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT u.UserID, u.UserName, u.FullName, u.EmailAddress, u.RoleID, r.RoleName
    FROM   SEC.Users u
    JOIN   SEC.Roles r ON u.RoleID = r.RoleID
    ORDER BY u.FullName;
END
GO
