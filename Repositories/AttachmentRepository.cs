using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IAttachmentRepository
{
    Task<IEnumerable<AttachmentDto>> GetAttachmentsAsync(int assetId);
    Task<AttachmentDto?> CreateAttachmentAsync(AttachmentCreateRequest request);
    Task DeleteAttachmentAsync(AttachmentDeleteRequest request);
}

public class AttachmentRepository(IDbConnection db) : IAttachmentRepository
{
    public async Task<IEnumerable<AttachmentDto>> GetAttachmentsAsync(int assetId)
    {
        return await db.QueryAsync<AttachmentDto>(
            "AT.stpAttachmentsS",
            new { AssetID = assetId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<AttachmentDto?> CreateAttachmentAsync(AttachmentCreateRequest request)
    {
        byte[]? fileBytes = request.FileBase64 is null ? null : Convert.FromBase64String(request.FileBase64);
        return await db.QueryFirstOrDefaultAsync<AttachmentDto>(
            "AT.stpAttachmentsI",
            new
            {
                request.AssetID,
                Attachment = fileBytes,
                request.AttDesc,
                request.AttFileName,
                request.AttFileExt,
                request.Remark
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task DeleteAttachmentAsync(AttachmentDeleteRequest request)
    {
        await db.ExecuteAsync(
            "AT.stpAttachmentsD",
            new
            {
                Original_AttID = request.AttID,
                Original_AssetID = request.AssetID,
                Original_AttDesc = request.AttDesc,
                Original_AttFileName = request.AttFileName,
                Original_AttFileExt = request.AttFileExt,
                IsNull_Remark = request.Remark is null ? 1 : 0,
                Original_Remark = request.Remark
            },
            commandType: CommandType.StoredProcedure);
    }
}
