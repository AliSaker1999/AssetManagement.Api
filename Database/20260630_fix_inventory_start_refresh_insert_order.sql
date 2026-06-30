/*
  Fix inventory asset population during start/refresh.
  Problem:
  - Procedures were updating AT.Assets.StatusID = 10 before inserting into AT.InventoriesDetails.
  - Insert query filters StatusID = 0, which resulted in 0 inserted rows.

  Result after fix:
  - Insert into AT.InventoriesDetails first (from active assets StatusID = 0).
  - Then mark those inserted assets as StatusID = 10 (Under Inventory).
*/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

ALTER PROCEDURE [AT].[stpProInventoryStart]
(
    @InventoryStartDate date,
    @StartCreatedByUserID smallint,
    @StartCreatedByFullName nvarchar(100),
    @StartCreatedByDateTime datetime,
    @Remark nvarchar(100),
    @CompanyID smallint
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InventoryID int;

    INSERT INTO AT.Inventories
    (
        InventoryStartDate,
        Remark,
        CompanyID,
        StartCreatedByUserID,
        StartCreatedByFullName,
        StartCreatedByDateTime
    )
    VALUES
    (
        @InventoryStartDate,
        @Remark,
        @CompanyID,
        @StartCreatedByUserID,
        @StartCreatedByFullName,
        @StartCreatedByDateTime
    );

    SET @InventoryID = SCOPE_IDENTITY();

    INSERT INTO AT.InventoriesDetails
    (
        InventoryID,
        AssetID,
        IsAvailable,
        AssetCode,
        AssetDesc,
        Relocated,
        RelocatedLocationID,
        RelocatedLocDetailID,
        CompanyID,
        LocationID,
        LocDetailID,
        GroupID,
        CategoryID,
        BarcodeNumber,
        SerialNumber,
        Remark
    )
    SELECT
        @InventoryID,
        AssetID,
        0,
        AssetCode,
        AssetDesc,
        0,
        NULL,
        NULL,
        CompanyID,
        LocationID,
        LocDetailID,
        GroupID,
        CategoryID,
        BarcodeNumber,
        SerialNumber,
        NULL
    FROM AT.Assets
    WHERE StatusID = 0
      AND CompanyID = @CompanyID;

    UPDATE Ast
    SET Ast.StatusID = 10
    FROM AT.Assets Ast
    INNER JOIN AT.InventoriesDetails InvD ON InvD.AssetID = Ast.AssetID
    WHERE InvD.InventoryID = @InventoryID
      AND Ast.StatusID = 0;

    SELECT @@ROWCOUNT;
END;
GO

ALTER PROCEDURE [AT].[stpProInventoryStartRefresh]
(
    @InventoryID int
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AT.InventoriesDetails
    (
        InventoryID,
        AssetID,
        IsAvailable,
        AssetCode,
        AssetDesc,
        Relocated,
        RelocatedLocationID,
        RelocatedLocDetailID,
        CompanyID,
        LocationID,
        LocDetailID,
        GroupID,
        CategoryID,
        BarcodeNumber,
        SerialNumber,
        Remark
    )
    SELECT
        @InventoryID,
        AssetID,
        0,
        AssetCode,
        AssetDesc,
        0,
        NULL,
        NULL,
        CompanyID,
        LocationID,
        LocDetailID,
        GroupID,
        CategoryID,
        BarcodeNumber,
        SerialNumber,
        NULL
    FROM AT.Assets
    WHERE StatusID = 0
      AND CompanyID = (SELECT CompanyID FROM AT.Inventories WHERE InventoryID = @InventoryID)
      AND AssetID NOT IN (SELECT AssetID FROM AT.InventoriesDetails WHERE InventoryID = @InventoryID);

    UPDATE Ast
    SET Ast.StatusID = 10
    FROM AT.Assets Ast
    INNER JOIN AT.InventoriesDetails InvD ON InvD.AssetID = Ast.AssetID
    WHERE InvD.InventoryID = @InventoryID
      AND Ast.StatusID = 0;
END;
GO
