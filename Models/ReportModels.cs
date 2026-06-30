namespace AssetManagement.Api.Models;

// ── Request Models ───────────────────────────────────────────────────────────

public class AssetsListReportRequest
{
    public string Format { get; set; } = "pdf";          // pdf | excel
    public short LocationID { get; set; } = -1;
    public short CompanyID { get; set; } = -1;
    public short CategoryID { get; set; } = -1;
    public short GroupID { get; set; } = -1;
    public short LocationDetailID { get; set; } = -1;
    public bool AccountingExclusion { get; set; }
    public string ListType { get; set; } = "ALL";        // ALL | NotAvailable | Relocated
    public bool AdditionalDetail { get; set; } = true;
    public bool TotalOnly { get; set; }
}

public class AssetsListInventoryReportRequest
{
    public string Format { get; set; } = "pdf";
    public int InventoryID { get; set; }
    public short LocationID { get; set; } = -1;
    public short CompanyID { get; set; } = -1;
    public short CategoryID { get; set; } = -1;
    public short GroupID { get; set; } = -1;
    public short LocationDetailID { get; set; } = -1;
    public bool AccountingExclusion { get; set; }
    public string ListType { get; set; } = "ALL";        // ALL | NotAvailable | Relocated
    public bool TotalOnly { get; set; }
}

public class DepreciationReportGenerateRequest
{
    public string Format { get; set; } = "pdf";
    public int DepID { get; set; }
}

public class AssetsNotDepreciatedReportRequest
{
    public string Format { get; set; } = "pdf";
}

// ── Row DTOs ─────────────────────────────────────────────────────────────────

public class AssetsListReportRowDto
{
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

public class AssetsListInventoryReportRowDto
{
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public bool IsAvailable { get; set; }
    public bool Relocated { get; set; }
    public string? RelocatedLocation { get; set; }
    public string? RelocatedFloor { get; set; }
    public string? RelocatedZone { get; set; }
    public string? RelocatedRoom { get; set; }
    public string Location { get; set; } = string.Empty;
    public string? Floor { get; set; }
    public string? Zone { get; set; }
    public string? Room { get; set; }
    public string GroupName { get; set; } = string.Empty;
    public string? Remark { get; set; }
}

public class DepreciationReportGenerateRowDto
{
    public int DepID { get; set; }
    public DateOnly DepreciationDate { get; set; }
    public string? Remark { get; set; }
    public string CreatedByFullName { get; set; } = string.Empty;
    public DateTime CreatedByDateTime { get; set; }
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public byte DepreciationRate { get; set; }
    public double DepreciationValue { get; set; }
    public double NetBookValue { get; set; }
    public DateOnly? AccountingEntryDate { get; set; }
    public string? AccountingEntryJVNo { get; set; }
}

public class AssetsNotDepreciatedReportRowDto
{
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public bool Donation { get; set; }
    public string PriceExist { get; set; } = string.Empty;
    public string AcctEntryDateExist { get; set; } = string.Empty;
    public string Location { get; set; } = string.Empty;
    public string? Floor { get; set; }
    public string? Zone { get; set; }
    public string? Room { get; set; }
    public string GroupName { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
}

public class ReportPreviewDto
{
    public string Title { get; set; } = string.Empty;
    public string Subtitle { get; set; } = string.Empty;
    public string[] Headers { get; set; } = [];
    public List<string?[]> Rows { get; set; } = [];
    public int TotalCount { get; set; }
}
