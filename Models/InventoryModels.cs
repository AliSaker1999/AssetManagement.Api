namespace AssetManagement.Api.Models;

public class InventoryDto
{
    public int InventoryID { get; set; }
    public short CompanyID { get; set; }
    public DateOnly InventoryStartDate { get; set; }
    public DateOnly? InventoryEndDate { get; set; }
    public string? Remark { get; set; }
    public short StartCreatedByUserID { get; set; }
    public string StartCreatedByFullName { get; set; } = string.Empty;
    public DateTime StartCreatedByDateTime { get; set; }
    public short? EndCreatedByUserID { get; set; }
    public string? EndCreatedByFullName { get; set; }
    public DateTime? EndCreatedByDateTime { get; set; }
}

public class InventoryModeDto
{
    public int? InventoryID { get; set; }
    public bool IsActive { get; set; }
}

public class InventoryInfoDto
{
    public int InventoryID { get; set; }
    public DateOnly InventoryStartDate { get; set; }
    public string StartCreatedByFullName { get; set; } = string.Empty;
}

public class InventoryFinishInfoDto
{
    public int InventoryID { get; set; }
    public DateOnly? InventoryEndDate { get; set; }
    public string? EndCreatedByFullName { get; set; }
}

public class InventoryDetailDto
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
    public string Location { get; set; } = string.Empty;
    public string? Floor { get; set; }
    public string? Zone { get; set; }
    public string? Room { get; set; }
    public short LocationID { get; set; }
    public string GroupName { get; set; } = string.Empty;
    public string? Remark { get; set; }
}

public class InventoryStartRequest
{
    public DateOnly InventoryStartDate { get; set; }
    public short CompanyID { get; set; }
    public string? Remark { get; set; }
}

public class InventoryEndRequest
{
    public DateOnly InventoryEndDate { get; set; }
}

public class InventoryAvailableRequest
{
    public int InvDetailID { get; set; }
    public bool IsAvailable { get; set; }
}

public class InventoryRelocateRequest
{
    public int InvDetailID { get; set; }
    public short RelocatedLocationID { get; set; }
    public short RelocatedLocDetailID { get; set; }
}

public class InventoryGeneratedItemDto
{
    public int AssetID { get; set; }
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public short LocationID { get; set; }
    public short LocDetailID { get; set; }
    public short GroupID { get; set; }
    public short CategoryID { get; set; }
    public short CompanyID { get; set; }
    public string? BarcodeNumber { get; set; }
    public string? SerialNumber { get; set; }
}

public class InventoryListItemDto
{
    public int InventoryID { get; set; }
    public short CompanyID { get; set; }
    public DateOnly InventoryStartDate { get; set; }
    public DateOnly? InventoryEndDate { get; set; }
    public string? Remark { get; set; }
    public string StartCreatedByFullName { get; set; } = string.Empty;
    public DateTime StartCreatedByDateTime { get; set; }
    public string? EndCreatedByFullName { get; set; }
    public DateTime? EndCreatedByDateTime { get; set; }
    public int TotalAssets { get; set; }
    public int FoundAssets { get; set; }
    public int RelocatedAssets { get; set; }
}

public class InventoryReportFilterRequest
{
    public int InventoryID { get; set; }
    public short LocationID { get; set; } = -1;
    public short CompanyID { get; set; } = -1;
    public short CategoryID { get; set; } = -1;
    public short GroupID { get; set; } = -1;
    public short LocationDetailID { get; set; } = -1;
    public bool AccountingExclusion { get; set; }
}
