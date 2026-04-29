namespace AssetManagement.Api.Models;

public class CompanyDto
{
    public short CompanyID { get; set; }
    public string CompanyName { get; set; } = string.Empty;
    public string CompanyAbbreviation { get; set; } = string.Empty;
    public string CompanyPrmCurCode { get; set; } = string.Empty;
}

public class CategoryTypeDto
{
    public short CategoryID { get; set; }
    public string Category { get; set; } = string.Empty;
    public short GroupID { get; set; }
}

public class GroupTypeDto
{
    public short GroupID { get; set; }
    public string GroupName { get; set; } = string.Empty;
    public string Acronym { get; set; } = string.Empty;
    public byte DepreciationRate { get; set; }
    public string? AccountNo { get; set; }
    public bool AccountingExclusion { get; set; }
}

public class LocationTypeDto
{
    public short LocationID { get; set; }
    public string Location { get; set; } = string.Empty;
}

public class LocationDetailDto
{
    public short LocDetailID { get; set; }
    public short LocationID { get; set; }
    public string Floor { get; set; } = string.Empty;
    public string? Zone { get; set; }
    public string? Room { get; set; }
}

public class StatusTypeDto
{
    public byte StatusID { get; set; }
    public string Status { get; set; } = string.Empty;
}

public class CurrencyDto
{
    public string CurCode { get; set; } = string.Empty;
    public string CurName { get; set; } = string.Empty;
}

public class CountryDto
{
    public string CountryID { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
    public bool WorkingCountry { get; set; }
}

public class ContactTypeDto
{
    public byte ContactTypeID { get; set; }
    public string ContactType { get; set; } = string.Empty;
}

public class BankDto
{
    public short BankID { get; set; }
    public string BankName { get; set; } = string.Empty;
    public string AccountNo { get; set; } = string.Empty;
    public string Branch { get; set; } = string.Empty;
}

public class SettingDto
{
    public byte SetID { get; set; }
    public string SetValue { get; set; } = string.Empty;
    public string SetDescription { get; set; } = string.Empty;
    public string SetType { get; set; } = string.Empty;
}

public class AssetCodeDto
{
    public string AssetCode { get; set; } = string.Empty;
}

public class GroupTypeCreateRequest
{
    public string GroupName { get; set; } = string.Empty;
    public string Acronym { get; set; } = string.Empty;
    public byte DepreciationRate { get; set; }
    public string? AccountNo { get; set; }
    public bool AccountingExclusion { get; set; }
}

public class GroupTypeUpdateRequest : GroupTypeCreateRequest
{
    public short GroupID { get; set; }
}

public class CategoryTypeCreateRequest
{
    public string Category { get; set; } = string.Empty;
    public short GroupID { get; set; }
}

public class CategoryTypeUpdateRequest : CategoryTypeCreateRequest
{
    public short CategoryID { get; set; }
}

public class LocationTypeCreateRequest
{
    public string Location { get; set; } = string.Empty;
}

public class LocationDetailCreateRequest
{
    public short LocationID { get; set; }
    public string Floor { get; set; } = string.Empty;
    public string? Zone { get; set; }
    public string? Room { get; set; }
}

public class LocationDetailUpdateRequest : LocationDetailCreateRequest
{
    public short LocDetailID { get; set; }
}

public class SettingUpdateRequest
{
    public byte SetID { get; set; }
    public string SetValue { get; set; } = string.Empty;
}
