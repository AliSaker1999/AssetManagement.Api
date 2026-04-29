using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IInventoryRepository
{
    Task<object?> GetInventoryModeAsync();
    Task<object?> GetInventoryInfoAsync();
    Task<object?> GetInventoryFinishInfoAsync();
    Task<DateOnly?> GetInventoryLastDateAsync();
    Task<IEnumerable<InventoryDetailDto>> GetInventoriesDetailsListAsync(InventoryReportFilterRequest filter);
    Task<IEnumerable<InventoryGeneratedItemDto>> GetInventoryGeneratedListAsync(int inventoryId);
    Task StartInventoryAsync(InventoryStartRequest request, short userId, string fullName);
    Task RefreshInventoryAsync(int inventoryId, short userId, string fullName);
    Task EndInventoryAsync(int inventoryId, InventoryEndRequest request, short userId, string fullName);
    Task SetAvailableAsync(int invDetailId, bool isAvailable, short userId, string fullName);
    Task SetAvailableAllAssetsAsync(bool isAvailable, int inventoryId, short userId, string fullName);
    Task SetAvailableByAssetCodeAsync(string assetCode, bool isAvailable, int inventoryId, short userId, string fullName);
    Task UpdateRelocatedAsync(InventoryRelocateRequest request, short userId, string fullName);
    Task<IEnumerable<InventoryDetailDto>> GetRelocatedAsync(int inventoryId);
    Task<IEnumerable<AssetReportItemDto>> GetInventoryReportAsync(InventoryReportFilterRequest filter);
}

public class InventoryRepository(IDbConnection db) : IInventoryRepository
{
    public async Task<object?> GetInventoryModeAsync()
    {
        return await db.QueryFirstOrDefaultAsync(
            "AT.stpGetInventoryMode",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<object?> GetInventoryInfoAsync()
    {
        return await db.QueryFirstOrDefaultAsync(
            "AT.stpGetInventoryInfo",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<object?> GetInventoryFinishInfoAsync()
    {
        return await db.QueryFirstOrDefaultAsync(
            "AT.stpGetInventoryFinishInfo",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<DateOnly?> GetInventoryLastDateAsync()
    {
        var result = await db.QueryFirstOrDefaultAsync<DateTime?>(
            "AT.stpGetInventoryLastDate",
            commandType: CommandType.StoredProcedure);
        return result.HasValue ? DateOnly.FromDateTime(result.Value) : null;
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

    public async Task<IEnumerable<InventoryGeneratedItemDto>> GetInventoryGeneratedListAsync(int inventoryId)
    {
        return await db.QueryAsync<InventoryGeneratedItemDto>(
            "AT.stpInventoryGeneratedList",
            new { InventoryID = inventoryId },
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
            new
            {
                InventoryID = inventoryId,
                StartCreatedByUserID = userId,
                StartCreatedByFullName = fullName,
                StartCreatedByDateTime = DateTime.Now
            },
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
                EndCreatedByUserID = userId,
                EndCreatedByFullName = fullName,
                EndCreatedByDateTime = DateTime.Now
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task SetAvailableAsync(int invDetailId, bool isAvailable, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpInventoryIsAvailable",
            new
            {
                InvDetailID = invDetailId,
                IsAvailable = isAvailable,
                CreatedByUserID = userId,
                CreatedByFullName = fullName,
                CreatedByDateTime = DateTime.Now
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task SetAvailableAllAssetsAsync(bool isAvailable, int inventoryId, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpInventoryIsAvailableAllAssets",
            new
            {
                IsAvailable = isAvailable,
                InventoryID = inventoryId,
                CreatedByUserID = userId,
                CreatedByFullName = fullName,
                CreatedByDateTime = DateTime.Now
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task SetAvailableByAssetCodeAsync(string assetCode, bool isAvailable, int inventoryId, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpInventoryIsAvailableByAssetCode",
            new
            {
                AssetCode = assetCode,
                IsAvailable = isAvailable,
                InventoryID = inventoryId,
                CreatedByUserID = userId,
                CreatedByFullName = fullName,
                CreatedByDateTime = DateTime.Now
            },
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
                CreatedByUserID = userId,
                CreatedByFullName = fullName,
                CreatedByDateTime = DateTime.Now
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
}
