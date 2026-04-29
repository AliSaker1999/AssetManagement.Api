namespace AssetManagement.Api.Models;

public class LoginRequest
{
    public string UserName { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}

public class LoginResponse
{
    public string Token { get; set; } = string.Empty;
    public int UserId { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public bool Hr { get; set; }
    public bool Asset { get; set; }
    public bool Contact { get; set; }
}

public class UserDto
{
    public short UserID { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public bool HR { get; set; }
    public bool Asset { get; set; }
    public bool Contact { get; set; }
}

public class RoleDto
{
    public byte RoleID { get; set; }
    public string RoleName { get; set; } = string.Empty;
}
