using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using AssetManagement.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController(IAuthRepository authRepo, JwtService jwtService) : ControllerBase
{
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.UserName))
            return BadRequest("Username is required.");
        if (string.IsNullOrWhiteSpace(request.Password))
            return BadRequest("Password is required.");

        var user = await authRepo.GetLoginUserAsync(request.UserName.Trim(), request.Password);
        if (user is null)
            return Unauthorized("Invalid username or password.");

        var token = jwtService.GenerateToken(user);

        return Ok(new LoginResponse
        {
            Token = token,
            UserId = user.UserID,
            UserName = user.UserName,
            FullName = user.FullName,
            RoleId = user.RoleID
        });
    }
}
