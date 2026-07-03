using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class UsersController(IUserRepository userRepo) : ControllerBase
{
    private static readonly EmailAddressAttribute EmailValidator = new();
    private static int NormalizePageSize(int pageSize) => pageSize is 20 or 30 ? pageSize : 10;

    private bool IsAdmin() =>
        User.Claims.FirstOrDefault(c => c.Type == "roleId")?.Value == "1";

    // ── Users ─────────────────────────────────────────────────────────────────

    [HttpGet]
    public async Task<IActionResult> GetUsers()
    {
        if (!IsAdmin()) return Forbid();
        return Ok(await userRepo.GetUsersAsync());
    }

    [HttpGet("paginated")]
    public async Task<IActionResult> GetUsersPaginated([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 10)
    {
        if (!IsAdmin()) return Forbid();

        pageNumber = Math.Max(1, pageNumber);
        pageSize = NormalizePageSize(pageSize);

        var all = (await userRepo.GetUsersAsync()).ToList();
        var skip = (pageNumber - 1) * pageSize;
        var data = all.Skip(skip).Take(pageSize).ToList();

        return Ok(new PaginatedResponse<UserListDto>
        {
            Data = data,
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = all.Count
        });
    }

    [HttpPost]
    public async Task<IActionResult> CreateUser([FromBody] UserCreateRequest request)
    {
        if (!IsAdmin()) return Forbid();
        if (string.IsNullOrWhiteSpace(request.UserName)) return BadRequest("Username is required.");
        if (string.IsNullOrWhiteSpace(request.Password)) return BadRequest("Password is required.");
        if (string.IsNullOrWhiteSpace(request.FullName)) return BadRequest("Full name is required.");
        if (string.IsNullOrWhiteSpace(request.EmailAddress)) return BadRequest("Email is required.");
        if (!EmailValidator.IsValid(request.EmailAddress)) return BadRequest("Email is invalid.");

        var userId = await userRepo.CreateUserAsync(request);
        return Ok(new { userId });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> UpdateUser(short id, [FromBody] UserUpdateRequest request)
    {
        if (!IsAdmin()) return Forbid();
        if (string.IsNullOrWhiteSpace(request.UserName)) return BadRequest("Username is required.");
        if (string.IsNullOrWhiteSpace(request.FullName)) return BadRequest("Full name is required.");
        if (string.IsNullOrWhiteSpace(request.EmailAddress)) return BadRequest("Email is required.");
        if (!EmailValidator.IsValid(request.EmailAddress)) return BadRequest("Email is invalid.");
        request.UserID = id;
        await userRepo.UpdateUserAsync(request);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> DeleteUser(short id)
    {
        if (!IsAdmin()) return Forbid();
        await userRepo.DeleteUserAsync(id);
        return NoContent();
    }

    // ── Permissions ───────────────────────────────────────────────────────────

    [HttpGet("{id:int}/permissions")]
    public async Task<IActionResult> GetPermissions(short id) =>
        Ok(await userRepo.GetUserPermissionsAsync(id));

    [HttpPost("{id:int}/permissions")]
    public async Task<IActionResult> GrantPermission(short id, [FromBody] UserPermissionGrantRequest request)
    {
        if (!IsAdmin()) return Forbid();
        await userRepo.GrantPermissionAsync(id, request);
        return Ok();
    }

    [HttpDelete("{id:int}/permissions/{countryId}/{companyId:int}")]
    public async Task<IActionResult> RevokePermission(short id, string countryId, short companyId)
    {
        if (!IsAdmin()) return Forbid();
        await userRepo.RevokePermissionAsync(id, countryId, companyId);
        return NoContent();
    }
}
