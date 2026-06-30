using System.Security.Claims;
using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using AssetManagement.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class InventoriesController(IInventoryRepository repo, IPermissionService permissionService) : ControllerBase
{
    private short UserId => short.Parse(User.FindFirstValue("userId")!);
    private string FullName => User.FindFirstValue("fullName")!;
    private bool IsAdmin() => User.FindFirstValue("roleId") == "1";
    private bool IsAuditor() => User.FindFirstValue("roleId") == "2";

    [HttpGet("history")]
    public async Task<IActionResult> GetHistory([FromQuery] short companyId) =>
        Ok(await repo.GetInventoriesListAsync(companyId));

    [HttpGet("mode")]
    public async Task<IActionResult> GetMode([FromQuery] short companyId) => Ok(await repo.GetInventoryModeAsync(companyId));

    [HttpGet("info")]
    public async Task<IActionResult> GetInfo([FromQuery] short companyId) => Ok(await repo.GetInventoryInfoAsync(companyId));

    [HttpGet("finish-info")]
    public async Task<IActionResult> GetFinishInfo() => Ok(await repo.GetInventoryFinishInfoAsync());

    [HttpGet("last-date")]
    public async Task<IActionResult> GetLastDate([FromQuery] short companyId) => Ok(await repo.GetInventoryLastDateAsync(companyId));

    [HttpPost("details")]
    public async Task<IActionResult> GetDetails([FromBody] InventoryReportFilterRequest filter)
    {
        if (!IsAdmin() && filter.CompanyID > 0)
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(filter.CompanyID)) return Forbid();
        }
        return Ok(await repo.GetInventoriesDetailsListAsync(filter));
    }

    [HttpGet("generated")]
    public async Task<IActionResult> GetGenerated([FromQuery] short companyId) =>
        Ok(await repo.GetInventoryGeneratedListAsync(companyId));

    [HttpGet("{id:int}/relocated")]
    public async Task<IActionResult> GetRelocated(int id) =>
        Ok(await repo.GetRelocatedAsync(id));

    [HttpPost("report")]
    public async Task<IActionResult> GetReport([FromBody] InventoryReportFilterRequest filter)
    {
        if (!IsAdmin() && filter.CompanyID > 0)
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(filter.CompanyID)) return Forbid();
        }
        return Ok(await repo.GetInventoryReportAsync(filter));
    }

    [HttpPost("start")]
    public async Task<IActionResult> Start([FromBody] InventoryStartRequest request)
    {
        if (IsAuditor()) return Forbid();
        try
        {
            await repo.StartInventoryAsync(request, UserId, FullName);
            return Ok();
        }
        catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
        {
            return Conflict(new { message = $"An inventory session for {request.InventoryStartDate:yyyy-MM-dd} already exists." });
        }
    }

    [HttpPost("{id:int}/refresh")]
    public async Task<IActionResult> Refresh(int id)
    {
        if (IsAuditor()) return Forbid();
        await repo.RefreshInventoryAsync(id, UserId, FullName);
        return Ok();
    }

    [HttpPost("{id:int}/end")]
    public async Task<IActionResult> End(int id, [FromBody] InventoryEndRequest request)
    {
        if (IsAuditor()) return Forbid();
        await repo.EndInventoryAsync(id, request, UserId, FullName);
        return Ok();
    }

    [HttpPut("available/{invDetailId:int}")]
    public async Task<IActionResult> SetAvailable(int invDetailId, [FromBody] bool isAvailable)
    {
        if (IsAuditor()) return Forbid();
        await repo.SetAvailableAsync(invDetailId, isAvailable, UserId, FullName);
        return NoContent();
    }

    [HttpPut("{inventoryId:int}/available-all")]
    public async Task<IActionResult> SetAvailableAll(int inventoryId, [FromBody] bool isAvailable)
    {
        if (IsAuditor()) return Forbid();
        await repo.SetAvailableAllAssetsAsync(isAvailable, inventoryId, UserId, FullName);
        return NoContent();
    }

    [HttpPut("{inventoryId:int}/available-by-code")]
    public async Task<IActionResult> SetAvailableByCode(int inventoryId, [FromQuery] string assetCode, [FromBody] bool isAvailable)
    {
        if (IsAuditor()) return Forbid();
        await repo.SetAvailableByAssetCodeAsync(assetCode, isAvailable, inventoryId, UserId, FullName);
        return NoContent();
    }

    [HttpPut("relocate")]
    public async Task<IActionResult> Relocate([FromBody] InventoryRelocateRequest request)
    {
        if (IsAuditor()) return Forbid();
        await repo.UpdateRelocatedAsync(request, UserId, FullName);
        return NoContent();
    }
}
