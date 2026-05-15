using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class MaintenancesController(IMaintenanceRepository repo) : ControllerBase
{
    [HttpGet("asset/{assetId:int}")]
    public async Task<IActionResult> GetByAsset(int assetId) =>
        Ok(await repo.GetMaintenancesAsync(assetId));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] MaintenanceCreateRequest request) =>
        Ok(await repo.CreateMaintenanceAsync(request));

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
}
