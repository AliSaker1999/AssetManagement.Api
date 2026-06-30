using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IReportRepository
{
    Task<IEnumerable<AssetsListReportRowDto>> GetAssetsListAsync(AssetsListReportRequest request);
    Task<IEnumerable<AssetsListInventoryReportRowDto>> GetAssetsListInventoryAsync(AssetsListInventoryReportRequest request);
    Task<IEnumerable<DepreciationReportGenerateRowDto>> GetDepreciationAsync(int depId);
    Task<IEnumerable<AssetsNotDepreciatedReportRowDto>> GetAssetsNotDepreciatedAsync();
}

public class ReportRepository(IDbConnection db) : IReportRepository
{
    public Task<IEnumerable<AssetsListReportRowDto>> GetAssetsListAsync(AssetsListReportRequest r) =>
        db.QueryAsync<AssetsListReportRowDto>(
            "AT.rstpAssetsList",
            new
            {
                r.LocationID,
                r.CompanyID,
                r.CategoryID,
                r.GroupID,
                LocationDetailID = r.LocationDetailID,
                r.AccountingExclusion
            },
            commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<AssetsListInventoryReportRowDto>> GetAssetsListInventoryAsync(AssetsListInventoryReportRequest r) =>
        db.QueryAsync<AssetsListInventoryReportRowDto>(
            "AT.rstpAssetsListInventory",
            new
            {
                r.InventoryID,
                r.LocationID,
                r.CompanyID,
                r.CategoryID,
                r.GroupID,
                LocationDetailID = r.LocationDetailID,
                r.AccountingExclusion
            },
            commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<DepreciationReportGenerateRowDto>> GetDepreciationAsync(int depId) =>
        db.QueryAsync<DepreciationReportGenerateRowDto>(
            "AT.rstpDepreciation",
            new { DepID = depId },
            commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<AssetsNotDepreciatedReportRowDto>> GetAssetsNotDepreciatedAsync() =>
        db.QueryAsync<AssetsNotDepreciatedReportRowDto>(
            "AT.rstpAssetsNotDepreciated",
            commandType: CommandType.StoredProcedure);
}
