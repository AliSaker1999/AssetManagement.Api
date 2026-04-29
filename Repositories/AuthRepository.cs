using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IAuthRepository
{
    Task<UserDto?> GetLoginUserAsync(string userName, string password);
    Task<IEnumerable<RoleDto>> GetRolesAsync();
}

public class AuthRepository(IDbConnection db) : IAuthRepository
{
    public async Task<UserDto?> GetLoginUserAsync(string userName, string password)
    {
        return await db.QueryFirstOrDefaultAsync<UserDto>(
            "SEC.stpGetLoginUser",
            new { UserName = userName, Password = password },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<RoleDto>> GetRolesAsync()
    {
        return await db.QueryAsync<RoleDto>(
            "SEC.stpGetRoles",
            commandType: CommandType.StoredProcedure);
    }
}
