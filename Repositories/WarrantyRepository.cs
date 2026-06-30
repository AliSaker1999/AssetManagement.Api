using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IWarrantyRepository
{
    Task<IEnumerable<WarrantyDto>> GetWarrantiesAsync(int assetId);
    Task<WarrantyDto?> CreateWarrantyAsync(WarrantyCreateRequest request);
    Task<WarrantyDto?> UpdateWarrantyAsync(WarrantyUpdateRequest request);
    Task DeleteWarrantyAsync(WarrantyDeleteRequest request);
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

    public async Task<WarrantyDto?> CreateWarrantyAsync(WarrantyCreateRequest request)
    {
        return await db.QueryFirstOrDefaultAsync<WarrantyDto>(
            "AT.stpWarrantiesI",
            new
            {
                request.AssetID, request.AttID, request.WarrantyDesc,
                request.FromDate, request.ToDate, request.Remark
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<WarrantyDto?> UpdateWarrantyAsync(WarrantyUpdateRequest request)
    {
        return await db.QueryFirstOrDefaultAsync<WarrantyDto>(
            "AT.stpWarrantiesU",
            new
            {
                request.AssetID, request.AttID, request.WarrantyDesc,
                request.FromDate, request.ToDate, request.Remark, request.WarntID,
                request.Original_WarntID, request.Original_AssetID,
                request.IsNull_AttID, request.Original_AttID,
                request.Original_WarrantyDesc, request.Original_FromDate,
                request.Original_ToDate, request.IsNull_Remark,
                request.Original_Remark
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteWarrantyAsync(WarrantyDeleteRequest request)
    {
        await db.ExecuteAsync(
            "AT.stpWarrantiesD",
            new
            {
                Original_WarntID = request.WarntID,
                Original_AssetID = request.AssetID,
                IsNull_AttID = request.AttID is null ? 1 : 0,
                Original_AttID = request.AttID,
                Original_WarrantyDesc = request.WarrantyDesc,
                Original_FromDate = request.FromDate,
                Original_ToDate = request.ToDate,
                IsNull_Remark = request.Remark is null ? 1 : 0,
                Original_Remark = request.Remark
            },
            commandType: CommandType.StoredProcedure);
    }
}
