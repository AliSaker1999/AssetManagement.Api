using System.Data;
using AssetManagement.Api.Models;
using Dapper;

namespace AssetManagement.Api.Repositories;

public interface IContactRepository
{
    Task<IEnumerable<ContactDto>> GetContactsListAsync();
    Task<ContactDto?> GetContactAsync(int contactId);
    Task<IEnumerable<ContactDto>> GetContactsLookupAsync();
    Task<int> CreateContactAsync(ContactCreateRequest request);
    Task UpdateContactAsync(ContactUpdateRequest request);
    Task DeleteContactAsync(int contactId);
    Task CreateLogAsync(LogCreateRequest request);
}

public class ContactRepository(IDbConnection db) : IContactRepository
{
    public Task<IEnumerable<ContactDto>> GetContactsListAsync() =>
        db.QueryAsync<ContactDto>("GTBL.stpContactsList", commandType: CommandType.StoredProcedure);

    public Task<ContactDto?> GetContactAsync(int contactId) =>
        db.QueryFirstOrDefaultAsync<ContactDto>(
            "GTBL.stpContactsS",
            new { ContactID = contactId },
            commandType: CommandType.StoredProcedure);

    public Task<IEnumerable<ContactDto>> GetContactsLookupAsync() =>
        db.QueryAsync<ContactDto>("GTBL.stpGetContacts", commandType: CommandType.StoredProcedure);

    public async Task<int> CreateContactAsync(ContactCreateRequest r)
    {
        var result = await db.ExecuteScalarAsync<int>(
            "GTBL.stpContactsI",
            new
            {
                r.ContactName, r.ContactTypeID, r.ContactPerson, r.ContactPersonEmail,
                r.FinancialContact, r.FinancialContactEmail, r.Address, r.CountryID,
                r.Telephone1, r.Telephone2, r.Mobile1, r.Mobile2, r.Fax1, r.Fax2, r.Remark
            },
            commandType: CommandType.StoredProcedure);
        return result;
    }

    public Task UpdateContactAsync(ContactUpdateRequest r) =>
        db.ExecuteAsync(
            "GTBL.stpContactsU",
            new
            {
                r.ContactID, r.ContactName, r.ContactTypeID, r.ContactPerson, r.ContactPersonEmail,
                r.FinancialContact, r.FinancialContactEmail, r.Address, r.CountryID,
                r.Telephone1, r.Telephone2, r.Mobile1, r.Mobile2, r.Fax1, r.Fax2, r.Remark
            },
            commandType: CommandType.StoredProcedure);

    public Task DeleteContactAsync(int contactId) =>
        db.ExecuteAsync("GTBL.stpContactsD", new { ContactID = contactId }, commandType: CommandType.StoredProcedure);

    public Task CreateLogAsync(LogCreateRequest r) =>
        db.ExecuteAsync(
            "GTBL.stpLogI",
            new
            {
                r.UserID, r.FullName, DateTime = DateTime.Now, DomainUser = r.DomainUser,
                Computer = r.Computer, SQLHostName = Environment.MachineName,
                SQLLoggedName = "saAsset", SQLCurrentUser = "saAsset",
                r.LogSystemID, r.LogSeverityID, r.LogTypeID,
                r.FormName, r.MethodName, r.LogDesc, SentByEmail = false
            },
            commandType: CommandType.StoredProcedure);
}
