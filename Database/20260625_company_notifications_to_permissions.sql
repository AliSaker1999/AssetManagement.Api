USE [Assets]
GO

/*
  Removes company-level notification targets (EmailNotification/UserNotification)
  and switches notification recipients to all users with access to the company.
  Safe to run multiple times.
*/

IF EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Companies_Users_Notification'
      AND parent_object_id = OBJECT_ID('GSET.Companies')
)
BEGIN
    ALTER TABLE GSET.Companies DROP CONSTRAINT FK_Companies_Users_Notification;
END
GO

IF COL_LENGTH('GSET.Companies', 'UserNotification') IS NOT NULL
BEGIN
    ALTER TABLE GSET.Companies DROP COLUMN UserNotification;
END
GO

IF COL_LENGTH('GSET.Companies', 'EmailNotification') IS NOT NULL
BEGIN
    ALTER TABLE GSET.Companies DROP COLUMN EmailNotification;
END
GO

CREATE OR ALTER PROCEDURE [GSET].[stpCompaniesI]
(
    @CompanyName         nvarchar(100),
    @CompanyAbbreviation nvarchar(10),
    @CompanyPrmCurCode   char(3),
    @CompanyScdCurCode   char(3),
    @CountryID           char(2)
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO GSET.Companies
        (CompanyName, CompanyAbbreviation, CompanyPrmCurCode, CompanyScdCurCode, CountryID)
    VALUES
        (@CompanyName, @CompanyAbbreviation, @CompanyPrmCurCode, @CompanyScdCurCode, @CountryID);

    SELECT CompanyID, CompanyName, CompanyAbbreviation,
           CompanyPrmCurCode, CompanyScdCurCode, CountryID
    FROM   GSET.Companies
    WHERE  CompanyID = SCOPE_IDENTITY();
END
GO

CREATE OR ALTER PROCEDURE [GSET].[stpCompaniesU]
(
    @CompanyID           smallint,
    @CompanyName         nvarchar(100),
    @CompanyAbbreviation nvarchar(10),
    @CompanyPrmCurCode   char(3),
    @CompanyScdCurCode   char(3),
    @CountryID           char(2)
)
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE GSET.Companies
    SET    CompanyName         = @CompanyName,
           CompanyAbbreviation = @CompanyAbbreviation,
           CompanyPrmCurCode   = @CompanyPrmCurCode,
           CompanyScdCurCode   = @CompanyScdCurCode,
           CountryID           = @CountryID
    WHERE  CompanyID = @CompanyID;
END
GO

CREATE OR ALTER PROCEDURE [GSET].[stpGetCompanies]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CompanyID, CompanyName, CompanyAbbreviation,
           CompanyPrmCurCode, CompanyScdCurCode, CountryID
    FROM   GSET.Companies
    ORDER BY CompanyName;
END
GO

CREATE OR ALTER PROCEDURE [NOTIF].[stpGetPendingWarrantyNotifications]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        w.WarntID,
        w.AssetID,
        w.WarrantyDesc,
        w.ToDate,
        a.CompanyID,
        a.AssetCode,
        a.AssetDesc,
        up.UserID AS RecipientUserID,
        u.EmailAddress AS RecipientEmailAddress,
        DATEDIFF(day, CAST(GETDATE() AS date), w.ToDate) AS DaysLeft
    FROM  AT.Warranties w
    INNER JOIN AT.Assets a ON a.AssetID = w.AssetID
    INNER JOIN SEC.UsersPermissions up ON up.CompanyID = a.CompanyID
    INNER JOIN SEC.Users u ON u.UserID = up.UserID
    WHERE w.ToDate >= CAST(GETDATE() AS date)
      AND DATEDIFF(day, CAST(GETDATE() AS date), w.ToDate) <= 14;
END
GO

CREATE OR ALTER PROCEDURE [NOTIF].[stpGetPendingMaintenanceNotifications]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        m.MaintID,
        m.AssetID,
        m.FromDate,
        m.ToDate,
        a.CompanyID,
        a.AssetCode,
        a.AssetDesc,
        a.StatusID,
        up.UserID AS RecipientUserID,
        u.EmailAddress AS RecipientEmailAddress,
        DATEDIFF(day, CAST(GETDATE() AS date), m.ToDate) AS DaysLeft
    FROM  AT.Maintenances m
    INNER JOIN AT.Assets a ON a.AssetID = m.AssetID
    INNER JOIN SEC.UsersPermissions up ON up.CompanyID = a.CompanyID
    INNER JOIN SEC.Users u ON u.UserID = up.UserID
    WHERE a.StatusID = 8;
END
GO
