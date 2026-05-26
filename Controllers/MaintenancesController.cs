using System.Security.Claims;
using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class MaintenancesController(IMaintenanceRepository repo, IAssetRepository assetRepo) : ControllerBase
{
    private short UserId => short.Parse(User.FindFirstValue("userId")!);
    private string FullName => User.FindFirstValue("fullName")!;

    [HttpGet("active-count")]
    public async Task<IActionResult> GetActiveCount() =>
        Ok(await repo.GetActiveMaintenanceCountAsync());

    [HttpGet("asset/{assetId:int}")]
    public async Task<IActionResult> GetByAsset(int assetId) =>
        Ok(await repo.GetMaintenancesAsync(assetId));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] MaintenanceCreateRequest request)
    {
        var created = await repo.CreateMaintenanceAsync(request);
        if (created is not null)
        {
            var today = DateOnly.FromDateTime(DateTime.Today);
            await assetRepo.UpdateAssetStatusAsync(created.AssetID, new AssetStatusUpdateRequest
            {
                AssetStatusID = 8,
                AssetStatusDate = today,
                StatusID = 8,
                StatusDate = today,
                StatusSalePrice = 0
            }, UserId, FullName);
        }
        return Ok(created);
    }


    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] MaintenanceUpdateRequest request)
    {
        request.MaintID = id;
        return Ok(await repo.UpdateMaintenanceAsync(request));
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, [FromBody] MaintenanceDeleteRequest request)
    {
        request.MaintID = id;
        await repo.DeleteMaintenanceAsync(request);
        return NoContent();
    }

    [HttpPost("{id:int}/return")]
    public async Task<IActionResult> ReturnFromMaintenance(int id)
    {
        var maintenance = await repo.GetByIdAsync(id);

        if (maintenance is null)
            return NotFound();

        var asset = await assetRepo.GetAssetAsync(maintenance.AssetID);
        if (asset is null)
            return NotFound();

        if (asset.StatusID != 8)
            return BadRequest("Asset is not currently under maintenance.");

        var today = DateOnly.FromDateTime(DateTime.Today);
        await assetRepo.UpdateAssetStatusAsync(maintenance.AssetID, new AssetStatusUpdateRequest
        {
            AssetStatusID = 9,
            AssetStatusDate = today,
            StatusID = 9,
            StatusDate = today,
            StatusSalePrice = 0
        }, UserId, FullName);

        return NoContent();
    }
}
