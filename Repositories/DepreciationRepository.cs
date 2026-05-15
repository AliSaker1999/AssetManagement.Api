using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IDepreciationRepository
{
    Task<IEnumerable<DepreciationDto>> GetDepreciationsAsync(short companyId);
    Task<IEnumerable<DepreciationReportItemDto>> GetDepreciationReportAsync(int depId);
    Task<DateOnly?> GetLastDepreciationDateAsync(short companyId);
    Task RunDepreciationAsync(RunDepreciationRequest request, short userId, string fullName);
    Task DeleteLastDepreciationAsync(short companyId);
    Task<IEnumerable<AssetNotDepreciatedDto>> GetAssetsNotDepreciatedAsync();
}

public class DepreciationRepository(IDbConnection db) : IDepreciationRepository
{
    public async Task<IEnumerable<DepreciationDto>> GetDepreciationsAsync(short companyId)
    {
        return await db.QueryAsync<DepreciationDto>(
            "AT.stpGetDepreciation",
            new { CompanyID = companyId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<DepreciationReportItemDto>> GetDepreciationReportAsync(int depId)
    {
        return await db.QueryAsync<DepreciationReportItemDto>(
            "AT.rstpDepreciation",
            new { DepID = depId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<DateOnly?> GetLastDepreciationDateAsync(short companyId)
    {
        var result = await db.QueryFirstOrDefaultAsync<DepreciationDto>(
            "AT.stpGetDepreciationLastDate",
            new { CompanyID = companyId },
            commandType: CommandType.StoredProcedure);
        return result?.DepreciationDate;
    }

    public async Task RunDepreciationAsync(RunDepreciationRequest request, short userId, string fullName)
    {
        var p = new DynamicParameters();
        p.Add("DepreciationDate",  request.DepreciationDate);
        p.Add("CompanyID",         request.CompanyID);
        p.Add("Remark",            request.Remark);
        p.Add("CreatedByUserID",   userId);
        p.Add("CreatedByFullName", fullName);
        p.Add("CreatedByDateTime", DateTime.Now);
        p.Add("RowEffected",       dbType: DbType.Int32, direction: ParameterDirection.Output);

        await db.ExecuteAsync(
            "AT.stpProDepreciation",
            p,
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteLastDepreciationAsync(short companyId)
    {
        var p = new DynamicParameters();
        p.Add("CompanyID",        companyId);
        p.Add("DepreciationDate", dbType: DbType.Date, direction: ParameterDirection.Output);

        await db.ExecuteAsync(
            "AT.stpDepreciationLastDelete",
            p,
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AssetNotDepreciatedDto>> GetAssetsNotDepreciatedAsync()
    {
        return await db.QueryAsync<AssetNotDepreciatedDto>(
            "AT.rstpAssetsNotDepreciated",
            commandType: CommandType.StoredProcedure);
    }
}
