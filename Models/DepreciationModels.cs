namespace AssetManagement.Api.Models;

public class DepreciationDto
{
    public int DepID { get; set; }
    public DateOnly DepreciationDate { get; set; }
    public string? Remark { get; set; }
    public short CreatedByUserID { get; set; }
    public string CreatedByFullName { get; set; } = string.Empty;
    public DateTime CreatedByDateTime { get; set; }
    public short CompanyID { get; set; }
}

public class DepreciationReportItemDto
{
    public int DepID { get; set; }
    public DateOnly DepreciationDate { get; set; }
    public string? Remark { get; set; }
    public string CreatedByFullName { get; set; } = string.Empty;
    public DateTime CreatedByDateTime { get; set; }
    public string AssetCode { get; set; } = string.Empty;
    public string AssetDesc { get; set; } = string.Empty;
    public byte DepreciationRate { get; set; }
    public double DepreciationValue { get; set; }
    public double NetBookValue { get; set; }
    public DateOnly? AccountingEntryDate { get; set; }
    public string? AccountingEntryJVNo { get; set; }
}

public class DepreciationLastDateDto
{
    public DateOnly? LastDepreciationDate { get; set; }
}

public class RunDepreciationRequest
{
    public DateOnly DepreciationDate { get; set; }
    public string? Remark { get; set; }
    public short CompanyID { get; set; }
}
