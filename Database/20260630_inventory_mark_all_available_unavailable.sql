/*
  Add support for bulk mark available/unavailable in active inventory session.
  Date: 2026-06-30

  Change:
  - AT.stpInventoryIsAvailableAllAssets now accepts @IsAvailable bit
    and updates IsAvailable using the provided value.
*/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

ALTER PROCEDURE [AT].[stpInventoryIsAvailableAllAssets]
(
    @InventoryID int,
    @IsAvailable bit
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE AT.InventoriesDetails
    SET IsAvailable = @IsAvailable
    WHERE InventoryID = @InventoryID;

    SELECT @@ROWCOUNT;
END;
GO
