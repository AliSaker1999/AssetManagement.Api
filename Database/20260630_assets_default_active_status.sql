USE [Assets]
GO

/*
  Ensure newly created assets always start as Active (StatusID = 0).
  Safe to run multiple times.
*/

CREATE OR ALTER PROCEDURE [AT].[stpAssetsI]
(
    @CompanyID smallint,
    @AssetCode nvarchar(15),
    @AssetImage image,
    @AssetDesc nvarchar(50),
    @LocationID smallint,
    @LocDetailID smallint,
    @GroupID smallint,
    @CategoryID smallint,
    @Donation bit,
    @ContactID int,
    @PurchaseOrderNo nvarchar(10),
    @PurchaseDate date,
    @PurchasePrice float,
    @PurchaseCurCode char(3),
    @InServiceDate date,
    @InvoiceNo nvarchar(10),
    @InvoiceDate date,
    @AccountingEntryDate date,
    @AccountingEntryJVNo nvarchar(10),
    @BarcodeNumber nvarchar(20),
    @SerialNumber nvarchar(50),
    @Remark nvarchar(100),
    @InstalledAt nvarchar(50)
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO [AT].[Assets]
    (
        [CompanyID], [AssetCode], [AssetImage], [AssetDesc], [LocationID], [LocDetailID],
        [GroupID], [CategoryID], [Donation], [ContactID], [PurchaseOrderNo], [PurchaseDate],
        [PurchasePrice], [PurchaseCurCode], [InServiceDate], [InvoiceNo], [InvoiceDate],
        [AccountingEntryDate], [AccountingEntryJVNo], [BarcodeNumber], [SerialNumber],
        [BrandID], [Model], [StatusID], [Remark], [InstalledAt], [OwnerID]
    )
    VALUES
    (
        @CompanyID, @AssetCode, @AssetImage, @AssetDesc, @LocationID, @LocDetailID,
        @GroupID, @CategoryID, @Donation, @ContactID, @PurchaseOrderNo, @PurchaseDate,
        @PurchasePrice, @PurchaseCurCode, @InServiceDate, @InvoiceNo, @InvoiceDate,
        @AccountingEntryDate, @AccountingEntryJVNo, @BarcodeNumber, @SerialNumber,
        1, N'', 0, @Remark, @InstalledAt, 1
    );

    SELECT SCOPE_IDENTITY();
END
GO
