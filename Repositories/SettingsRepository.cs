using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface ISettingsRepository
{
    Task<IEnumerable<GroupTypeDto>> GetGroupTypesAsync();
    Task<IEnumerable<CategoryTypeDto>> GetCategoryTypesAsync();
    Task<IEnumerable<LocationTypeDto>> GetLocationTypesAsync();
    Task<IEnumerable<LocationDetailDto>> GetLocationDetailsAsync();
    Task<IEnumerable<SettingDto>> GetSettingsAsync();
    Task<string?> GetGeneralSettingValueAsync(byte setId);
}

public class SettingsRepository(IDbConnection db) : ISettingsRepository
{
    public Task<IEnumerable<GroupTypeDto>> GetGroupTypesAsync() =>
        db.QueryAsync<GroupTypeDto>("ATSET.stpGroupTypesS", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<CategoryTypeDto>> GetCategoryTypesAsync() =>
        db.QueryAsync<CategoryTypeDto>("ATSET.stpCategoryTypesS", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<LocationTypeDto>> GetLocationTypesAsync() =>
        db.QueryAsync<LocationTypeDto>("ATSET.stpLocationTypesD", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<LocationDetailDto>> GetLocationDetailsAsync() =>
        db.QueryAsync<LocationDetailDto>("ATSET.stpLocationDetailS", commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<SettingDto>> GetSettingsAsync() =>
        db.QueryAsync<SettingDto>("ATSET.stpGetSettings", commandType: CommandType.StoredProcedure);

    public Task<string?> GetGeneralSettingValueAsync(byte setId) =>
        db.QueryFirstOrDefaultAsync<string?>(
            "SELECT SetValue FROM GSET.Settings WHERE SetID = @SetID",
            new { SetID = setId });
}
