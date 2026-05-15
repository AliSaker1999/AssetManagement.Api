namespace AssetManagement.Api.Models;

public class MaintenanceDto
{
    public int MaintID { get; set; }
    public int AssetID { get; set; }
    public DateOnly FromDate { get; set; }
    public DateOnly ToDate { get; set; }
    public int SupplierContactID { get; set; }
    public double Cost { get; set; }
    public string CurCode { get; set; } = string.Empty;
    public string? Remark { get; set; }
}

public class MaintenanceCreateRequest
{
    public int AssetID { get; set; }
    public DateOnly FromDate { get; set; }
    public DateOnly ToDate { get; set; }
    public int SupplierContactID { get; set; }
    public double Cost { get; set; }
    public string CurCode { get; set; } = string.Empty;
    public string? Remark { get; set; }
}

public class MaintenanceUpdateRequest : MaintenanceCreateRequest
{
    public int MaintID { get; set; }
    public int Original_MaintID { get; set; }
    public int Original_AssetID { get; set; }
    public DateOnly Original_FromDate { get; set; }
    public DateOnly Original_ToDate { get; set; }
    public int Original_SupplierContactID { get; set; }
    public double Original_Cost { get; set; }
    public string Original_CurCode { get; set; } = string.Empty;
    public int IsNull_Remark { get; set; }
    public string? Original_Remark { get; set; }
}

public class MaintenanceDeleteRequest
{
    public int MaintID { get; set; }
    public int AssetID { get; set; }
    public DateOnly FromDate { get; set; }
    public DateOnly ToDate { get; set; }
    public int SupplierContactID { get; set; }
    public double Cost { get; set; }
    public string CurCode { get; set; } = string.Empty;
    public string? Remark { get; set; }
}
