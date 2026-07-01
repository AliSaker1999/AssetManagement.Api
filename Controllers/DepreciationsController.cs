using System.Security.Claims;
using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using AssetManagement.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class DepreciationsController(IDepreciationRepository repo, IPermissionService permissionService) : ControllerBase
{
    private short UserId => short.Parse(User.FindFirstValue("userId")!);
    private string FullName => User.FindFirstValue("fullName")!;
    private bool IsAdmin() => User.FindFirstValue("roleId") == "1";
    private bool IsAuditor() => User.FindFirstValue("roleId") == "2";

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] short companyId)
    {
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(companyId)) return Forbid();
        }
        return Ok(await repo.GetDepreciationsAsync(companyId));
    }

    [HttpGet("{id:int}/report")]
    public async Task<IActionResult> GetReport(int id) =>
        Ok(await repo.GetDepreciationReportAsync(id));

    [HttpGet("last-date")]
    public async Task<IActionResult> GetLastDate([FromQuery] short companyId)
    {
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(companyId)) return Forbid();
        }
        return Ok(await repo.GetLastDepreciationDateAsync(companyId));
    }

    [HttpGet("not-depreciated")]
    public async Task<IActionResult> GetNotDepreciated() => Ok(await repo.GetAssetsNotDepreciatedAsync());

    [HttpPost("run")]
    public async Task<IActionResult> Run([FromBody] RunDepreciationRequest request)
    {
        if (IsAuditor()) return Forbid();
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(request.CompanyID)) return Forbid();
        }
        try
        {
            await repo.RunDepreciationAsync(request, UserId, FullName);
            return Ok();
        }
        catch (Microsoft.Data.SqlClient.SqlException ex) when (ex.Number == 50021 || ex.Number == 50022)
        {
            return BadRequest(new { message = ex.Message });
        }
        catch (Microsoft.Data.SqlClient.SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
        {
            return Conflict(new { message = $"A depreciation run for {request.DepreciationDate:yyyy-MM-dd} already exists. Delete the existing run first or choose a different date." });
        }
    }

    [HttpDelete("last")]
    public async Task<IActionResult> DeleteLast([FromQuery] short companyId)
    {
        if (IsAuditor()) return Forbid();
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(companyId)) return Forbid();
        }
        await repo.DeleteLastDepreciationAsync(companyId);
        return NoContent();
    }
}
