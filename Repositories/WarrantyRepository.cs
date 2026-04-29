using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IWarrantyRepository
{
    Task<IEnumerable<WarrantyDto>> GetWarrantiesAsync(int assetId);
    Task CreateWarrantyAsync(WarrantyCreateRequest request);
    Task UpdateWarrantyAsync(WarrantyUpdateRequest request);
    Task DeleteWarrantyAsync(int warntId);
}

public class WarrantyRepository(IDbConnection db) : IWarrantyRepository
{
    public async Task<IEnumerable<WarrantyDto>> GetWarrantiesAsync(int assetId)
    {
        return await db.QueryAsync<WarrantyDto>(
            "AT.stpWarrantiesS",
            new { AssetID = assetId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task CreateWarrantyAsync(WarrantyCreateRequest request)
    {
        await db.ExecuteAsync(
            "AT.stpWarrantiesI",
            new
            {
                request.AssetID, request.WarrantyDesc,
                request.FromDate, request.ToDate, request.Remark
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateWarrantyAsync(WarrantyUpdateRequest request)
    {
        await db.ExecuteAsync(
            "AT.stpWarrantiesU",
            new
            {
                request.AssetID, request.WarrantyDesc,
                request.FromDate, request.ToDate, request.Remark, request.WarntID
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteWarrantyAsync(int warntId)
    {
        await db.ExecuteAsync(
            "AT.stpWarrantiesD",
            new { WarntID = warntId },
            commandType: CommandType.StoredProcedure);
    }
}
