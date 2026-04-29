namespace AssetManagement.Api.Models;

public class ContactDto
{
    public int ContactID { get; set; }
    public string ContactName { get; set; } = string.Empty;
    public byte ContactTypeID { get; set; }
    public string? ContactPerson { get; set; }
    public string? ContactPersonEmail { get; set; }
    public string? FinancialContact { get; set; }
    public string? FinancialContactEmail { get; set; }
    public string Address { get; set; } = string.Empty;
    public string CountryID { get; set; } = string.Empty;
    public string Telephone1 { get; set; } = string.Empty;
    public string? Telephone2 { get; set; }
    public string? Mobile1 { get; set; }
    public string? Mobile2 { get; set; }
    public string? Fax1 { get; set; }
    public string? Fax2 { get; set; }
    public string? Remark { get; set; }
}

public class ContactCreateRequest
{
    public string ContactName { get; set; } = string.Empty;
    public byte ContactTypeID { get; set; }
    public string? ContactPerson { get; set; }
    public string? ContactPersonEmail { get; set; }
    public string? FinancialContact { get; set; }
    public string? FinancialContactEmail { get; set; }
    public string Address { get; set; } = string.Empty;
    public string CountryID { get; set; } = string.Empty;
    public string Telephone1 { get; set; } = string.Empty;
    public string? Telephone2 { get; set; }
    public string? Mobile1 { get; set; }
    public string? Mobile2 { get; set; }
    public string? Fax1 { get; set; }
    public string? Fax2 { get; set; }
    public string? Remark { get; set; }
}

public class ContactUpdateRequest : ContactCreateRequest
{
    public int ContactID { get; set; }
}

public class LogCreateRequest
{
    public short UserID { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string DomainUser { get; set; } = string.Empty;
    public string Computer { get; set; } = string.Empty;
    public byte LogSystemID { get; set; }
    public byte LogSeverityID { get; set; }
    public byte LogTypeID { get; set; }
    public string FormName { get; set; } = string.Empty;
    public string MethodName { get; set; } = string.Empty;
    public string LogDesc { get; set; } = string.Empty;
}
