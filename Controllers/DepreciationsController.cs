using System.Security.Claims;
using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class DepreciationsController(IDepreciationRepository repo) : ControllerBase
{
    private short UserId => short.Parse(User.FindFirstValue("userId")!);
    private string FullName => User.FindFirstValue("fullName")!;

    [HttpGet]
    public async Task<IActionResult> GetAll() => Ok(await repo.GetDepreciationsAsync());

    [HttpGet("{id:int}/report")]
    public async Task<IActionResult> GetReport(int id) =>
        Ok(await repo.GetDepreciationReportAsync(id));

    [HttpGet("last-date")]
    public async Task<IActionResult> GetLastDate() => Ok(await repo.GetLastDepreciationDateAsync());

    [HttpGet("not-depreciated")]
    public async Task<IActionResult> GetNotDepreciated() => Ok(await repo.GetAssetsNotDepreciatedAsync());

    [HttpPost("run")]
    public async Task<IActionResult> Run([FromBody] RunDepreciationRequest request)
    {
        await repo.RunDepreciationAsync(request, UserId, FullName);
        return Ok();
    }

    [HttpDelete("last")]
    public async Task<IActionResult> DeleteLast()
    {
        await repo.DeleteLastDepreciationAsync(UserId, FullName);
        return NoContent();
    }
}
