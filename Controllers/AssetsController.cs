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
public class AssetsController(IAssetRepository repo, IPermissionService permissionService) : ControllerBase
{
    private const byte CompanyOwnerId = 1;
    private static int NormalizePageSize(int pageSize) => pageSize is 20 or 30 ? pageSize : 10;
    private short UserId => short.Parse(User.FindFirstValue("userId")!);
    private string FullName => User.FindFirstValue("fullName")!;
    private bool IsAdmin() => User.FindFirstValue("roleId") == "1";
    private bool IsAuditor() => User.FindFirstValue("roleId") == "2";

    [HttpGet]
    public async Task<IActionResult> GetList([FromQuery] int? companyId = null)
    {
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (companyId.HasValue && !allowed.Contains(companyId.Value)) return Forbid();
            return Ok(await repo.GetAssetsListAsync(companyId, companyId.HasValue ? null : allowed));
        }
        return Ok(await repo.GetAssetsListAsync(companyId));
    }

    [HttpGet("paginated")]
    public async Task<IActionResult> GetListPaginated([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 10, [FromQuery] int? companyId = null)
    {
        pageNumber = Math.Max(1, pageNumber);
        pageSize = NormalizePageSize(pageSize);
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (companyId.HasValue && !allowed.Contains(companyId.Value)) return Forbid();
            return Ok(await repo.GetAssetsListPaginatedAsync(pageNumber, pageSize, companyId, companyId.HasValue ? null : allowed));
        }
        return Ok(await repo.GetAssetsListPaginatedAsync(pageNumber, pageSize, companyId));
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id)
    {
        var asset = await repo.GetAssetAsync(id);
        if (asset is null) return NotFound();
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(asset.CompanyID)) return Forbid();
        }
        return Ok(asset);
    }

    [HttpPost("report")]
    public async Task<IActionResult> GetReport([FromBody] AssetReportFilterRequest filter)
    {
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (filter.CompanyID > 0 && !allowed.Contains(filter.CompanyID)) return Forbid();
        }
        return Ok(await repo.GetAssetsReportAsync(filter));
    }

    [HttpGet("not-depreciated")]
    public async Task<IActionResult> GetNotDepreciated() =>
        Ok(await repo.GetAssetsNotDepreciatedAsync());

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] AssetCreateRequest request)
    {
        if (IsAuditor()) return Forbid();
        var validationError = ValidateAssetRequest(request);
        if (validationError is not null) return BadRequest(validationError);
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(request.CompanyID)) return Forbid();
        }
        var id = await repo.CreateAssetAsync(request, null);
        return Ok(new { AssetID = id });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] AssetUpdateRequest request)
    {
        if (IsAuditor()) return Forbid();
        var validationError = ValidateAssetRequest(request);
        if (validationError is not null) return BadRequest(validationError);
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(request.CompanyID)) return Forbid();
        }
        request.AssetID = id;
        await repo.UpdateAssetAsync(request, null);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        if (IsAuditor()) return Forbid();
        if (!IsAdmin())
        {
            var asset = await repo.GetAssetAsync(id);
            if (asset is null) return NotFound();
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(asset.CompanyID)) return Forbid();
        }
        try
        {
            await repo.DeleteAssetAsync(id);
            return NoContent();
        }
        catch (SqlException ex) when (ex.Number == 50011)
        {
            return BadRequest(new { message = "This is not the last record." });
        }
        catch (SqlException ex) when (ex.Number == 50010)
        {
            return NotFound(new { message = "Asset not found." });
        }
        catch (SqlException ex) when (ex.Number == 547)
        {
            return Conflict(new { message = "This asset cannot be deleted because it has related records (depreciation history, maintenance, etc.). Remove those records first or contact your administrator." });
        }
    }

    [HttpPut("{id:int}/status")]
    public async Task<IActionResult> UpdateStatus(int id, [FromBody] AssetStatusUpdateRequest request)
    {
        if (IsAuditor()) return Forbid();
        if (!IsAdmin())
        {
            var asset = await repo.GetAssetAsync(id);
            if (asset is null) return NotFound();
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(asset.CompanyID)) return Forbid();
        }

        if (request.StatusID == 2)
        {
            if (!request.TransferCompanyProfileID.HasValue || request.TransferCompanyProfileID <= 0)
                return BadRequest("Transfer company is required for transferred assets.");
            if (string.IsNullOrWhiteSpace(request.TransferEmpID))
                return BadRequest("Transfer employee is required for transferred assets.");
        }

        await repo.UpdateAssetStatusAsync(id, request, UserId, FullName);
        return NoContent();
    }

    [HttpDelete("{id:int}/status")]
    public async Task<IActionResult> RemoveStatus(int id, [FromBody] AssetStatusRemoveRequest request)
    {
        if (IsAuditor()) return Forbid();
        if (!IsAdmin())
        {
            var asset = await repo.GetAssetAsync(id);
            if (asset is null) return NotFound();
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(asset.CompanyID)) return Forbid();
        }
        await repo.RemoveAssetStatusAsync(id, request, UserId, FullName);
        return NoContent();
    }

    [HttpGet("{id:int}/depreciation-history")]
    public async Task<IActionResult> GetDepreciationHistory(int id)
    {
        if (!IsAdmin())
        {
            var asset = await repo.GetAssetAsync(id);
            if (asset is null) return NotFound();
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(asset.CompanyID)) return Forbid();
        }
        return Ok(await repo.GetDepreciationHistoryAsync(id));
    }

    [HttpGet("{id:int}/inventory-history")]
    public async Task<IActionResult> GetInventoryHistory(int id)
    {
        if (!IsAdmin())
        {
            var asset = await repo.GetAssetAsync(id);
            if (asset is null) return NotFound();
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(asset.CompanyID)) return Forbid();
        }
        return Ok(await repo.GetInventoryHistoryAsync(id));
    }

    [HttpGet("{id:int}/status-history")]
    public async Task<IActionResult> GetStatusHistory(int id)
    {
        if (!IsAdmin())
        {
            var asset = await repo.GetAssetAsync(id);
            if (asset is null) return NotFound();
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(UserId);
            if (!allowed.Contains(asset.CompanyID)) return Forbid();
        }
        return Ok(await repo.GetStatusHistoryAsync(id));
    }

    [HttpGet("codes")]
    public async Task<IActionResult> GetAssetCodes() =>
        Ok(await repo.GetAssetCodeListAsync());

    private static string? ValidateAssetRequest(AssetCreateRequest request)
    {
        if (request.BrandID <= 0) return "Brand is required.";
        if (string.IsNullOrWhiteSpace(request.Model)) return "Model is required.";
        if (request.OwnerID <= 0) return "Owner is required.";
        if (request.OwnerID != CompanyOwnerId && string.IsNullOrWhiteSpace(request.OwnerDesc))
            return "Owner description is required when the asset is not company-owned.";

        request.Model = request.Model.Trim();
        request.OwnerDesc = request.OwnerID == CompanyOwnerId
            ? null
            : request.OwnerDesc?.Trim();
        return null;
    }
}
