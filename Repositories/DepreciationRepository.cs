using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IDepreciationRepository
{
    Task<IEnumerable<DepreciationDto>> GetDepreciationsAsync();
    Task<IEnumerable<DepreciationReportItemDto>> GetDepreciationReportAsync(int depId);
    Task<DateOnly?> GetLastDepreciationDateAsync();
    Task RunDepreciationAsync(RunDepreciationRequest request, short userId, string fullName);
    Task DeleteLastDepreciationAsync(short userId, string fullName);
    Task<IEnumerable<AssetNotDepreciatedDto>> GetAssetsNotDepreciatedAsync();
}

public class DepreciationRepository(IDbConnection db) : IDepreciationRepository
{
    public async Task<IEnumerable<DepreciationDto>> GetDepreciationsAsync()
    {
        return await db.QueryAsync<DepreciationDto>(
            "AT.stpGetDepreciation",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<DepreciationReportItemDto>> GetDepreciationReportAsync(int depId)
    {
        return await db.QueryAsync<DepreciationReportItemDto>(
            "AT.rstpDepreciation",
            new { DepID = depId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<DateOnly?> GetLastDepreciationDateAsync()
    {
        var result = await db.QueryFirstOrDefaultAsync<DateTime?>(
            "AT.stpGetDepreciationLastDate",
            commandType: CommandType.StoredProcedure);
        return result.HasValue ? DateOnly.FromDateTime(result.Value) : null;
    }

    public async Task RunDepreciationAsync(RunDepreciationRequest request, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpProDepreciation",
            new
            {
                request.DepreciationDate,
                request.Remark,
                CreatedByUserID = userId,
                CreatedByFullName = fullName,
                CreatedByDateTime = DateTime.Now
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteLastDepreciationAsync(short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpDepreciationLastDelete",
            new
            {
                CreatedByUserID = userId,
                CreatedByFullName = fullName,
                CreatedByDateTime = DateTime.Now
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AssetNotDepreciatedDto>> GetAssetsNotDepreciatedAsync()
    {
        return await db.QueryAsync<AssetNotDepreciatedDto>(
            "AT.rstpAssetsNotDepreciated",
            commandType: CommandType.StoredProcedure);
    }
}
