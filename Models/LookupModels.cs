namespace AssetManagement.Api.Models;

public class CompanyDto
{
    public short CompanyID { get; set; }
    public string CompanyName { get; set; } = string.Empty;
    public string CompanyAbbreviation { get; set; } = string.Empty;
    public string CompanyPrmCurCode { get; set; } = string.Empty;
    public string CompanyScdCurCode { get; set; } = string.Empty;
    public string CountryID { get; set; } = string.Empty;
    public int? HRCompanyProfileID { get; set; }
}

public class HrCompanyProfileDto
{
    public int CompanyProfileID { get; set; }
    public string PrmName { get; set; } = string.Empty;
}

public class CategoryTypeDto
{
    public short CategoryID { get; set; }
    public string Category { get; set; } = string.Empty;
}

public class GroupTypeDto
{
    public short GroupID { get; set; }
    public string GroupName { get; set; } = string.Empty;
    public string Acronym { get; set; } = string.Empty;
    public byte DepreciationRate { get; set; }
    public string? AccountNo { get; set; }
    public bool AccountingExclusion { get; set; }
    public string CountryID { get; set; } = string.Empty;
}

public class LocationTypeDto
{
    public short LocationID { get; set; }
    public string Location { get; set; } = string.Empty;
    public short CompanyID { get; set; }
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

public class BrandTypeDto
{
    public short BrandID { get; set; }
    public string BrandDesc { get; set; } = string.Empty;
}

public class OwnerTypeDto
{
    public byte OwnerID { get; set; }
    public string OwnerDesc { get; set; } = string.Empty;
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
    public string Nationality { get; set; } = string.Empty;
    public string? ZipCode { get; set; }
    public bool WorkingCountry { get; set; }
    public bool ActiveCountry { get; set; }
    public int AssetCodeCounter { get; set; }
    public bool HRConnect { get; set; }
    public string? HRDatabase { get; set; }
}

public class CountryCreateRequest
{
    public string CountryID { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
    public string Nationality { get; set; } = string.Empty;
    public string? ZipCode { get; set; }
    public bool WorkingCountry { get; set; }
    public bool ActiveCountry { get; set; } = true;
    public bool HRConnect { get; set; }
    public string? HRDatabase { get; set; }
}

public class CountryUpdateRequest : CountryCreateRequest { }

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
    public string CountryID { get; set; } = string.Empty;
}

public class GroupTypeUpdateRequest : GroupTypeCreateRequest
{
    public short GroupID { get; set; }
}

public class CategoryTypeCreateRequest
{
    public string Category { get; set; } = string.Empty;
}

public class CategoryTypeUpdateRequest : CategoryTypeCreateRequest
{
    public short CategoryID { get; set; }
}

public class LocationTypeCreateRequest
{
    public string Location { get; set; } = string.Empty;
    public short CompanyID { get; set; }
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

public class CurrencyCreateRequest
{
    public string CurCode { get; set; } = string.Empty;
    public string CurName { get; set; } = string.Empty;
}

public class BrandTypeCreateRequest
{
    public string BrandDesc { get; set; } = string.Empty;
}

public class CurrencyUpdateRequest
{
    public string CurCode { get; set; } = string.Empty;
    public string CurName { get; set; } = string.Empty;
}

public class SettingUpdateRequest
{
    public byte SetID { get; set; }
    public string SetValue { get; set; } = string.Empty;
}

public class CompanyCreateRequest
{
    public string CompanyName { get; set; } = string.Empty;
    public string CompanyAbbreviation { get; set; } = string.Empty;
    public string CompanyPrmCurCode { get; set; } = string.Empty;
    public string CompanyScdCurCode { get; set; } = string.Empty;
    public string CountryID { get; set; } = string.Empty;
    public int? HRCompanyProfileID { get; set; }
}

public class CompanyUpdateRequest : CompanyCreateRequest
{
    public short CompanyID { get; set; }
}
