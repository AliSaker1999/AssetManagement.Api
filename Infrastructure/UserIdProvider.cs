using System.Security.Claims;
using Microsoft.AspNetCore.SignalR;

namespace AssetManagement.Api.Infrastructure;

public class UserIdProvider : IUserIdProvider
{
    public string? GetUserId(HubConnectionContext connection)
        => connection.User?.FindFirstValue("userId");
}
