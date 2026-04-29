using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface ILookupRepository
{
    Task<IEnumerable<CompanyDto>> GetCompaniesAsync();
    Task<IEnumerable<CategoryTypeDto>> GetCategoryTypesAsync();
    Task<IEnumerable<GroupTypeDto>> GetGroupTypesAsync();
    Task<IEnumerable<GroupTypeDto>> GetGroupTypesFullAsync();
    Task<IEnumerable<LocationTypeDto>> GetLocationTypesAsync();
    Task<IEnumerable<LocationDetailDto>> GetLocationDetailsAsync(short? locationId = null);
    Task<IEnumerable<StatusTypeDto>> GetStatusTypesAsync();
    Task<IEnumerable<CurrencyDto>> GetCurrenciesAsync();
    Task<IEnumerable<CountryDto>> GetCountriesAsync();
    Task<IEnumerable<ContactTypeDto>> GetContactTypesAsync();
    Task<IEnumerable<BankDto>> GetBanksAsync();
    Task<IEnumerable<SettingDto>> GetAtSettingsAsync();
    Task<IEnumerable<SettingDto>> GetGSetSettingsAsync();
    Task<string> GetAssetCodeAsync(bool generate);

    Task<GroupTypeDto?> CreateGroupTypeAsync(GroupTypeCreateRequest request);
    Task UpdateGroupTypeAsync(GroupTypeUpdateRequest request);
    Task DeleteGroupTypeAsync(short groupId);

    Task<CategoryTypeDto?> CreateCategoryTypeAsync(CategoryTypeCreateRequest request);
    Task UpdateCategoryTypeAsync(CategoryTypeUpdateRequest request);
    Task DeleteCategoryTypeAsync(short categoryId);

    Task CreateLocationTypeAsync(LocationTypeCreateRequest request);
    Task UpdateLocationTypeAsync(short locationId, string location);
    Task DeleteLocationTypeAsync(short locationId);

    Task CreateLocationDetailAsync(LocationDetailCreateRequest request);
    Task UpdateLocationDetailAsync(LocationDetailUpdateRequest request);
    Task DeleteLocationDetailAsync(short locDetailId);

    Task UpdateAtSettingAsync(SettingUpdateRequest request);
    Task UpdateGSetSettingAsync(SettingUpdateRequest request);
}

public class LookupRepository(IDbConnection db) : ILookupRepository
{
    // ── Getters ──────────────────────────────────────────────────────────────

    public Task<IEnumerable<CompanyDto>> GetCompaniesAsync() =>
        db.QueryAsync<CompanyDto>("GSET.stpGetCompanies", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<CategoryTypeDto>> GetCategoryTypesAsync() =>
        db.QueryAsync<CategoryTypeDto>("ATSET.stpGetCategoryTypes", commandType: CommandType.StoredProcedure);

    // Used by dropdowns (returns GroupID, GroupName, Acronym, DepreciationRate)
    public Task<IEnumerable<GroupTypeDto>> GetGroupTypesAsync() =>
        db.QueryAsync<GroupTypeDto>("ATSET.stpGetGroupTypes", commandType: CommandType.StoredProcedure);

    // Used by Settings CRUD (returns all columns including AccountNo, AccountingExclusion)
    public Task<IEnumerable<GroupTypeDto>> GetGroupTypesFullAsync() =>
        db.QueryAsync<GroupTypeDto>("ATSET.stpGroupTypesS", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<LocationTypeDto>> GetLocationTypesAsync() =>
        db.QueryAsync<LocationTypeDto>("ATSET.stpGetLocationTypes", commandType: CommandType.StoredProcedure);

    // stpGetLocationDetails takes NO params → returns all
    // stpLocationDetailS takes @LocationID → returns filtered
    public Task<IEnumerable<LocationDetailDto>> GetLocationDetailsAsync(short? locationId = null) =>
        locationId.HasValue
            ? db.QueryAsync<LocationDetailDto>(
                "ATSET.stpLocationDetailS",
                new { LocationID = locationId.Value },
                commandType: CommandType.StoredProcedure)
            : db.QueryAsync<LocationDetailDto>(
                "ATSET.stpGetLocationDetails",
                commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<StatusTypeDto>> GetStatusTypesAsync() =>
        db.QueryAsync<StatusTypeDto>("ATSET.stpGetStatusTypes", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<CurrencyDto>> GetCurrenciesAsync() =>
        db.QueryAsync<CurrencyDto>("GSET.stpGetCurrencies", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<CountryDto>> GetCountriesAsync() =>
        db.QueryAsync<CountryDto>("GSET.stpGetCountries", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<ContactTypeDto>> GetContactTypesAsync() =>
        db.QueryAsync<ContactTypeDto>("GSET.stpGetContactTypes", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<BankDto>> GetBanksAsync() =>
        db.QueryAsync<BankDto>("GSET.stpGetBanks", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<SettingDto>> GetAtSettingsAsync() =>
        db.QueryAsync<SettingDto>("ATSET.stpGetSettings", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<SettingDto>> GetGSetSettingsAsync() =>
        db.QueryAsync<SettingDto>("GSET.stpGetSettings", commandType: CommandType.StoredProcedure);

    // stpGetAssetCode uses an OUTPUT parameter
    public async Task<string> GetAssetCodeAsync(bool generate)
    {
        var p = new DynamicParameters();
        p.Add("@Generate", generate, DbType.Boolean);
        p.Add("@AssetCode", dbType: DbType.String, direction: ParameterDirection.Output, size: 15);
        await db.ExecuteAsync("ATSET.stpGetAssetCode", p, commandType: CommandType.StoredProcedure);
        return p.Get<string>("@AssetCode") ?? string.Empty;
    }

    // ── Groups ───────────────────────────────────────────────────────────────

    public Task<GroupTypeDto?> CreateGroupTypeAsync(GroupTypeCreateRequest r) =>
        db.QueryFirstOrDefaultAsync<GroupTypeDto>(
            "ATSET.stpGroupTypesI",
            new { r.GroupName, r.Acronym, r.DepreciationRate, r.AccountNo, r.AccountingExclusion },
            commandType: CommandType.StoredProcedure);

    // SP uses optimistic concurrency → fetch original first, then update
    public async Task UpdateGroupTypeAsync(GroupTypeUpdateRequest r)
    {
        var orig = await GetGroupOriginalAsync(r.GroupID);
        if (orig is null) return;
        await db.ExecuteAsync("ATSET.stpGroupTypesU", new
        {
            r.GroupName, r.Acronym, r.DepreciationRate, r.AccountNo, r.AccountingExclusion,
            Original_GroupID = orig.GroupID,
            Original_GroupName = orig.GroupName,
            Original_Acronym = orig.Acronym,
            Original_DepreciationRate = orig.DepreciationRate,
            IsNull_AccountNo = orig.AccountNo is null ? 1 : 0,
            Original_AccountNo = orig.AccountNo,
            Original_AccountingExclusion = orig.AccountingExclusion,
            GroupID = r.GroupID
        }, commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteGroupTypeAsync(short groupId)
    {
        var orig = await GetGroupOriginalAsync(groupId);
        if (orig is null) return;
        await db.ExecuteAsync("ATSET.stpGroupTypesD", new
        {
            Original_GroupID = orig.GroupID,
            Original_GroupName = orig.GroupName,
            Original_Acronym = orig.Acronym,
            Original_DepreciationRate = orig.DepreciationRate,
            IsNull_AccountNo = orig.AccountNo is null ? 1 : 0,
            Original_AccountNo = orig.AccountNo,
            Original_AccountingExclusion = orig.AccountingExclusion
        }, commandType: CommandType.StoredProcedure);
    }

    private async Task<GroupTypeDto?> GetGroupOriginalAsync(short groupId)
    {
        var all = await db.QueryAsync<GroupTypeDto>(
            "ATSET.stpGroupTypesS", commandType: CommandType.StoredProcedure);
        return all.FirstOrDefault(g => g.GroupID == groupId);
    }

    // ── Categories ───────────────────────────────────────────────────────────

    public Task<CategoryTypeDto?> CreateCategoryTypeAsync(CategoryTypeCreateRequest r) =>
        db.QueryFirstOrDefaultAsync<CategoryTypeDto>(
            "ATSET.stpCategoryTypesI",
            new { r.Category, r.GroupID },
            commandType: CommandType.StoredProcedure);

    public async Task UpdateCategoryTypeAsync(CategoryTypeUpdateRequest r)
    {
        var orig = await GetCategoryOriginalAsync(r.CategoryID);
        if (orig is null) return;
        await db.ExecuteAsync("ATSET.stpCategoryTypesU", new
        {
            r.Category, r.GroupID,
            Original_CategoryID = orig.CategoryID,
            Original_Category = orig.Category,
            Original_GroupID = orig.GroupID,
            CategoryID = r.CategoryID
        }, commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteCategoryTypeAsync(short categoryId)
    {
        var orig = await GetCategoryOriginalAsync(categoryId);
        if (orig is null) return;
        await db.ExecuteAsync("ATSET.stpCategoryTypesD", new
        {
            Original_CategoryID = orig.CategoryID,
            Original_Category = orig.Category,
            Original_GroupID = orig.GroupID
        }, commandType: CommandType.StoredProcedure);
    }

    private async Task<CategoryTypeDto?> GetCategoryOriginalAsync(short categoryId)
    {
        var all = await db.QueryAsync<CategoryTypeDto>(
            "ATSET.stpCategoryTypesS", commandType: CommandType.StoredProcedure);
        return all.FirstOrDefault(c => c.CategoryID == categoryId);
    }

    // ── Location Types ───────────────────────────────────────────────────────

    public Task CreateLocationTypeAsync(LocationTypeCreateRequest r) =>
        db.ExecuteAsync("ATSET.stpLocationTypesI", new { r.Location },
            commandType: CommandType.StoredProcedure);

    public Task UpdateLocationTypeAsync(short locationId, string location) =>
        db.ExecuteAsync("ATSET.stpLocationTypesU",
            new { Location = location, LocationID = locationId },
            commandType: CommandType.StoredProcedure);

    public Task DeleteLocationTypeAsync(short locationId) =>
        db.ExecuteAsync("ATSET.stpLocationTypesD", new { LocationID = locationId },
            commandType: CommandType.StoredProcedure);

    // ── Location Details ─────────────────────────────────────────────────────

    public Task CreateLocationDetailAsync(LocationDetailCreateRequest r) =>
        db.ExecuteAsync("ATSET.stpLocationDetailI",
            new { r.LocationID, r.Floor, r.Zone, r.Room },
            commandType: CommandType.StoredProcedure);

    // SP takes Floor, Zone, Room, LocDetailID — no LocationID
    public Task UpdateLocationDetailAsync(LocationDetailUpdateRequest r) =>
        db.ExecuteAsync("ATSET.stpLocationDetailU",
            new { r.Floor, r.Zone, r.Room, r.LocDetailID },
            commandType: CommandType.StoredProcedure);

    public Task DeleteLocationDetailAsync(short locDetailId) =>
        db.ExecuteAsync("ATSET.stpLocationDetailD", new { LocDetailID = locDetailId },
            commandType: CommandType.StoredProcedure);

    // ── Settings ─────────────────────────────────────────────────────────────

    public Task UpdateAtSettingAsync(SettingUpdateRequest r) =>
        db.ExecuteAsync("ATSET.stpSettingsU", new { r.SetID, r.SetValue },
            commandType: CommandType.StoredProcedure);

    public Task UpdateGSetSettingAsync(SettingUpdateRequest r) =>
        db.ExecuteAsync("GSET.stpSettingsU", new { r.SetID, r.SetValue },
            commandType: CommandType.StoredProcedure);
}
