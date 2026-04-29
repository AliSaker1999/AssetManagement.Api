using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IMaintenanceRepository
{
    Task<IEnumerable<MaintenanceDto>> GetMaintenancesAsync(int assetId);
    Task CreateMaintenanceAsync(MaintenanceCreateRequest request);
    Task UpdateMaintenanceAsync(MaintenanceUpdateRequest request);
    Task DeleteMaintenanceAsync(int maintId);
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

    public async Task CreateMaintenanceAsync(MaintenanceCreateRequest request)
    {
        await db.ExecuteAsync(
            "AT.stpMaintenancesI",
            new
            {
                request.AssetID, request.FromDate, request.ToDate,
                request.SupplierContactID, request.Cost, request.CurCode, request.Remark
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateMaintenanceAsync(MaintenanceUpdateRequest request)
    {
        await db.ExecuteAsync(
            "AT.stpMaintenancesU",
            new
            {
                request.AssetID, request.FromDate, request.ToDate,
                request.SupplierContactID, request.Cost, request.CurCode,
                request.Remark, request.MaintID
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteMaintenanceAsync(int maintId)
    {
        await db.ExecuteAsync(
            "AT.stpMaintenancesD",
            new { MaintID = maintId },
            commandType: CommandType.StoredProcedure);
    }
}
