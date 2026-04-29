using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AttachmentsController(IAttachmentRepository repo) : ControllerBase
{
    [HttpGet("asset/{assetId:int}")]
    public async Task<IActionResult> GetByAsset(int assetId) =>
        Ok(await repo.GetAttachmentsAsync(assetId));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] AttachmentCreateRequest request)
    {
        var result = await repo.CreateAttachmentAsync(request);
        return Ok(result);
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] AttachmentDeleteRequest request)
    {
        await repo.DeleteAttachmentAsync(request);
        return NoContent();
    }
}
