using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IInventoryRepository
{
    Task<InventoryDto?> GetInventoryModeAsync(short companyId);
    Task<object?> GetInventoryInfoAsync(short companyId);
    Task<object?> GetInventoryFinishInfoAsync();
    Task<DateOnly?> GetInventoryLastDateAsync(short companyId);
    Task<IEnumerable<InventoryDetailDto>> GetInventoriesDetailsListAsync(InventoryReportFilterRequest filter);
    Task<IEnumerable<InventoryGeneratedItemDto>> GetInventoryGeneratedListAsync(short companyId);
    Task StartInventoryAsync(InventoryStartRequest request, short userId, string fullName);
    Task RefreshInventoryAsync(int inventoryId, short userId, string fullName);
    Task EndInventoryAsync(int inventoryId, InventoryEndRequest request, short userId, string fullName);
    Task SetAvailableAsync(int invDetailId, bool isAvailable, short userId, string fullName);
    Task SetAvailableAllAssetsAsync(bool isAvailable, int inventoryId, short userId, string fullName);
    Task SetAvailableByAssetCodeAsync(string assetCode, bool isAvailable, int inventoryId, short userId, string fullName);
    Task UpdateRelocatedAsync(InventoryRelocateRequest request, short userId, string fullName);
    Task<IEnumerable<InventoryDetailDto>> GetRelocatedAsync(int inventoryId);
    Task<IEnumerable<AssetReportItemDto>> GetInventoryReportAsync(InventoryReportFilterRequest filter);
    Task<IEnumerable<InventoryListItemDto>> GetInventoriesListAsync(short companyId);
}

public class InventoryRepository(IDbConnection db) : IInventoryRepository
{
    public async Task<InventoryDto?> GetInventoryModeAsync(short companyId)
    {
        return await db.QueryFirstOrDefaultAsync<InventoryDto>(
            "AT.stpGetInventoryMode",
            new { CompanyID = companyId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<object?> GetInventoryInfoAsync(short companyId)
    {
        return await db.QueryFirstOrDefaultAsync(
            "AT.stpGetInventoryInfo",
            new { CompanyID = companyId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<object?> GetInventoryFinishInfoAsync()
    {
        return await db.QueryFirstOrDefaultAsync(
            "AT.stpGetInventoryFinishInfo",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<DateOnly?> GetInventoryLastDateAsync(short companyId)
    {
        var result = await db.QueryFirstOrDefaultAsync<InventoryDto>(
            "AT.stpGetInventoryLastDate",
            new { CompanyID = companyId },
            commandType: CommandType.StoredProcedure);
        return result?.InventoryStartDate;
    }

    public async Task<IEnumerable<InventoryDetailDto>> GetInventoriesDetailsListAsync(InventoryReportFilterRequest filter)
    {
        return await db.QueryAsync<InventoryDetailDto>(
            "AT.stpInventoriesDetailsList",
            new
            {
                filter.InventoryID,
                filter.LocationID,
                filter.CompanyID,
                filter.CategoryID,
                filter.GroupID,
                LocationDetailID = filter.LocationDetailID,
                filter.AccountingExclusion
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<InventoryGeneratedItemDto>> GetInventoryGeneratedListAsync(short companyId)
    {
        return await db.QueryAsync<InventoryGeneratedItemDto>(
            "AT.stpInventoryGeneratedList",
            new { CompanyID = companyId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task StartInventoryAsync(InventoryStartRequest request, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpProInventoryStart",
            new
            {
                request.InventoryStartDate,
                request.Remark,
                request.CompanyID,
                StartCreatedByUserID = userId,
                StartCreatedByFullName = fullName,
                StartCreatedByDateTime = DateTime.Now
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task RefreshInventoryAsync(int inventoryId, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpProInventoryStartRefresh",
            new { InventoryID = inventoryId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task EndInventoryAsync(int inventoryId, InventoryEndRequest request, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpProInventoryEnd",
            new
            {
                InventoryID = inventoryId,
                request.InventoryEndDate,
                CreatedByUserID = userId,
                CreatedByFullName = fullName,
                CreatedByDateTime = DateTime.Now
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task SetAvailableAsync(int invDetailId, bool isAvailable, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpInventoryIsAvailable",
            new { InvDetailID = invDetailId, IsAvailable = isAvailable },
            commandType: CommandType.StoredProcedure);
    }

    public async Task SetAvailableAllAssetsAsync(bool isAvailable, int inventoryId, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpInventoryIsAvailableAllAssets",
            new { InventoryID = inventoryId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task SetAvailableByAssetCodeAsync(string assetCode, bool isAvailable, int inventoryId, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpInventoryIsAvailableByAssetCode",
            new { AssetCode = assetCode, IsAvailable = isAvailable, InventoryID = inventoryId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task UpdateRelocatedAsync(InventoryRelocateRequest request, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpInventoryRelocatedU",
            new
            {
                request.InvDetailID,
                request.RelocatedLocationID,
                request.RelocatedLocDetailID,
                Relocated = true,
                Remark = (string?)null
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<InventoryDetailDto>> GetRelocatedAsync(int inventoryId)
    {
        return await db.QueryAsync<InventoryDetailDto>(
            "AT.stpInventoryRelocatedS",
            new { InventoryID = inventoryId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AssetReportItemDto>> GetInventoryReportAsync(InventoryReportFilterRequest filter)
    {
        return await db.QueryAsync<AssetReportItemDto>(
            "AT.rstpAssetsListInventory",
            new
            {
                filter.InventoryID,
                filter.LocationID,
                filter.CompanyID,
                filter.CategoryID,
                filter.GroupID,
                LocationDetailID = filter.LocationDetailID,
                filter.AccountingExclusion
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<InventoryListItemDto>> GetInventoriesListAsync(short companyId)
    {
        return await db.QueryAsync<InventoryListItemDto>(
            "AT.stpInventoriesList",
            new { CompanyID = companyId },
            commandType: CommandType.StoredProcedure);
    }
}
