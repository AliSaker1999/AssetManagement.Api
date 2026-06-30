namespace AssetManagement.Api.Models;

public class UserListDto
{
    public short UserID { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public string EmailAddress { get; set; } = string.Empty;
    public byte RoleID { get; set; }
    public string RoleName { get; set; } = string.Empty;
}

public class UserCreateRequest
{
    public string UserName { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public string EmailAddress { get; set; } = string.Empty;
    public byte RoleID { get; set; }
}

public class UserUpdateRequest
{
    public short UserID { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string? Password { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string EmailAddress { get; set; } = string.Empty;
    public byte RoleID { get; set; }
}

public class UserPermissionDto
{
    public short UserID { get; set; }
    public string CountryID { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
    public short CompanyID { get; set; }
    public string CompanyName { get; set; } = string.Empty;
}

public class UserPermissionGrantRequest
{
    public string CountryID { get; set; } = string.Empty;
    public short CompanyID { get; set; }
}
