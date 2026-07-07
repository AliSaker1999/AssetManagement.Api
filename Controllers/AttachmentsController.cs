using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AttachmentsController(IAttachmentRepository repo, ISettingsRepository settingsRepo, IConfiguration config) : ControllerBase
{
    private const byte AttachmentsPathSettingId = 1;
    private static readonly HashSet<string> BlockedExtensions = new(StringComparer.OrdinalIgnoreCase)
    {
        "csv", "txt", "gif", "webp"
    };

    private async Task<string> GetStoragePathAsync()
    {
        var dbPath = await settingsRepo.GetGeneralSettingValueAsync(AttachmentsPathSettingId);
        if (!string.IsNullOrWhiteSpace(dbPath)) return dbPath.Trim();
        return config["AttachmentsPath"] ?? "C:\\Attachments\\AssetFiles";
    }

    [HttpGet("asset/{assetId:int}")]
    public async Task<IActionResult> GetByAsset(int assetId) =>
        Ok(await repo.GetAttachmentsAsync(assetId));

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] AttachmentCreateRequest? request)
    {
        if (request is null)
            return BadRequest("Request body is required.");

        if (request.AssetID <= 0)
            return BadRequest("A valid asset ID is required.");

        if (string.IsNullOrWhiteSpace(request.AttDesc))
            return BadRequest("Attachment description is required.");

        if (string.IsNullOrWhiteSpace(request.AttFileName))
            return BadRequest("Attachment file name is required.");

        if (string.IsNullOrWhiteSpace(request.FileBase64))
            return BadRequest("File content is required.");

        string ext = (request.AttFileExt ?? string.Empty).Trim().TrimStart('.');
        if (string.IsNullOrWhiteSpace(ext))
            return BadRequest("Attachment extension is required.");

        if (BlockedExtensions.Contains(ext))
            return BadRequest("This file type is not allowed.");

        byte[] fileBytes;
        try
        {
            fileBytes = Convert.FromBase64String(request.FileBase64);
        }
        catch (FormatException)
        {
            return BadRequest("Invalid file content.");
        }

        string storedName = $"{Guid.NewGuid():N}.{ext}";

        string storagePath = await GetStoragePathAsync();
        Directory.CreateDirectory(storagePath);
        string filePath = Path.Combine(storagePath, storedName);
        await System.IO.File.WriteAllBytesAsync(filePath, fileBytes);

        var result = await repo.CreateAttachmentAsync(request, filePath);
        if (result is null)
        {
            System.IO.File.Delete(filePath);
            return StatusCode(500, "Failed to save attachment record.");
        }

        // Don't expose the server file path to the client
        result.FilePath = string.Empty;
        return Ok(result);
    }

    [HttpGet("{attId:int}/download")]
    public async Task<IActionResult> Download(int attId)
    {
        var att = await repo.GetByIdAsync(attId);
        if (att is null || !System.IO.File.Exists(att.FilePath))
            return NotFound();

        string mime = GetMimeType(att.AttFileExt);
        return PhysicalFile(att.FilePath, mime, att.AttFileName);
    }

    [HttpGet("{attId:int}/view")]
    public async Task<IActionResult> View(int attId)
    {
        var att = await repo.GetByIdAsync(attId);
        if (att is null || !System.IO.File.Exists(att.FilePath))
            return NotFound();

        string mime = GetMimeType(att.AttFileExt);
        return PhysicalFile(att.FilePath, mime);
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] AttachmentDeleteRequest request)
    {
        string? filePath = await repo.DeleteAttachmentAsync(request);
        if (!string.IsNullOrEmpty(filePath) && System.IO.File.Exists(filePath))
            System.IO.File.Delete(filePath);
        return NoContent();
    }

    private static string GetMimeType(string ext)
    {
        return (ext ?? string.Empty).Trim().TrimStart('.').ToLowerInvariant() switch
        {
            "pdf"  => "application/pdf",
            "png"  => "image/png",
            "jpg"  => "image/jpeg",
            "jpeg" => "image/jpeg",
            "bmp"  => "image/bmp",
            "svg"  => "image/svg+xml",
            "xlsx" => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            "xls"  => "application/vnd.ms-excel",
            "docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "doc"  => "application/msword",
            "pptx" => "application/vnd.openxmlformats-officedocument.presentationml.presentation",
            "ppt"  => "application/vnd.ms-powerpoint",
            _      => "application/octet-stream"
        };
    }
}
