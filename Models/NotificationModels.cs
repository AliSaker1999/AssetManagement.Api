namespace AssetManagement.Api.Models;

public class NotificationDto
{
    public int NotifID { get; set; }
    public short UserID { get; set; }
    public short CompanyID { get; set; }
    public string Type { get; set; } = string.Empty;
    public int EntityID { get; set; }
    public int AssetID { get; set; }
    public string Message { get; set; } = string.Empty;
    public bool IsRead { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class PendingWarrantyNotif
{
    public int WarntID { get; set; }
    public int AssetID { get; set; }
    public string WarrantyDesc { get; set; } = string.Empty;
    public DateOnly ToDate { get; set; }
    public short CompanyID { get; set; }
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public string? EmailNotification { get; set; }
    public short? UserNotification { get; set; }
    public int DaysLeft { get; set; }
}

public class PendingMaintenanceNotif
{
    public int MaintID { get; set; }
    public int AssetID { get; set; }
    public DateOnly FromDate { get; set; }
    public DateOnly ToDate { get; set; }
    public short CompanyID { get; set; }
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public byte? StatusID { get; set; }
    public string? EmailNotification { get; set; }
    public short? UserNotification { get; set; }
    public int DaysLeft { get; set; }
}
