namespace AssetManagement.Api.Models;

public class WarrantyDto
{
    public int WarntID { get; set; }
    public int AssetID { get; set; }
    public string WarrantyDesc { get; set; } = string.Empty;
    public DateOnly FromDate { get; set; }
    public DateOnly ToDate { get; set; }
    public string? Remark { get; set; }
}

public class WarrantyCreateRequest
{
    public int AssetID { get; set; }
    public string WarrantyDesc { get; set; } = string.Empty;
    public DateOnly FromDate { get; set; }
    public DateOnly ToDate { get; set; }
    public string? Remark { get; set; }
}

public class WarrantyUpdateRequest : WarrantyCreateRequest
{
    public int WarntID { get; set; }
}
