using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IMaintenanceRepository
{
    Task<IEnumerable<MaintenanceDto>> GetMaintenancesAsync(int assetId);
    Task<MaintenanceDto?> GetByIdAsync(int maintId);
    Task<int> GetActiveMaintenanceCountAsync();
    Task<MaintenanceDto?> CreateMaintenanceAsync(MaintenanceCreateRequest request);
    Task<MaintenanceDto?> UpdateMaintenanceAsync(MaintenanceUpdateRequest request);
    Task DeleteMaintenanceAsync(MaintenanceDeleteRequest request);
}

public class MaintenanceRepository(IDbConnection db) : IMaintenanceRepository
{
    public async Task<IEnumerable<MaintenanceDto>> GetMaintenancesAsync(int assetId)
    {
        return await db.QueryAsync<MaintenanceDto>(
            "AT.stpMaintenancesS",
            new { AssetID = assetId },
            commandType: CommandType.StoredProcedure);
    }

    public Task<MaintenanceDto?> GetByIdAsync(int maintId) =>
        db.QueryFirstOrDefaultAsync<MaintenanceDto>(
            "SELECT MaintID, AssetID, FromDate, ToDate, SupplierContactID, Cost, CurCode, Remark FROM AT.Maintenances WHERE MaintID = @MaintID",
            new { MaintID = maintId });

    public async Task<int> GetActiveMaintenanceCountAsync()
    {
        var today = DateOnly.FromDateTime(DateTime.Today);
        return await db.ExecuteScalarAsync<int>(
            @"SELECT COUNT(DISTINCT AssetID)
              FROM   AT.Maintenances
              WHERE  @Today BETWEEN FromDate AND ToDate",
            new { Today = today });
    }

    public async Task<MaintenanceDto?> CreateMaintenanceAsync(MaintenanceCreateRequest request)
    {
        return await db.QueryFirstOrDefaultAsync<MaintenanceDto>(
            "AT.stpMaintenancesI",
            new
            {
                request.AssetID, request.FromDate, request.ToDate,
                request.SupplierContactID, request.Cost, request.CurCode, request.Remark
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<MaintenanceDto?> UpdateMaintenanceAsync(MaintenanceUpdateRequest request)
    {
        return await db.QueryFirstOrDefaultAsync<MaintenanceDto>(
            "AT.stpMaintenancesU",
            new
            {
                request.AssetID, request.FromDate, request.ToDate,
                request.SupplierContactID, request.Cost, request.CurCode,
                request.Remark, request.MaintID,
                request.Original_MaintID, request.Original_AssetID,
                request.Original_FromDate, request.Original_ToDate,
                request.Original_SupplierContactID, request.Original_Cost,
                request.Original_CurCode, request.IsNull_Remark,
                request.Original_Remark
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteMaintenanceAsync(MaintenanceDeleteRequest request)
    {
        await db.ExecuteAsync(
            "AT.stpMaintenancesD",
            new
            {
                Original_MaintID = request.MaintID,
                Original_AssetID = request.AssetID,
                Original_FromDate = request.FromDate,
                Original_ToDate = request.ToDate,
                Original_SupplierContactID = request.SupplierContactID,
                Original_Cost = request.Cost,
                Original_CurCode = request.CurCode,
                IsNull_Remark = request.Remark is null ? 1 : 0,
                Original_Remark = request.Remark
            },
            commandType: CommandType.StoredProcedure);
    }
}
