using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class WarrantiesController(IWarrantyRepository repo) : ControllerBase
{
    [HttpGet("asset/{assetId:int}")]
    public async Task<IActionResult> GetByAsset(int assetId) =>
        Ok(await repo.GetWarrantiesAsync(assetId));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] WarrantyCreateRequest request) =>
        Ok(await repo.CreateWarrantyAsync(request));

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] WarrantyUpdateRequest request)
    {
        request.WarntID = id;
        return Ok(await repo.UpdateWarrantyAsync(request));
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, [FromBody] WarrantyDeleteRequest request)
    {
        request.WarntID = id;
        await repo.DeleteWarrantyAsync(request);
        return NoContent();
    }
}
