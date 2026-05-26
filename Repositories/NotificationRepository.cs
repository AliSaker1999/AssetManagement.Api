using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface INotificationRepository
{
    Task<int> CreateAsync(short userId, short companyId, string type, int entityId, int assetId, string message);
    Task<IEnumerable<NotificationDto>> GetForUserAsync(short userId);
    Task MarkReadAsync(int notifId, short userId);
    Task MarkAllReadAsync(short userId);
    Task<IEnumerable<PendingWarrantyNotif>> GetPendingWarrantiesAsync();
    Task<IEnumerable<PendingMaintenanceNotif>> GetPendingMaintenancesAsync();
    Task LogNotificationAsync(string type, int entityId, string intervalLabel);
    Task<bool> IsLoggedAsync(string type, int entityId, string intervalLabel);
    Task<string?> GetSettingValueAsync(byte setId);
}

public class NotificationRepository(IDbConnection db) : INotificationRepository
{
    public async Task<int> CreateAsync(short userId, short companyId, string type, int entityId, int assetId, string message)
    {
        return await db.ExecuteScalarAsync<int>(
            "NOTIF.stpCreateNotification",
            new { UserID = userId, CompanyID = companyId, Type = type, EntityID = entityId, AssetID = assetId, Message = message },
            commandType: CommandType.StoredProcedure);
    }

    public Task<IEnumerable<NotificationDto>> GetForUserAsync(short userId) =>
        db.QueryAsync<NotificationDto>(
            "NOTIF.stpGetNotifications",
            new { UserID = userId },
            commandType: CommandType.StoredProcedure);

    public Task MarkReadAsync(int notifId, short userId) =>
        db.ExecuteAsync(
            "NOTIF.stpMarkNotificationRead",
            new { NotifID = notifId, UserID = userId },
            commandType: CommandType.StoredProcedure);

    public Task MarkAllReadAsync(short userId) =>
        db.ExecuteAsync(
            "NOTIF.stpMarkAllNotificationsRead",
            new { UserID = userId },
            commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<PendingWarrantyNotif>> GetPendingWarrantiesAsync() =>
        db.QueryAsync<PendingWarrantyNotif>(
            "NOTIF.stpGetPendingWarrantyNotifications",
            commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<PendingMaintenanceNotif>> GetPendingMaintenancesAsync() =>
        db.QueryAsync<PendingMaintenanceNotif>(
            "NOTIF.stpGetPendingMaintenanceNotifications",
            commandType: CommandType.StoredProcedure);

    public Task LogNotificationAsync(string type, int entityId, string intervalLabel) =>
        db.ExecuteAsync(
            "NOTIF.stpLogNotification",
            new { Type = type, EntityID = entityId, IntervalLabel = intervalLabel },
            commandType: CommandType.StoredProcedure);

    public async Task<bool> IsLoggedAsync(string type, int entityId, string intervalLabel)
    {
        var count = await db.ExecuteScalarAsync<int>(
            "SELECT COUNT(1) FROM NOTIF.NotificationLogs WHERE Type=@Type AND EntityID=@EntityID AND IntervalLabel=@IntervalLabel",
            new { Type = type, EntityID = entityId, IntervalLabel = intervalLabel });
        return count > 0;
    }

    public Task<string?> GetSettingValueAsync(byte setId) =>
        db.QueryFirstOrDefaultAsync<string?>(
            "SELECT SetValue FROM ATSET.Settings WHERE SetID = @SetID",
            new { SetID = setId });
}
