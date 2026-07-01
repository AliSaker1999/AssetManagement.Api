USE [Assets]
GO

/*
  Add support for asset BrandID, Model, OwnerID, and OwnerDesc/OwnerInfo
  across asset procedures and expose brand/owner lookup procedures.
  Safe to run multiple times.
*/

CREATE OR ALTER PROCEDURE [ATSET].[stpGetBrandTypes]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT BrandID, BrandDesc
    FROM ATSET.BrandTypes
    ORDER BY BrandDesc;
END
GO

CREATE OR ALTER PROCEDURE [ATSET].[stpBrandTypesI]
(
    @BrandDesc nvarchar(50)
)
AS
BEGIN
    SET NOCOUNT OFF;

    INSERT INTO ATSET.BrandTypes (BrandDesc)
    VALUES (LTRIM(RTRIM(@BrandDesc)));

    SELECT BrandID, BrandDesc
    FROM ATSET.BrandTypes
    WHERE BrandID = SCOPE_IDENTITY();
END
GO

CREATE OR ALTER PROCEDURE [ATSET].[stpGetOwnerTypes]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT OwnerID, OwnerDesc
    FROM ATSET.OwnerTypes
    ORDER BY OwnerDesc;
END
GO

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

CREATE OR ALTER PROCEDURE [AT].[stpAssetsS]
(
    @AssetID int
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT      a.AssetID, a.CompanyID, a.AssetCode, a.AssetDesc, a.LocationID, a.LocDetailID,
                a.GroupID, a.CategoryID, a.Donation, a.ContactID, a.PurchaseOrderNo, a.PurchaseDate,
                a.PurchasePrice, a.PurchaseCurCode, a.InServiceDate, a.InvoiceNo, a.InvoiceDate,
                a.AccountingEntryDate, a.AccountingEntryJVNo, a.BarcodeNumber, a.SerialNumber,
                a.BrandID, a.Model, a.StatusID, st.Status AS StatusName, bt.BrandDesc,
                a.StatusDate, a.Remark, a.InstalledAt, a.OwnerID, a.OwnerInfo AS OwnerDesc,
                ot.OwnerDesc AS OwnerTypeDesc
    FROM AT.Assets a
    LEFT OUTER JOIN ATSET.StatusTypes st ON a.StatusID = st.StatusID
    LEFT OUTER JOIN ATSET.BrandTypes bt ON a.BrandID = bt.BrandID
    LEFT OUTER JOIN ATSET.OwnerTypes ot ON a.OwnerID = ot.OwnerID
    WHERE a.AssetID = @AssetID;
END
GO

CREATE OR ALTER PROCEDURE [AT].[stpAssetsU]
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
    @OwnerDesc nvarchar(50),
    @AssetID int
)
AS
BEGIN
    SET NOCOUNT OFF;

    IF NULLIF(LTRIM(RTRIM(@Model)), N'') IS NULL
        THROW 50001, 'Model is required.', 1;

    IF EXISTS (SELECT 1 FROM ATSET.OwnerTypes WHERE OwnerID = @OwnerID AND OwnerDesc <> N'Company')
       AND NULLIF(LTRIM(RTRIM(@OwnerDesc)), N'') IS NULL
        THROW 50002, 'Owner description is required when the asset is not company-owned.', 1;

    UPDATE [AT].[Assets]
    SET [CompanyID] = @CompanyID,
        [AssetCode] = @AssetCode,
        [AssetImage] = @AssetImage,
        [AssetDesc] = @AssetDesc,
        [LocationID] = @LocationID,
        [LocDetailID] = @LocDetailID,
        [GroupID] = @GroupID,
        [CategoryID] = @CategoryID,
        [Donation] = @Donation,
        [ContactID] = @ContactID,
        [PurchaseOrderNo] = @PurchaseOrderNo,
        [PurchaseDate] = @PurchaseDate,
        [PurchasePrice] = @PurchasePrice,
        [PurchaseCurCode] = @PurchaseCurCode,
        [InServiceDate] = @InServiceDate,
        [InvoiceNo] = @InvoiceNo,
        [InvoiceDate] = @InvoiceDate,
        [AccountingEntryDate] = @AccountingEntryDate,
        [AccountingEntryJVNo] = @AccountingEntryJVNo,
        [BarcodeNumber] = @BarcodeNumber,
        [SerialNumber] = @SerialNumber,
        [BrandID] = @BrandID,
        [Model] = LTRIM(RTRIM(@Model)),
        [Remark] = @Remark,
        [InstalledAt] = @InstalledAt,
        [OwnerID] = @OwnerID,
        [OwnerInfo] = CASE WHEN EXISTS (SELECT 1 FROM ATSET.OwnerTypes WHERE OwnerID = @OwnerID AND OwnerDesc = N'Company')
            THEN NULL ELSE NULLIF(LTRIM(RTRIM(@OwnerDesc)), N'') END
    WHERE [AssetID] = @AssetID;
END
GO