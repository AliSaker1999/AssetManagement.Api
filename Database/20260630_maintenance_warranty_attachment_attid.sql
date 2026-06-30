/*
  Add attachment linkage to Maintenance and Warranty using AT.Attachments.
  Date: 2026-06-30

  Changes:
  1) Add nullable AttID columns to AT.Maintenances and AT.Warranties.
  2) Add FK relations to AT.Attachments(AttID).
  3) Update AT maintenance/warranty stored procedures to include AttID in CRUD.
*/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

/* 1) Columns */
IF COL_LENGTH('AT.Maintenances', 'AttID') IS NULL
BEGIN
    ALTER TABLE [AT].[Maintenances] ADD [AttID] int NULL;
END
GO

IF COL_LENGTH('AT.Warranties', 'AttID') IS NULL
BEGIN
    ALTER TABLE [AT].[Warranties] ADD [AttID] int NULL;
END
GO

/* 2) Foreign keys */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Maintenances_Attachments' AND parent_object_id = OBJECT_ID('AT.Maintenances'))
BEGIN
    ALTER TABLE [AT].[Maintenances] WITH CHECK
    ADD CONSTRAINT [FK_Maintenances_Attachments]
    FOREIGN KEY([AttID]) REFERENCES [AT].[Attachments]([AttID]);

    ALTER TABLE [AT].[Maintenances] CHECK CONSTRAINT [FK_Maintenances_Attachments];
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Warranties_Attachments' AND parent_object_id = OBJECT_ID('AT.Warranties'))
BEGIN
    ALTER TABLE [AT].[Warranties] WITH CHECK
    ADD CONSTRAINT [FK_Warranties_Attachments]
    FOREIGN KEY([AttID]) REFERENCES [AT].[Attachments]([AttID]);

    ALTER TABLE [AT].[Warranties] CHECK CONSTRAINT [FK_Warranties_Attachments];
END
GO

/* 3) Procedures - Maintenance */
ALTER PROCEDURE [AT].[stpMaintenancesD]
(
    @Original_MaintID int,
    @Original_AssetID int,
    @IsNull_AttID Int,
    @Original_AttID int,
    @Original_FromDate date,
    @Original_ToDate date,
    @Original_SupplierContactID int,
    @Original_Cost float,
    @Original_CurCode char(3),
    @IsNull_Remark Int,
    @Original_Remark nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT OFF;

    DELETE FROM [AT].[Maintenances]
    WHERE ([MaintID] = @Original_MaintID)
      AND ([AssetID] = @Original_AssetID)
      AND ((@IsNull_AttID = 1 AND [AttID] IS NULL) OR ([AttID] = @Original_AttID))
      AND ([FromDate] = @Original_FromDate)
      AND ([ToDate] = @Original_ToDate)
      AND ([SupplierContactID] = @Original_SupplierContactID)
      AND ([Cost] = @Original_Cost)
      AND ([CurCode] = @Original_CurCode)
      AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark));
END
GO

ALTER PROCEDURE [AT].[stpMaintenancesI]
(
    @AssetID int,
    @AttID int,
    @FromDate date,
    @ToDate date,
    @SupplierContactID int,
    @Cost float,
    @CurCode char(3),
    @Remark nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO [AT].[Maintenances]
    (
        [AssetID], [AttID], [FromDate], [ToDate],
        [SupplierContactID], [Cost], [CurCode], [Remark]
    )
    VALUES
    (
        @AssetID, @AttID, @FromDate, @ToDate,
        @SupplierContactID, @Cost, @CurCode, @Remark
    );

    SELECT MaintID, AssetID, AttID, FromDate, ToDate, SupplierContactID, Cost, CurCode, Remark
    FROM AT.Maintenances
    WHERE MaintID = SCOPE_IDENTITY();
END
GO

ALTER PROCEDURE [AT].[stpMaintenancesS]
(
    @AssetId int
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT MaintID, AssetID, AttID, FromDate, ToDate, SupplierContactID, Cost, CurCode, Remark
    FROM AT.Maintenances
    WHERE AssetID = @AssetID;
END
GO

ALTER PROCEDURE [AT].[stpMaintenancesU]
(
    @AssetID int,
    @AttID int,
    @FromDate date,
    @ToDate date,
    @SupplierContactID int,
    @Cost float,
    @CurCode char(3),
    @Remark nvarchar(100),
    @Original_MaintID int,
    @Original_AssetID int,
    @IsNull_AttID Int,
    @Original_AttID int,
    @Original_FromDate date,
    @Original_ToDate date,
    @Original_SupplierContactID int,
    @Original_Cost float,
    @Original_CurCode char(3),
    @IsNull_Remark Int,
    @Original_Remark nvarchar(100),
    @MaintID int
)
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE [AT].[Maintenances]
    SET [AssetID] = @AssetID,
        [AttID] = @AttID,
        [FromDate] = @FromDate,
        [ToDate] = @ToDate,
        [SupplierContactID] = @SupplierContactID,
        [Cost] = @Cost,
        [CurCode] = @CurCode,
        [Remark] = @Remark
    WHERE ([MaintID] = @Original_MaintID)
      AND ([AssetID] = @Original_AssetID)
      AND ((@IsNull_AttID = 1 AND [AttID] IS NULL) OR ([AttID] = @Original_AttID))
      AND ([FromDate] = @Original_FromDate)
      AND ([ToDate] = @Original_ToDate)
      AND ([SupplierContactID] = @Original_SupplierContactID)
      AND ([Cost] = @Original_Cost)
      AND ([CurCode] = @Original_CurCode)
      AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark));

    SELECT MaintID, AssetID, AttID, FromDate, ToDate, SupplierContactID, Cost, CurCode, Remark
    FROM AT.Maintenances
    WHERE MaintID = @MaintID;
END
GO

/* 4) Procedures - Warranty */
ALTER PROCEDURE [AT].[stpWarrantiesD]
(
    @Original_WarntID int,
    @Original_AssetID int,
    @IsNull_AttID Int,
    @Original_AttID int,
    @Original_WarrantyDesc nvarchar(50),
    @Original_FromDate date,
    @Original_ToDate date,
    @IsNull_Remark Int,
    @Original_Remark nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT OFF;

    DELETE FROM [AT].[Warranties]
    WHERE ([WarntID] = @Original_WarntID)
      AND ([AssetID] = @Original_AssetID)
      AND ((@IsNull_AttID = 1 AND [AttID] IS NULL) OR ([AttID] = @Original_AttID))
      AND ([WarrantyDesc] = @Original_WarrantyDesc)
      AND ([FromDate] = @Original_FromDate)
      AND ([ToDate] = @Original_ToDate)
      AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark));
END
GO

ALTER PROCEDURE [AT].[stpWarrantiesI]
(
    @AssetID int,
    @AttID int,
    @WarrantyDesc nvarchar(50),
    @FromDate date,
    @ToDate date,
    @Remark nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO [AT].[Warranties]
    (
        [AssetID], [AttID], [WarrantyDesc], [FromDate], [ToDate], [Remark]
    )
    VALUES
    (
        @AssetID, @AttID, @WarrantyDesc, @FromDate, @ToDate, @Remark
    );

    SELECT WarntID, AssetID, AttID, WarrantyDesc, FromDate, ToDate, Remark
    FROM AT.Warranties
    WHERE WarntID = SCOPE_IDENTITY();
END
GO

ALTER PROCEDURE [AT].[stpWarrantiesS]
(
    @AssetId int
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT WarntID, AssetID, AttID, WarrantyDesc, FromDate, ToDate, Remark
    FROM AT.Warranties
    WHERE AssetID = @AssetID;
END
GO

ALTER PROCEDURE [AT].[stpWarrantiesU]
(
    @AssetID int,
    @AttID int,
    @WarrantyDesc nvarchar(50),
    @FromDate date,
    @ToDate date,
    @Remark nvarchar(100),
    @Original_WarntID int,
    @Original_AssetID int,
    @IsNull_AttID Int,
    @Original_AttID int,
    @Original_WarrantyDesc nvarchar(50),
    @Original_FromDate date,
    @Original_ToDate date,
    @IsNull_Remark Int,
    @Original_Remark nvarchar(100),
    @WarntID int
)
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE [AT].[Warranties]
    SET [AssetID] = @AssetID,
        [AttID] = @AttID,
        [WarrantyDesc] = @WarrantyDesc,
        [FromDate] = @FromDate,
        [ToDate] = @ToDate,
        [Remark] = @Remark
    WHERE ([WarntID] = @Original_WarntID)
      AND ([AssetID] = @Original_AssetID)
      AND ((@IsNull_AttID = 1 AND [AttID] IS NULL) OR ([AttID] = @Original_AttID))
      AND ([WarrantyDesc] = @Original_WarrantyDesc)
      AND ([FromDate] = @Original_FromDate)
      AND ([ToDate] = @Original_ToDate)
      AND ((@IsNull_Remark = 1 AND [Remark] IS NULL) OR ([Remark] = @Original_Remark));

    SELECT WarntID, AssetID, AttID, WarrantyDesc, FromDate, ToDate, Remark
    FROM AT.Warranties
    WHERE WarntID = @WarntID;
END
GO
