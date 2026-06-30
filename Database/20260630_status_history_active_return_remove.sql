/*
  Migration: Return From Maintenance + Status Removed keep current asset status Active.
  Date: 2026-06-30

  Behavior after this script:
  1) Return From Maintenance should still insert StatusID = 9 into AT.StatusHistory,
     but AT.Assets.StatusID becomes 0 (Active).
  2) Remove Status should still insert StatusID = 5 into AT.StatusHistory,
     but AT.Assets.StatusID becomes 0 (Active).
*/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

/* Recreate AT.stpAssetsStatusRemove */
ALTER PROCEDURE [AT].[stpAssetsStatusRemove]
(
    @StatusID tinyint,
    @StatusDate date,
    @StatusContactID int,
    @StatusSalePrice float,
    @StatusSaleCurCode char(3),
    @StatusDesc nvarchar(50),
    @CreatedByUserID smallint,
    @CreatedByFullName nvarchar(100),
    @CreatedByDateTime datetime,
    @AssetID int
)
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE [AT].[Assets]
    SET [StatusID] = 0,
        [StatusDate] = @StatusDate
    WHERE [AssetID] = @AssetID;

    INSERT INTO [AT].[StatusHistory]
    (
        AssetID,
        StatusID,
        StatusDate,
        StatusDesc,
        [StatusContactID],
        [StatusSalePrice],
        [StatusSaleCurCode],
        CreatedByUserID,
        CreatedByFullName,
        CreatedByDateTime
    )
    VALUES
    (
        @AssetID,
        @StatusID,
        @StatusDate,
        @StatusDesc,
        @StatusContactID,
        @StatusSalePrice,
        @StatusSaleCurCode,
        @CreatedByUserID,
        @CreatedByFullName,
        @CreatedByDateTime
    );
END;
GO

/* Recreate AT.stpAssetsStatusU with return-from-maintenance rule */
ALTER PROCEDURE [AT].[stpAssetsStatusU]
(
    @AssetStatusID tinyint,
    @AssetStatusDate date,
    @StatusID tinyint,
    @StatusDate date,
    @StatusContactID int,
    @StatusSalePrice float,
    @StatusSaleCurCode char(3),
    @StatusDesc nvarchar(50),
    @CreatedByUserID smallint,
    @CreatedByFullName nvarchar(100),
    @CreatedByDateTime datetime,
    @AssetID int
)
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE [AT].[Assets]
    SET [StatusID] = CASE WHEN @StatusID = 9 THEN 0 ELSE @AssetStatusID END,
        [StatusDate] = @AssetStatusDate
    WHERE [AssetID] = @AssetID;

    INSERT INTO [AT].[StatusHistory]
    (
        AssetID,
        StatusID,
        StatusDate,
        StatusDesc,
        [StatusContactID],
        [StatusSalePrice],
        [StatusSaleCurCode],
        CreatedByUserID,
        CreatedByFullName,
        CreatedByDateTime
    )
    VALUES
    (
        @AssetID,
        @StatusID,
        @StatusDate,
        @StatusDesc,
        @StatusContactID,
        @StatusSalePrice,
        @StatusSaleCurCode,
        @CreatedByUserID,
        @CreatedByFullName,
        @CreatedByDateTime
    );
END;
GO
