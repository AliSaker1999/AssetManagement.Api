using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IAttachmentRepository
{
    Task<IEnumerable<AttachmentDto>> GetAttachmentsAsync(int assetId);
    Task<AttachmentDto?> GetByIdAsync(int attId);
    Task<AttachmentDto?> CreateAttachmentAsync(AttachmentCreateRequest request, string filePath);
    Task<string?> DeleteAttachmentAsync(AttachmentDeleteRequest request);
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

    public async Task<AttachmentDto?> GetByIdAsync(int attId)
    {
        return await db.QueryFirstOrDefaultAsync<AttachmentDto>(
            "AT.stpAttachmentByID",
            new { AttID = attId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<AttachmentDto?> CreateAttachmentAsync(AttachmentCreateRequest request, string filePath)
    {
        return await db.QueryFirstOrDefaultAsync<AttachmentDto>(
            "AT.stpAttachmentsI",
            new
            {
                request.AssetID,
                FilePath = filePath,
                request.AttDesc,
                request.AttFileName,
                request.AttFileExt,
                request.Remark
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<string?> DeleteAttachmentAsync(AttachmentDeleteRequest request)
    {
        var att = await GetByIdAsync(request.AttID);
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
        return att?.FilePath;
    }
}
