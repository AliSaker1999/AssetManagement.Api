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
}
