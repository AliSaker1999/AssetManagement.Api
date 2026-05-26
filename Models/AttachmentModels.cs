namespace AssetManagement.Api.Models;

public class AttachmentDto
{
    public int AttID { get; set; }
    public int AssetID { get; set; }
    public string FilePath { get; set; } = string.Empty;
    public string AttDesc { get; set; } = string.Empty;
    public string AttFileName { get; set; } = string.Empty;
    public string AttFileExt { get; set; } = string.Empty;
    public string? Remark { get; set; }
}

public class AttachmentCreateRequest
{
    public int AssetID { get; set; }
    public string AttDesc { get; set; } = string.Empty;
    public string AttFileName { get; set; } = string.Empty;
    public string AttFileExt { get; set; } = string.Empty;
    public string? Remark { get; set; }
    public string? FileBase64 { get; set; }
}

public class AttachmentDeleteRequest
{
    public int AttID { get; set; }
    public int AssetID { get; set; }
    public string AttDesc { get; set; } = string.Empty;
    public string AttFileName { get; set; } = string.Empty;
    public string AttFileExt { get; set; } = string.Empty;
    public string? Remark { get; set; }
}
