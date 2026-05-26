using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface ILookupRepository
{
    Task<IEnumerable<CompanyDto>> GetCompaniesAsync(short userId = 0);
    Task<CompanyDto?> CreateCompanyAsync(CompanyCreateRequest request);
    Task UpdateCompanyAsync(CompanyUpdateRequest request);
    Task DeleteCompanyAsync(short companyId);
    Task<IEnumerable<CategoryTypeDto>> GetCategoryTypesAsync();
    Task<IEnumerable<GroupTypeDto>> GetGroupTypesAsync(short userId = 0);
    Task<IEnumerable<GroupTypeDto>> GetGroupTypesFullAsync(short userId = 0);
    Task<IEnumerable<LocationTypeDto>> GetLocationTypesAsync(short userId = 0, short? companyId = null);
    Task<IEnumerable<LocationDetailDto>> GetLocationDetailsAsync(short userId = 0, short? locationId = null);
    Task<IEnumerable<StatusTypeDto>> GetStatusTypesAsync();
    Task<IEnumerable<CurrencyDto>> GetCurrenciesAsync();
    Task<CurrencyDto?> CreateCurrencyAsync(CurrencyCreateRequest request);
    Task UpdateCurrencyAsync(CurrencyUpdateRequest request);
    Task DeleteCurrencyAsync(string curCode);
    Task<IEnumerable<CountryDto>> GetCountriesAsync(short userId = 0);
    Task<CountryDto?> CreateCountryAsync(CountryCreateRequest request);
    Task UpdateCountryAsync(CountryUpdateRequest request);
    Task ToggleCountryActiveAsync(string countryId, bool active);
    Task<IEnumerable<ContactTypeDto>> GetContactTypesAsync();
    Task<IEnumerable<BankDto>> GetBanksAsync();
    Task<IEnumerable<SettingDto>> GetAtSettingsAsync();
    Task<IEnumerable<SettingDto>> GetGSetSettingsAsync();
    Task<string> GetAssetCodeAsync(bool generate, string countryId);

    Task<GroupTypeDto?> CreateGroupTypeAsync(GroupTypeCreateRequest request);
    Task UpdateGroupTypeAsync(GroupTypeUpdateRequest request);
    Task DeleteGroupTypeAsync(short groupId);

    Task<CategoryTypeDto?> CreateCategoryTypeAsync(CategoryTypeCreateRequest request);
    Task UpdateCategoryTypeAsync(CategoryTypeUpdateRequest request);
    Task DeleteCategoryTypeAsync(short categoryId);

    Task CreateLocationTypeAsync(LocationTypeCreateRequest request);
    Task UpdateLocationTypeAsync(short locationId, string location, short companyId);
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

    public Task<IEnumerable<CompanyDto>> GetCompaniesAsync(short userId = 0)
    {
        if (userId == 0)
            return db.QueryAsync<CompanyDto>("GSET.stpGetCompanies", commandType: CommandType.StoredProcedure);

        return db.QueryAsync<CompanyDto>(
            @"SELECT CompanyID, CompanyName, CompanyAbbreviation, CompanyPrmCurCode,
                     CompanyScdCurCode, CountryID, EmailNotification, UserNotification
              FROM   GSET.Companies
              WHERE  CompanyID IN (SELECT CompanyID FROM SEC.UsersPermissions WHERE UserID = @UserId)
              ORDER BY CompanyName",
            new { UserId = userId });
    }

    public Task<CompanyDto?> CreateCompanyAsync(CompanyCreateRequest r) =>
        db.QueryFirstOrDefaultAsync<CompanyDto>(
            "GSET.stpCompaniesI",
            new { r.CompanyName, r.CompanyAbbreviation, r.CompanyPrmCurCode, r.CompanyScdCurCode, r.CountryID, r.EmailNotification, r.UserNotification },
            commandType: CommandType.StoredProcedure);

    public Task UpdateCompanyAsync(CompanyUpdateRequest r) =>
        db.ExecuteAsync(
            "GSET.stpCompaniesU",
            new { r.CompanyID, r.CompanyName, r.CompanyAbbreviation, r.CompanyPrmCurCode, r.CompanyScdCurCode, r.CountryID, r.EmailNotification, r.UserNotification },
            commandType: CommandType.StoredProcedure);

    public Task DeleteCompanyAsync(short companyId) =>
        db.ExecuteAsync(
            "GSET.stpCompaniesD",
            new { CompanyID = companyId },
            commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<CategoryTypeDto>> GetCategoryTypesAsync() =>
        db.QueryAsync<CategoryTypeDto>("ATSET.stpGetCategoryTypes", commandType: CommandType.StoredProcedure);

    // Used by dropdowns (returns GroupID, GroupName, Acronym, DepreciationRate)
    public Task<IEnumerable<GroupTypeDto>> GetGroupTypesAsync(short userId = 0)
    {
        if (userId == 0)
            return db.QueryAsync<GroupTypeDto>("ATSET.stpGetGroupTypes", commandType: CommandType.StoredProcedure);

        return db.QueryAsync<GroupTypeDto>(
            @"SELECT GroupID, GroupName, Acronym, DepreciationRate, AccountNo, AccountingExclusion, CountryID
              FROM   ATSET.GroupTypes
              WHERE  CountryID IN (SELECT CountryID FROM SEC.UsersPermissions WHERE UserID = @UserId)
              ORDER BY GroupName",
            new { UserId = userId });
    }

    // Used by Settings CRUD (returns all columns including AccountNo, AccountingExclusion)
    public Task<IEnumerable<GroupTypeDto>> GetGroupTypesFullAsync(short userId = 0)
    {
        if (userId == 0)
            return db.QueryAsync<GroupTypeDto>("ATSET.stpGroupTypesS", commandType: CommandType.StoredProcedure);

        return db.QueryAsync<GroupTypeDto>(
            @"SELECT GroupID, GroupName, Acronym, DepreciationRate, AccountNo, AccountingExclusion, CountryID
              FROM   ATSET.GroupTypes
              WHERE  CountryID IN (SELECT CountryID FROM SEC.UsersPermissions WHERE UserID = @UserId)
              ORDER BY GroupName",
            new { UserId = userId });
    }

    public Task<IEnumerable<LocationTypeDto>> GetLocationTypesAsync(short userId = 0, short? companyId = null)
    {
        if (userId == 0)
            return db.QueryAsync<LocationTypeDto>(
                "ATSET.stpGetLocationTypes",
                new { CompanyID = companyId ?? -1 },
                commandType: CommandType.StoredProcedure);

        return db.QueryAsync<LocationTypeDto>(
            @"SELECT LocationID, Location, CompanyID
              FROM   ATSET.LocationTypes
              WHERE  CompanyID IN (SELECT CompanyID FROM SEC.UsersPermissions WHERE UserID = @UserId)
                AND  (@CompanyID = -1 OR CompanyID = @CompanyID)
              ORDER BY Location",
            new { UserId = userId, CompanyID = companyId ?? -1 });
    }

    // stpGetLocationDetails takes NO params → returns all
    // stpLocationDetailS takes @LocationID → returns filtered
    public Task<IEnumerable<LocationDetailDto>> GetLocationDetailsAsync(short userId = 0, short? locationId = null)
    {
        if (locationId.HasValue)
            return db.QueryAsync<LocationDetailDto>(
                "ATSET.stpLocationDetailS",
                new { LocationID = locationId.Value },
                commandType: CommandType.StoredProcedure);

        if (userId == 0)
            return db.QueryAsync<LocationDetailDto>(
                "ATSET.stpGetLocationDetails",
                commandType: CommandType.StoredProcedure);

        return db.QueryAsync<LocationDetailDto>(
            @"SELECT ld.LocDetailID, ld.LocationID, ld.Floor, ld.Zone, ld.Room
              FROM   ATSET.LocationDetails ld
              JOIN   ATSET.LocationTypes lt ON lt.LocationID = ld.LocationID
              WHERE  lt.CompanyID IN (SELECT CompanyID FROM SEC.UsersPermissions WHERE UserID = @UserId)
              ORDER BY ld.LocationID, ld.Floor, ld.Zone, ld.Room",
            new { UserId = userId });
    }

    public Task<IEnumerable<StatusTypeDto>> GetStatusTypesAsync() =>
        db.QueryAsync<StatusTypeDto>("ATSET.stpGetStatusTypes", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<CurrencyDto>> GetCurrenciesAsync() =>
        db.QueryAsync<CurrencyDto>("SELECT CurCode, CurName FROM GSET.Currencies ORDER BY CurCode");

    public async Task<CurrencyDto?> CreateCurrencyAsync(CurrencyCreateRequest r)
    {
        await db.ExecuteAsync(
            "INSERT INTO GSET.Currencies (CurCode, CurName) VALUES (@CurCode, @CurName)",
            new { r.CurCode, r.CurName });
        return await db.QueryFirstOrDefaultAsync<CurrencyDto>(
            "SELECT CurCode, CurName FROM GSET.Currencies WHERE CurCode = @CurCode",
            new { r.CurCode });
    }

    public Task UpdateCurrencyAsync(CurrencyUpdateRequest r) =>
        db.ExecuteAsync(
            "UPDATE GSET.Currencies SET CurName = @CurName WHERE CurCode = @CurCode",
            new { r.CurCode, r.CurName });

    public Task DeleteCurrencyAsync(string curCode) =>
        db.ExecuteAsync(
            "DELETE FROM GSET.Currencies WHERE CurCode = @CurCode",
            new { CurCode = curCode });

    public Task<IEnumerable<CountryDto>> GetCountriesAsync(short userId = 0)
    {
        if (userId == 0)
            return db.QueryAsync<CountryDto>(
                @"SELECT CountryID, Country, Nationality, ZipCode, WorkingCountry, ActiveCountry, AssetCodeCounter
                  FROM   GSET.Countries
                  ORDER BY Country");

        return db.QueryAsync<CountryDto>(
            @"SELECT CountryID, Country, Nationality, ZipCode, WorkingCountry, ActiveCountry, AssetCodeCounter
              FROM   GSET.Countries
              WHERE  CountryID IN (SELECT CountryID FROM SEC.UsersPermissions WHERE UserID = @UserId)
              ORDER BY Country",
            new { UserId = userId });
    }

    public Task<CountryDto?> CreateCountryAsync(CountryCreateRequest r) =>
        db.QueryFirstOrDefaultAsync<CountryDto>(
            "GSET.stpCountriesI",
            new { r.CountryID, r.Country, r.Nationality, r.ZipCode, r.WorkingCountry, r.ActiveCountry },
            commandType: CommandType.StoredProcedure);

    public Task UpdateCountryAsync(CountryUpdateRequest r) =>
        db.ExecuteAsync(
            "GSET.stpCountriesU",
            new { r.CountryID, r.Country, r.Nationality, r.ZipCode, r.WorkingCountry, r.ActiveCountry },
            commandType: CommandType.StoredProcedure);

    public Task ToggleCountryActiveAsync(string countryId, bool active) =>
        db.ExecuteAsync(
            "UPDATE GSET.Countries SET ActiveCountry = @Active WHERE CountryID = @CountryID",
            new { CountryID = countryId, Active = active });

    public Task<IEnumerable<ContactTypeDto>> GetContactTypesAsync() =>
        db.QueryAsync<ContactTypeDto>("GSET.stpGetContactTypes", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<BankDto>> GetBanksAsync() =>
        db.QueryAsync<BankDto>("GSET.stpGetBanks", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<SettingDto>> GetAtSettingsAsync() =>
        db.QueryAsync<SettingDto>("ATSET.stpGetSettings", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<SettingDto>> GetGSetSettingsAsync() =>
        db.QueryAsync<SettingDto>("GSET.stpGetSettings", commandType: CommandType.StoredProcedure);

    // stpGetAssetCode uses an OUTPUT parameter
    public async Task<string> GetAssetCodeAsync(bool generate, string countryId)
    {
        var p = new DynamicParameters();
        p.Add("@CountryID", countryId, DbType.StringFixedLength, size: 2);
        p.Add("@Generate", generate, DbType.Boolean);
        p.Add("@AssetCode", dbType: DbType.String, direction: ParameterDirection.Output, size: 20);
        await db.ExecuteAsync("ATSET.stpGetAssetCode", p, commandType: CommandType.StoredProcedure);
        return p.Get<string>("@AssetCode") ?? string.Empty;
    }

    // ── Groups ───────────────────────────────────────────────────────────────

    public Task<GroupTypeDto?> CreateGroupTypeAsync(GroupTypeCreateRequest r) =>
        db.QueryFirstOrDefaultAsync<GroupTypeDto>(
            "ATSET.stpGroupTypesI",
            new { r.GroupName, r.Acronym, r.DepreciationRate, r.AccountNo, r.AccountingExclusion, r.CountryID },
            commandType: CommandType.StoredProcedure);

    // SP uses optimistic concurrency → fetch original first, then update
    public async Task UpdateGroupTypeAsync(GroupTypeUpdateRequest r)
    {
        var orig = await GetGroupOriginalAsync(r.GroupID);
        if (orig is null) return;
        await db.ExecuteAsync("ATSET.stpGroupTypesU", new
        {
            r.GroupName, r.Acronym, r.DepreciationRate, r.AccountNo, r.AccountingExclusion, r.CountryID,
            Original_GroupID = orig.GroupID,
            Original_GroupName = orig.GroupName,
            Original_Acronym = orig.Acronym,
            Original_DepreciationRate = orig.DepreciationRate,
            IsNull_AccountNo = orig.AccountNo is null ? 1 : 0,
            Original_AccountNo = orig.AccountNo,
            Original_AccountingExclusion = orig.AccountingExclusion,
            r.GroupID
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
            r.CategoryID
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
        db.ExecuteAsync("ATSET.stpLocationTypesI", new { r.Location, r.CompanyID },
            commandType: CommandType.StoredProcedure);

    public Task UpdateLocationTypeAsync(short locationId, string location, short companyId) =>
        db.ExecuteAsync("ATSET.stpLocationTypesU",
            new { Location = location, CompanyID = companyId, LocationID = locationId },
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
