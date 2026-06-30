using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IUserRepository
{
    Task<IEnumerable<UserListDto>> GetUsersAsync();
    Task<int> CreateUserAsync(UserCreateRequest request);
    Task UpdateUserAsync(UserUpdateRequest request);
    Task DeleteUserAsync(short userId);

    Task<IEnumerable<UserPermissionDto>> GetUserPermissionsAsync(short userId);
    Task GrantPermissionAsync(short userId, UserPermissionGrantRequest request);
    Task RevokePermissionAsync(short userId, string countryId, short companyId);
}

public class UserRepository(IDbConnection db) : IUserRepository
{
    public Task<IEnumerable<UserListDto>> GetUsersAsync() =>
        db.QueryAsync<UserListDto>(
                        @"SELECT u.UserID, u.UserName, u.FullName, u.EmailAddress, u.RoleID, r.RoleName
              FROM   SEC.Users u
              JOIN   SEC.Roles r ON u.RoleID = r.RoleID
              WHERE  u.RoleID <> 1
              ORDER BY u.FullName");

    public async Task<int> CreateUserAsync(UserCreateRequest r)
    {
        var result = await db.QueryFirstOrDefaultAsync<dynamic>(
            "SEC.stpUsersI",
            new { r.UserName, r.Password, r.FullName, r.EmailAddress, r.RoleID },
            commandType: CommandType.StoredProcedure);
        return (int)(result?.UserID ?? 0);
    }

    public Task UpdateUserAsync(UserUpdateRequest r) =>
        db.ExecuteAsync(
            "SEC.stpUsersU",
            new { r.UserID, r.UserName, r.Password, r.FullName, r.EmailAddress, r.RoleID },
            commandType: CommandType.StoredProcedure);

    public Task DeleteUserAsync(short userId) =>
        db.ExecuteAsync(
            "SEC.stpUsersD",
            new { UserID = userId },
            commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<UserPermissionDto>> GetUserPermissionsAsync(short userId) =>
        db.QueryAsync<UserPermissionDto>(
            "SEC.stpGetUserPermissions",
            new { UserID = userId },
            commandType: CommandType.StoredProcedure);

    public Task GrantPermissionAsync(short userId, UserPermissionGrantRequest r) =>
        db.ExecuteAsync(
            "SEC.stpUserPermissionsI",
            new { UserID = userId, r.CountryID, r.CompanyID },
            commandType: CommandType.StoredProcedure);

    public Task RevokePermissionAsync(short userId, string countryId, short companyId) =>
        db.ExecuteAsync(
            "SEC.stpUserPermissionsD",
            new { UserID = userId, CountryID = countryId, CompanyID = companyId },
            commandType: CommandType.StoredProcedure);
}
