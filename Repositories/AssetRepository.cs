using System.Data;
using AssetManagement.Api.Models;
using Dapper;
using AssetManagement.Api.Services;
namespace AssetManagement.Api.Repositories;

public interface IAssetRepository
{
    Task<IEnumerable<AssetListItemDto>> GetAssetsListAsync(int? companyId = null, IReadOnlySet<int>? allowedCompanyIds = null);
    Task<PaginatedResponse<AssetListItemDto>> GetAssetsListPaginatedAsync(int pageNumber = 1, int pageSize = 25, int? companyId = null, IReadOnlySet<int>? allowedCompanyIds = null);
    Task<AssetDto?> GetAssetAsync(int assetId);
    Task<IEnumerable<AssetReportItemDto>> GetAssetsReportAsync(AssetReportFilterRequest filter);
    Task<IEnumerable<AssetNotDepreciatedDto>> GetAssetsNotDepreciatedAsync();
    Task<int> CreateAssetAsync(AssetCreateRequest request, string? imageBase64);
    Task UpdateAssetAsync(AssetUpdateRequest request, string? imageBase64);
    Task DeleteAssetAsync(int assetId);
    Task UpdateAssetStatusAsync(int assetId, AssetStatusUpdateRequest request, short userId, string fullName);
    Task RemoveAssetStatusAsync(int assetId, AssetStatusRemoveRequest request, short userId, string fullName);
    Task<IEnumerable<AssetDepreciationHistoryDto>> GetDepreciationHistoryAsync(int assetId);
    Task<IEnumerable<AssetInventoryHistoryDto>> GetInventoryHistoryAsync(int assetId);
    Task<IEnumerable<StatusHistoryDto>> GetStatusHistoryAsync(int assetId);
    Task<IEnumerable<string>> GetAssetCodeListAsync();
}

public class AssetRepository(IDbConnection db, IHrEmployeeLookupService hrEmployeeLookupService) : IAssetRepository
{
    // stpAssetsList does not join StatusTypes, so Status/StatusID may be null.
    // This enriches the list with the current status name via a single JOIN query.
    private async Task EnrichWithStatusNamesAsync(IList<AssetListItemDto> items)
    {
        if (items.Count == 0 || items.All(i => i.Status != null)) return;
        var statusMap = (await db.QueryAsync<(int AssetID, string Status)>(
            @"SELECT a.AssetID, st.Status
              FROM   AT.Assets a
              INNER JOIN ATSET.StatusTypes st ON st.StatusID = a.StatusID"))
            .ToDictionary(x => x.AssetID, x => x.Status);
        foreach (var item in items.Where(i => i.Status == null))
            item.Status = statusMap.GetValueOrDefault(item.AssetID);
    }

    public async Task<IEnumerable<AssetListItemDto>> GetAssetsListAsync(int? companyId = null, IReadOnlySet<int>? allowedCompanyIds = null)
    {
        var all = (await db.QueryAsync<AssetListItemDto>(
            "AT.stpAssetsList",
            commandType: CommandType.StoredProcedure)).ToList();
        await EnrichWithStatusNamesAsync(all);
        await EnrichWithEmployeeNamesAsync(all);
        IEnumerable<AssetListItemDto> result = all;
        if (companyId.HasValue)
            result = result.Where(a => a.CompanyID == companyId.Value);
        else if (allowedCompanyIds != null)
            result = result.Where(a => allowedCompanyIds.Contains(a.CompanyID));
        return result;
    }

    public async Task<PaginatedResponse<AssetListItemDto>> GetAssetsListPaginatedAsync(int pageNumber = 1, int pageSize = 25, int? companyId = null, IReadOnlySet<int>? allowedCompanyIds = null)
    {
        pageNumber = Math.Max(1, pageNumber);
        pageSize = Math.Max(1, Math.Min(100, pageSize));

        var all = (await db.QueryAsync<AssetListItemDto>(
            "AT.stpAssetsList",
            commandType: CommandType.StoredProcedure)).ToList();
        await EnrichWithStatusNamesAsync(all);
         await EnrichWithEmployeeNamesAsync(all);

        List<AssetListItemDto> filtered;
        if (companyId.HasValue)
            filtered = all.Where(a => a.CompanyID == companyId.Value).ToList();
        else if (allowedCompanyIds != null)
            filtered = all.Where(a => allowedCompanyIds.Contains(a.CompanyID)).ToList();
        else
            filtered = all;

        var totalCount = filtered.Count;
        var skip = (pageNumber - 1) * pageSize;
        var paginatedItems = filtered.Skip(skip).Take(pageSize).ToList();

        return new PaginatedResponse<AssetListItemDto>
        {
            Data = paginatedItems,
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = totalCount
        };
    }
    private async Task EnrichWithEmployeeNamesAsync(IList<AssetListItemDto> items)
    {
        var withEmployee = items.Where(i => !string.IsNullOrWhiteSpace(i.HrEmpIDUsedBy)).ToList();
        if (withEmployee.Count == 0) return;

        foreach (var group in withEmployee.GroupBy(i => i.CompanyID))
        {
            IEnumerable<HrEmployeeDto> employees;
            try
            {
                employees = await hrEmployeeLookupService.GetEmployeesByCompanyAsync(group.Key);
            }
            catch (InvalidOperationException)
            {
                // Company's HR database is misconfigured/unreachable — skip, don't fail the whole list.
                continue;
            }

            var nameByEmpId = employees.ToDictionary(e => e.EmpID, e => e.FullName);
            foreach (var item in group)
                item.EmployeeName = nameByEmpId.GetValueOrDefault(item.HrEmpIDUsedBy!);
        }
    }

    public async Task<AssetDto?> GetAssetAsync(int assetId)
    {
        var asset = await db.QueryFirstOrDefaultAsync<AssetDto>(
            "AT.stpAssetsS",
            new { AssetID = assetId },
            commandType: CommandType.StoredProcedure);

        if (asset is null || asset.StatusID is null) return asset;

        var statusName = await db.QuerySingleOrDefaultAsync<string?>(
            "SELECT [Status] FROM ATSET.StatusTypes WHERE StatusID = @StatusID",
            new { StatusID = asset.StatusID.Value });

        asset.StatusName = statusName;
        return asset;
    }

    public async Task<IEnumerable<AssetReportItemDto>> GetAssetsReportAsync(AssetReportFilterRequest filter)
    {
        return await db.QueryAsync<AssetReportItemDto>(
            "AT.rstpAssetsList",
            new
            {
                filter.LocationID,
                filter.CompanyID,
                filter.CategoryID,
                filter.GroupID,
                LocationDetailID = filter.LocationDetailID,
                filter.AccountingExclusion
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AssetNotDepreciatedDto>> GetAssetsNotDepreciatedAsync()
    {
        return await db.QueryAsync<AssetNotDepreciatedDto>(
            "AT.rstpAssetsNotDepreciated",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<int> CreateAssetAsync(AssetCreateRequest request, string? imageBase64)
    {
        byte[]? imageBytes = imageBase64 is null ? null : Convert.FromBase64String(imageBase64);
        var result = await db.ExecuteScalarAsync<int>(
            "AT.stpAssetsI",
            new
            {
                request.CompanyID, request.AssetCode, AssetImage = imageBytes,
                request.AssetDesc, request.LocationID, request.LocDetailID,
                request.GroupID, request.CategoryID, request.Donation, request.ContactID,
                request.PurchaseOrderNo, request.PurchaseDate, request.PurchasePrice,
                request.PurchaseCurCode, request.InServiceDate, request.InvoiceNo,
                request.InvoiceDate, request.AccountingEntryDate, request.AccountingEntryJVNo,
                request.BarcodeNumber, request.SerialNumber, request.BrandID, request.Model,
                request.Remark, request.InstalledAt, request.OwnerID, request.OwnerDesc,
                HREmpIDUsedBy = request.HrEmpIDUsedBy
            },
            commandType: CommandType.StoredProcedure);
        return result;
    }

    public async Task UpdateAssetAsync(AssetUpdateRequest request, string? imageBase64)
    {
        byte[]? imageBytes = imageBase64 is null ? null : Convert.FromBase64String(imageBase64);
        await db.ExecuteAsync(
            "AT.stpAssetsU",
            new
            {
                request.CompanyID, request.AssetCode, AssetImage = imageBytes,
                request.AssetDesc, request.LocationID, request.LocDetailID,
                request.GroupID, request.CategoryID, request.Donation, request.ContactID,
                request.PurchaseOrderNo, request.PurchaseDate, request.PurchasePrice,
                request.PurchaseCurCode, request.InServiceDate, request.InvoiceNo,
                request.InvoiceDate, request.AccountingEntryDate, request.AccountingEntryJVNo,
                request.BarcodeNumber, request.SerialNumber, request.BrandID, request.Model,
                request.Remark, request.InstalledAt, request.OwnerID, request.OwnerDesc,
                HREmpIDUsedBy = request.HrEmpIDUsedBy,
                request.AssetID
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteAssetAsync(int assetId)
    {
        await db.ExecuteAsync(
            "AT.stpAssetsD",
            new { AssetID = assetId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task RemoveAssetStatusAsync(int assetId, AssetStatusRemoveRequest request, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpAssetsStatusRemove",
            new
            {
                request.StatusID, request.StatusDate, request.StatusContactID,
                request.StatusSalePrice, request.StatusSaleCurCode, request.StatusDesc,
                CreatedByUserID = userId, CreatedByFullName = fullName,
                CreatedByDateTime = DateTime.Now, AssetID = assetId
            },
            commandType: CommandType.StoredProcedure);
    }
    public async Task UpdateAssetStatusAsync(int assetId, AssetStatusUpdateRequest request, short userId, string fullName)
    {
        await db.ExecuteAsync(
            "AT.stpAssetsStatusU",
            new
            {
                request.AssetStatusID, request.AssetStatusDate,
                request.StatusID, request.StatusDate, request.StatusContactID,
                request.StatusSalePrice, request.StatusSaleCurCode, request.StatusDesc,
                request.TransferCompanyProfileID, request.TransferEmpID,
                CreatedByUserID = userId, CreatedByFullName = fullName,
                CreatedByDateTime = DateTime.Now, AssetID = assetId
            },
            commandType: CommandType.StoredProcedure);
    }
    public async Task<IEnumerable<AssetDepreciationHistoryDto>> GetDepreciationHistoryAsync(int assetId)
    {
        return await db.QueryAsync<AssetDepreciationHistoryDto>(
            "AT.stpAssetsDepreciationHistory",
            new { AssetID = assetId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AssetInventoryHistoryDto>> GetInventoryHistoryAsync(int assetId)
    {
        return await db.QueryAsync<AssetInventoryHistoryDto>(
            "AT.stpAssetsInventoryHistory",
            new { AssetID = assetId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<StatusHistoryDto>> GetStatusHistoryAsync(int assetId)
    {
        return await db.QueryAsync<StatusHistoryDto>(
            "AT.stpStatusHistoryS",
            new { AssetID = assetId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<string>> GetAssetCodeListAsync()
    {
        var result = await db.QueryAsync<AssetCodeDto>(
            "AT.stpGetAssetCodeList",
            commandType: CommandType.StoredProcedure);
        return result.Select(r => r.AssetCode);
    }
}