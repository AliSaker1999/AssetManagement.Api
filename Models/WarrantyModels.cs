namespace AssetManagement.Api.Models;

public class WarrantyDto
{
    public int WarntID { get; set; }
    public int AssetID { get; set; }
    public int? AttID { get; set; }
    public string WarrantyDesc { get; set; } = string.Empty;
    public DateOnly FromDate { get; set; }
    public DateOnly ToDate { get; set; }
    public string? Remark { get; set; }
}

public class WarrantyCreateRequest
{
    public int AssetID { get; set; }
    public int? AttID { get; set; }
    public string WarrantyDesc { get; set; } = string.Empty;
    public DateOnly FromDate { get; set; }
    public DateOnly ToDate { get; set; }
    public string? Remark { get; set; }
}

public class WarrantyUpdateRequest : WarrantyCreateRequest
{
    public int WarntID { get; set; }
    public int Original_WarntID { get; set; }
    public int Original_AssetID { get; set; }
    public int IsNull_AttID { get; set; }
    public int? Original_AttID { get; set; }
    public string Original_WarrantyDesc { get; set; } = string.Empty;
    public DateOnly Original_FromDate { get; set; }
    public DateOnly Original_ToDate { get; set; }
    public int IsNull_Remark { get; set; }
    public string? Original_Remark { get; set; }
}

public class WarrantyDeleteRequest
{
    public int WarntID { get; set; }
    public int AssetID { get; set; }
    public int? AttID { get; set; }
    public string WarrantyDesc { get; set; } = string.Empty;
    public DateOnly FromDate { get; set; }
    public DateOnly ToDate { get; set; }
    public string? Remark { get; set; }
}
