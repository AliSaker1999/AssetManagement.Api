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
    public async Task<IActionResult> Create([FromBody] MaintenanceCreateRequest request)
    {
        await repo.CreateMaintenanceAsync(request);
        return Ok();
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] MaintenanceUpdateRequest request)
    {
        request.MaintID = id;
        await repo.UpdateMaintenanceAsync(request);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        await repo.DeleteMaintenanceAsync(id);
        return NoContent();
    }
}
