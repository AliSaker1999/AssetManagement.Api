using System.Security.Claims;
using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class InventoriesController(IInventoryRepository repo) : ControllerBase
{
    private short UserId => short.Parse(User.FindFirstValue("userId")!);
    private string FullName => User.FindFirstValue("fullName")!;

    [HttpGet("mode")]
    public async Task<IActionResult> GetMode() => Ok(await repo.GetInventoryModeAsync());

    [HttpGet("info")]
    public async Task<IActionResult> GetInfo() => Ok(await repo.GetInventoryInfoAsync());

    [HttpGet("finish-info")]
    public async Task<IActionResult> GetFinishInfo() => Ok(await repo.GetInventoryFinishInfoAsync());

    [HttpGet("last-date")]
    public async Task<IActionResult> GetLastDate() => Ok(await repo.GetInventoryLastDateAsync());

    [HttpPost("details")]
    public async Task<IActionResult> GetDetails([FromBody] InventoryReportFilterRequest filter) =>
        Ok(await repo.GetInventoriesDetailsListAsync(filter));

    [HttpGet("{id:int}/generated")]
    public async Task<IActionResult> GetGenerated(int id) =>
        Ok(await repo.GetInventoryGeneratedListAsync(id));

    [HttpGet("{id:int}/relocated")]
    public async Task<IActionResult> GetRelocated(int id) =>
        Ok(await repo.GetRelocatedAsync(id));

    [HttpPost("report")]
    public async Task<IActionResult> GetReport([FromBody] InventoryReportFilterRequest filter) =>
        Ok(await repo.GetInventoryReportAsync(filter));

    [HttpPost("start")]
    public async Task<IActionResult> Start([FromBody] InventoryStartRequest request)
    {
        await repo.StartInventoryAsync(request, UserId, FullName);
        return Ok();
    }

    [HttpPost("{id:int}/refresh")]
    public async Task<IActionResult> Refresh(int id)
    {
        await repo.RefreshInventoryAsync(id, UserId, FullName);
        return Ok();
    }

    [HttpPost("{id:int}/end")]
    public async Task<IActionResult> End(int id, [FromBody] InventoryEndRequest request)
    {
        await repo.EndInventoryAsync(id, request, UserId, FullName);
        return Ok();
    }

    [HttpPut("available/{invDetailId:int}")]
    public async Task<IActionResult> SetAvailable(int invDetailId, [FromBody] bool isAvailable)
    {
        await repo.SetAvailableAsync(invDetailId, isAvailable, UserId, FullName);
        return NoContent();
    }

    [HttpPut("{inventoryId:int}/available-all")]
    public async Task<IActionResult> SetAvailableAll(int inventoryId, [FromBody] bool isAvailable)
    {
        await repo.SetAvailableAllAssetsAsync(isAvailable, inventoryId, UserId, FullName);
        return NoContent();
    }

    [HttpPut("{inventoryId:int}/available-by-code")]
    public async Task<IActionResult> SetAvailableByCode(int inventoryId, [FromQuery] string assetCode, [FromBody] bool isAvailable)
    {
        await repo.SetAvailableByAssetCodeAsync(assetCode, isAvailable, inventoryId, UserId, FullName);
        return NoContent();
    }

    [HttpPut("relocate")]
    public async Task<IActionResult> Relocate([FromBody] InventoryRelocateRequest request)
    {
        await repo.UpdateRelocatedAsync(request, UserId, FullName);
        return NoContent();
    }
}
