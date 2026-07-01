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
    @BrandID smallint,
    @Model nvarchar(50),
    @Remark nvarchar(100),
    @InstalledAt nvarchar(50),
    @OwnerID tinyint,
    @OwnerDesc nvarchar(50)
)
AS
BEGIN
    SET NOCOUNT OFF;

    IF NULLIF(LTRIM(RTRIM(@Model)), N'') IS NULL
        THROW 50001, 'Model is required.', 1;

    IF EXISTS (SELECT 1 FROM ATSET.OwnerTypes WHERE OwnerID = @OwnerID AND OwnerDesc <> N'Company')
       AND NULLIF(LTRIM(RTRIM(@OwnerDesc)), N'') IS NULL
        THROW 50002, 'Owner description is required when the asset is not company-owned.', 1;

    INSERT INTO [AT].[Assets]
    (
        [CompanyID], [AssetCode], [AssetImage], [AssetDesc], [LocationID], [LocDetailID],
        [GroupID], [CategoryID], [Donation], [ContactID], [PurchaseOrderNo], [PurchaseDate],
        [PurchasePrice], [PurchaseCurCode], [InServiceDate], [InvoiceNo], [InvoiceDate],
        [AccountingEntryDate], [AccountingEntryJVNo], [BarcodeNumber], [SerialNumber],
        [BrandID], [Model], [StatusID], [Remark], [InstalledAt], [OwnerID], [OwnerInfo]
    )
    VALUES
    (
        @CompanyID, @AssetCode, @AssetImage, @AssetDesc, @LocationID, @LocDetailID,
        @GroupID, @CategoryID, @Donation, @ContactID, @PurchaseOrderNo, @PurchaseDate,
        @PurchasePrice, @PurchaseCurCode, @InServiceDate, @InvoiceNo, @InvoiceDate,
        @AccountingEntryDate, @AccountingEntryJVNo, @BarcodeNumber, @SerialNumber,
        @BrandID, LTRIM(RTRIM(@Model)), 0, @Remark, @InstalledAt, @OwnerID,
        CASE WHEN EXISTS (SELECT 1 FROM ATSET.OwnerTypes WHERE OwnerID = @OwnerID AND OwnerDesc = N'Company')
            THEN NULL ELSE NULLIF(LTRIM(RTRIM(@OwnerDesc)), N'') END
    );

    SELECT SCOPE_IDENTITY();
END
GO
