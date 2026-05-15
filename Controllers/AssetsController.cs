using System.Security.Claims;
using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AssetsController(IAssetRepository repo) : ControllerBase
{
    private short UserId => short.Parse(User.FindFirstValue("userId")!);
    private string FullName => User.FindFirstValue("fullName")!;

    [HttpGet]
    public async Task<IActionResult> GetList([FromQuery] int? companyId = null) =>
        Ok(await repo.GetAssetsListAsync(companyId));

    [HttpGet("paginated")]
    public async Task<IActionResult> GetListPaginated([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 25, [FromQuery] int? companyId = null) =>
        Ok(await repo.GetAssetsListPaginatedAsync(pageNumber, pageSize, companyId));

    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id)
    {
        var asset = await repo.GetAssetAsync(id);
        return asset is null ? NotFound() : Ok(asset);
    }

    [HttpPost("report")]
    public async Task<IActionResult> GetReport([FromBody] AssetReportFilterRequest filter) =>
        Ok(await repo.GetAssetsReportAsync(filter));

    [HttpGet("not-depreciated")]
    public async Task<IActionResult> GetNotDepreciated() =>
        Ok(await repo.GetAssetsNotDepreciatedAsync());

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] AssetCreateRequest request)
    {
        var id = await repo.CreateAssetAsync(request, null);
        return Ok(new { AssetID = id });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] AssetUpdateRequest request)
    {
        request.AssetID = id;
        await repo.UpdateAssetAsync(request, null);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        try
        {
            await repo.DeleteAssetAsync(id);
            return NoContent();
        }
        catch (SqlException ex) when (ex.Number == 547)
        {
            return Conflict(new { message = "This asset cannot be deleted because it has related records (depreciation history, maintenance, etc.). Remove those records first or contact your administrator." });
        }
    }

    [HttpPut("{id:int}/status")]
    public async Task<IActionResult> UpdateStatus(int id, [FromBody] AssetStatusUpdateRequest request)
    {
        await repo.UpdateAssetStatusAsync(id, request, UserId, FullName);
        return NoContent();
    }

    [HttpDelete("{id:int}/status")]
    public async Task<IActionResult> RemoveStatus(int id, [FromBody] AssetStatusRemoveRequest request)
    {
        await repo.RemoveAssetStatusAsync(id, request, UserId, FullName);
        return NoContent();
    }

    [HttpGet("{id:int}/depreciation-history")]
    public async Task<IActionResult> GetDepreciationHistory(int id) =>
        Ok(await repo.GetDepreciationHistoryAsync(id));

    [HttpGet("{id:int}/inventory-history")]
    public async Task<IActionResult> GetInventoryHistory(int id) =>
        Ok(await repo.GetInventoryHistoryAsync(id));

    [HttpGet("{id:int}/status-history")]
    public async Task<IActionResult> GetStatusHistory(int id) =>
        Ok(await repo.GetStatusHistoryAsync(id));

    [HttpGet("codes")]
    public async Task<IActionResult> GetAssetCodes() =>
        Ok(await repo.GetAssetCodeListAsync());
}
