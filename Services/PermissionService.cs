using System.Data;
using Dapper;

namespace AssetManagement.Api.Services;

public interface IPermissionService
{
    Task<IReadOnlySet<int>> GetAllowedCompanyIdsAsync(short userId);
}

public class PermissionService(IDbConnection db) : IPermissionService
{
    public async Task<IReadOnlySet<int>> GetAllowedCompanyIdsAsync(short userId)
    {
        var ids = await db.QueryAsync<int>(
            "SELECT CompanyID FROM SEC.UsersPermissions WHERE UserID = @UserID",
            new { UserID = userId });
        return ids.ToHashSet();
    }
}
