using System.Security.Claims;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class NotificationsController(INotificationRepository repo) : ControllerBase
{
    private short UserId => short.Parse(User.FindFirstValue("userId")!);

    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await repo.GetForUserAsync(UserId));

    [HttpGet("unread-count")]
    public async Task<IActionResult> GetUnreadCount()
    {
        var notifications = await repo.GetForUserAsync(UserId);
        return Ok(new { count = notifications.Count(n => !n.IsRead) });
    }

    [HttpPut("{id:int}/read")]
    public async Task<IActionResult> MarkRead(int id)
    {
        await repo.MarkReadAsync(id, UserId);
        return NoContent();
    }

    [HttpPut("read-all")]
    public async Task<IActionResult> MarkAllRead()
    {
        await repo.MarkAllReadAsync(UserId);
        return NoContent();
    }
}
