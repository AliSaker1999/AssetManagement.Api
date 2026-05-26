-- ============================================================
-- Notification System — run in SSMS in order
-- ============================================================

-- 1. Schema
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'NOTIF')
EXEC('CREATE SCHEMA [NOTIF]');
GO

-- 2. In-app notifications (persisted, per user)
IF NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id WHERE s.name='NOTIF' AND t.name='Notifications')
CREATE TABLE [NOTIF].[Notifications](
    [NotifID]   [int]          IDENTITY(1,1) NOT NULL,
    [UserID]    [smallint]     NOT NULL,
    [CompanyID] [smallint]     NOT NULL,
    [Type]      [nvarchar](20) NOT NULL,      -- 'Warranty' | 'Maintenance'
    [EntityID]  [int]          NOT NULL,       -- WarntID or MaintID
    [AssetID]   [int]          NOT NULL,
    [Message]   [nvarchar](500) NOT NULL,
    [IsRead]    [bit]          NOT NULL CONSTRAINT [DF_Notifications_IsRead] DEFAULT 0,
    [CreatedAt] [datetime]     NOT NULL CONSTRAINT [DF_Notifications_CreatedAt] DEFAULT GETDATE(),
    CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED ([NotifID] ASC)
);
GO

-- 3. NotificationLogs — prevents sending the same notification twice
IF NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id WHERE s.name='NOTIF' AND t.name='NotificationLogs')
CREATE TABLE [NOTIF].[NotificationLogs](
    [LogID]         [int]          IDENTITY(1,1) NOT NULL,
    [Type]          [nvarchar](20) NOT NULL,
    [EntityID]      [int]          NOT NULL,
    [IntervalLabel] [nvarchar](30) NOT NULL,  -- '14','7','3','0'  or  'Daily-2024-01-15'
    [SentAt]        [datetime]     NOT NULL CONSTRAINT [DF_NotificationLogs_SentAt] DEFAULT GETDATE(),
    CONSTRAINT [PK_NotificationLogs] PRIMARY KEY CLUSTERED ([LogID] ASC),
    CONSTRAINT [UQ_NotifLog] UNIQUE NONCLUSTERED ([Type], [EntityID], [IntervalLabel])
);
GO

-- 4. stpGetPendingWarrantyNotifications
IF OBJECT_ID('NOTIF.stpGetPendingWarrantyNotifications') IS NOT NULL
    DROP PROCEDURE [NOTIF].[stpGetPendingWarrantyNotifications];
GO
CREATE PROCEDURE [NOTIF].[stpGetPendingWarrantyNotifications]
AS
    SET NOCOUNT ON;
    SELECT
        w.WarntID, w.AssetID, w.WarrantyDesc, w.ToDate,
        a.CompanyID, a.AssetCode, a.AssetDesc,
        c.EmailNotification, c.UserNotification,
        DATEDIFF(day, CAST(GETDATE() AS date), w.ToDate) AS DaysLeft
    FROM  AT.Warranties w
    INNER JOIN AT.Assets a      ON a.AssetID   = w.AssetID
    INNER JOIN GSET.Companies c ON c.CompanyID = a.CompanyID
    WHERE w.ToDate >= CAST(GETDATE() AS date)
      AND DATEDIFF(day, CAST(GETDATE() AS date), w.ToDate) <= 14
      AND (c.EmailNotification IS NOT NULL OR c.UserNotification IS NOT NULL);
GO

-- 5. stpGetPendingMaintenanceNotifications
IF OBJECT_ID('NOTIF.stpGetPendingMaintenanceNotifications') IS NOT NULL
    DROP PROCEDURE [NOTIF].[stpGetPendingMaintenanceNotifications];
GO
CREATE PROCEDURE [NOTIF].[stpGetPendingMaintenanceNotifications]
AS
    SET NOCOUNT ON;
    SELECT
        m.MaintID, m.AssetID, m.FromDate, m.ToDate,
        a.CompanyID, a.AssetCode, a.AssetDesc, a.StatusID,
        c.EmailNotification, c.UserNotification,
        DATEDIFF(day, CAST(GETDATE() AS date), m.ToDate) AS DaysLeft
    FROM  AT.Maintenances m
    INNER JOIN AT.Assets a      ON a.AssetID   = m.AssetID
    INNER JOIN GSET.Companies c ON c.CompanyID = a.CompanyID
    WHERE a.StatusID = 8
      AND (c.EmailNotification IS NOT NULL OR c.UserNotification IS NOT NULL);
GO

-- 6. stpCreateNotification
IF OBJECT_ID('NOTIF.stpCreateNotification') IS NOT NULL
    DROP PROCEDURE [NOTIF].[stpCreateNotification];
GO
CREATE PROCEDURE [NOTIF].[stpCreateNotification]
(
    @UserID    smallint,
    @CompanyID smallint,
    @Type      nvarchar(20),
    @EntityID  int,
    @AssetID   int,
    @Message   nvarchar(500)
)
AS
    SET NOCOUNT OFF;
    INSERT INTO NOTIF.Notifications(UserID, CompanyID, Type, EntityID, AssetID, Message)
    VALUES (@UserID, @CompanyID, @Type, @EntityID, @AssetID, @Message);
    SELECT CAST(SCOPE_IDENTITY() AS int) AS NotifID;
GO

-- 7. stpGetNotifications
IF OBJECT_ID('NOTIF.stpGetNotifications') IS NOT NULL
    DROP PROCEDURE [NOTIF].[stpGetNotifications];
GO
CREATE PROCEDURE [NOTIF].[stpGetNotifications]
(
    @UserID smallint
)
AS
    SET NOCOUNT ON;
    SELECT TOP 50
        NotifID, UserID, CompanyID, Type, EntityID, AssetID, Message, IsRead, CreatedAt
    FROM  NOTIF.Notifications
    WHERE UserID = @UserID
    ORDER BY CreatedAt DESC;
GO

-- 8. stpMarkNotificationRead
IF OBJECT_ID('NOTIF.stpMarkNotificationRead') IS NOT NULL
    DROP PROCEDURE [NOTIF].[stpMarkNotificationRead];
GO
CREATE PROCEDURE [NOTIF].[stpMarkNotificationRead]
(
    @NotifID int,
    @UserID  smallint
)
AS
    UPDATE NOTIF.Notifications
    SET    IsRead = 1
    WHERE  NotifID = @NotifID AND UserID = @UserID;
GO

-- 9. stpMarkAllNotificationsRead
IF OBJECT_ID('NOTIF.stpMarkAllNotificationsRead') IS NOT NULL
    DROP PROCEDURE [NOTIF].[stpMarkAllNotificationsRead];
GO
CREATE PROCEDURE [NOTIF].[stpMarkAllNotificationsRead]
(
    @UserID smallint
)
AS
    UPDATE NOTIF.Notifications
    SET    IsRead = 1
    WHERE  UserID = @UserID AND IsRead = 0;
GO

-- 10. stpLogNotification (idempotent — ignores duplicate key)
IF OBJECT_ID('NOTIF.stpLogNotification') IS NOT NULL
    DROP PROCEDURE [NOTIF].[stpLogNotification];
GO
CREATE PROCEDURE [NOTIF].[stpLogNotification]
(
    @Type          nvarchar(20),
    @EntityID      int,
    @IntervalLabel nvarchar(30)
)
AS
    IF NOT EXISTS (
        SELECT 1 FROM NOTIF.NotificationLogs
        WHERE Type = @Type AND EntityID = @EntityID AND IntervalLabel = @IntervalLabel
    )
        INSERT INTO NOTIF.NotificationLogs(Type, EntityID, IntervalLabel)
        VALUES (@Type, @EntityID, @IntervalLabel);
GO
