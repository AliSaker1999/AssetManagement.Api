using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ContactsController(IContactRepository repo) : ControllerBase
{
    private static int NormalizePageSize(int pageSize) => pageSize is 20 or 30 ? pageSize : 10;

    [HttpGet]
    public async Task<IActionResult> GetList() => Ok(await repo.GetContactsListAsync());

    [HttpGet("paginated")]
    public async Task<IActionResult> GetListPaginated([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 10)
    {
        pageNumber = Math.Max(1, pageNumber);
        pageSize = NormalizePageSize(pageSize);

        var all = (await repo.GetContactsListAsync()).ToList();
        var skip = (pageNumber - 1) * pageSize;
        var data = all.Skip(skip).Take(pageSize).ToList();

        return Ok(new PaginatedResponse<ContactDto>
        {
            Data = data,
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = all.Count
        });
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id)
    {
        var contact = await repo.GetContactAsync(id);
        return contact is null ? NotFound() : Ok(contact);
    }

    [HttpGet("lookup")]
    public async Task<IActionResult> GetLookup() => Ok(await repo.GetContactsLookupAsync());

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] ContactCreateRequest request)
    {
        var id = await repo.CreateContactAsync(request);
        return Ok(new { ContactID = id });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] ContactUpdateRequest request)
    {
        request.ContactID = id;
        await repo.UpdateContactAsync(request);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        await repo.DeleteContactAsync(id);
        return NoContent();
    }

    [HttpPost("log")]
    public async Task<IActionResult> CreateLog([FromBody] LogCreateRequest request)
    {
        await repo.CreateLogAsync(request);
        return Ok();
    }
}
