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
    [HttpGet]
    public async Task<IActionResult> GetList() => Ok(await repo.GetContactsListAsync());

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
