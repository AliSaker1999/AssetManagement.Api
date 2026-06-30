namespace AssetManagement.Api.Models;

public class PaginationRequest
{
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 25;
}

public class PaginatedResponse<T>
{
    public List<T> Data { get; set; } = [];
    public int PageNumber { get; set; }
    public int PageSize { get; set; }
    public int TotalCount { get; set; }
    public int TotalPages => (TotalCount + PageSize - 1) / PageSize;
    public bool HasPreviousPage => PageNumber > 1;
    public bool HasNextPage => PageNumber < TotalPages;
}

public class AssetDto
{
    public int AssetID { get; set; }
    public short CompanyID { get; set; }
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public short LocationID { get; set; }
    public short LocDetailID { get; set; }
    public short GroupID { get; set; }
    public short CategoryID { get; set; }
    public bool Donation { get; set; }
    public int? ContactID { get; set; }
    public string? PurchaseOrderNo { get; set; }
    public DateOnly? PurchaseDate { get; set; }
    public double PurchasePrice { get; set; }
    public string PurchaseCurCode { get; set; } = string.Empty;
    public DateOnly InServiceDate { get; set; }
    public string? InvoiceNo { get; set; }
    public DateOnly? InvoiceDate { get; set; }
    public DateOnly? AccountingEntryDate { get; set; }
    public string? AccountingEntryJVNo { get; set; }
    public string? BarcodeNumber { get; set; }
    public string? SerialNumber { get; set; }
    public byte? StatusID { get; set; }
    public string? StatusName { get; set; }
    public DateOnly? StatusDate { get; set; }
    public string? Remark { get; set; }
    public string? InstalledAt { get; set; }
}

public class AssetListItemDto
{
    public int AssetID { get; set; }
    public short CompanyID { get; set; }
    public string CompanyAbbreviation { get; set; } = string.Empty;
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
    public string Location { get; set; } = string.Empty;
    public string? Floor { get; set; }
    public string? Room { get; set; }
    public string? Zone { get; set; }
    public byte? StatusID { get; set; }
    public string? Status { get; set; }
    public string? BarcodeNumber { get; set; }
    public string? SerialNumber { get; set; }
    public string? PurchaseOrderNo { get; set; }
    public string? InvoiceNo { get; set; }
}

public class AssetReportItemDto
{
    public int AssetID { get; set; }
    public string CompanyAbbreviation { get; set; } = string.Empty;
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
    public string GroupName { get; set; } = string.Empty;
    public string Location { get; set; } = string.Empty;
    public string? Floor { get; set; }
    public string? Room { get; set; }
    public string? Zone { get; set; }
    public DateOnly InServiceDate { get; set; }
    public string? Status { get; set; }
    public DateOnly? StatusDate { get; set; }
    public DateOnly? LastInventoryDateByItem { get; set; }
    public string? BarcodeNumber { get; set; }
    public string? SerialNumber { get; set; }
}

public class AssetCreateRequest
{
    public short CompanyID { get; set; }
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public short LocationID { get; set; }
    public short LocDetailID { get; set; }
    public short GroupID { get; set; }
    public short CategoryID { get; set; }
    public bool Donation { get; set; }
    public int? ContactID { get; set; }
    public string? PurchaseOrderNo { get; set; }
    public DateOnly? PurchaseDate { get; set; }
    public double PurchasePrice { get; set; }
    public string PurchaseCurCode { get; set; } = string.Empty;
    public DateOnly InServiceDate { get; set; }
    public string? InvoiceNo { get; set; }
    public DateOnly? InvoiceDate { get; set; }
    public DateOnly? AccountingEntryDate { get; set; }
    public string? AccountingEntryJVNo { get; set; }
    public string? BarcodeNumber { get; set; }
    public string? SerialNumber { get; set; }
    public string? Remark { get; set; }
    public string? InstalledAt { get; set; }
}

public class AssetUpdateRequest : AssetCreateRequest
{
    public int AssetID { get; set; }
}

public class AssetStatusUpdateRequest
{
    public byte AssetStatusID { get; set; }
    public DateOnly AssetStatusDate { get; set; }
    public byte StatusID { get; set; }
    public DateOnly StatusDate { get; set; }
    public int? StatusContactID { get; set; }
    public double StatusSalePrice { get; set; }
    public string? StatusSaleCurCode { get; set; }
    public string? StatusDesc { get; set; }
}

public class AssetStatusRemoveRequest
{
    public byte StatusID { get; set; }
    public DateOnly StatusDate { get; set; }
    public int? StatusContactID { get; set; }
    public double StatusSalePrice { get; set; }
    public string? StatusSaleCurCode { get; set; }
    public string? StatusDesc { get; set; }
}

public class AssetDepreciationHistoryDto
{
    public int DepDetailID { get; set; }
    public DateOnly DepreciationDate { get; set; }
    public byte DepreciationRate { get; set; }
    public double DepreciationValue { get; set; }
    public double NetBookValue { get; set; }
    public string GroupName { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
    public double PurchasePrice { get; set; }
    public string PurchaseCurCode { get; set; } = string.Empty;
    public DateOnly? AccountingEntryDate { get; set; }
    public string? AccountingEntryJVNo { get; set; }
    public string CreatedByFullName { get; set; } = string.Empty;
    public DateTime CreatedByDateTime { get; set; }
}

public class AssetInventoryHistoryDto
{
    public int InvDetailID { get; set; }
    public int InventoryID { get; set; }
    public int AssetID { get; set; }
    public bool IsAvailable { get; set; }
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public bool Relocated { get; set; }
    public string? RelocatedLocation { get; set; }
    public string? RelocatedFloor { get; set; }
    public string? RelocatedZone { get; set; }
    public string? RelocatedRoom { get; set; }
    public string? BarcodeNumber { get; set; }
    public string? SerialNumber { get; set; }
    public string? Remark { get; set; }
    public DateOnly CreatedDate { get; set; }
    public string CompanyAbbreviation { get; set; } = string.Empty;
    public string Location { get; set; } = string.Empty;
    public string? Floor { get; set; }
    public string? Zone { get; set; }
    public string? Room { get; set; }
    public string GroupName { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
}

public class AssetReportFilterRequest
{
    public short LocationID { get; set; } = -1;
    public short CompanyID { get; set; } = -1;
    public short CategoryID { get; set; } = -1;
    public short GroupID { get; set; } = -1;
    public short LocationDetailID { get; set; } = -1;
    public bool AccountingExclusion { get; set; }
}

public class AssetNotDepreciatedDto
{
    public int AssetID { get; set; }
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public bool Donation { get; set; }
    public string PriceExist { get; set; } = string.Empty;
    public string AcctEntryDateExist { get; set; } = string.Empty;
    public short GroupID { get; set; }
    public string Location { get; set; } = string.Empty;
    public string? Floor { get; set; }
    public string? Zone { get; set; }
    public string? Room { get; set; }
    public string GroupName { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
}

public class StatusHistoryDto
{
    public int StatusHistID { get; set; }
    public int AssetID { get; set; }
    public byte StatusID { get; set; }
    public string? StatusName { get; set; }
    public DateOnly StatusDate { get; set; }
    public string? StatusDesc { get; set; }
    public int? StatusContactID { get; set; }
    public string? ContactName { get; set; }
    public double StatusSalePrice { get; set; }
    public string? StatusSaleCurCode { get; set; }
    public short CreatedByUserID { get; set; }
    public string CreatedByFullName { get; set; } = string.Empty;
    public DateTime CreatedByDateTime { get; set; }
}
