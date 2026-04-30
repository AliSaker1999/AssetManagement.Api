using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class LookupsController(ILookupRepository repo) : ControllerBase
{
    [HttpGet("companies")]
    public async Task<IActionResult> GetCompanies() => Ok(await repo.GetCompaniesAsync());

    [HttpGet("categories")]
    public async Task<IActionResult> GetCategories() => Ok(await repo.GetCategoryTypesAsync());

    [HttpGet("groups")]
    public async Task<IActionResult> GetGroups() => Ok(await repo.GetGroupTypesAsync());

    [HttpGet("groups/full")]
    public async Task<IActionResult> GetGroupsFull() => Ok(await repo.GetGroupTypesFullAsync());

    [HttpGet("locations")]
    public async Task<IActionResult> GetLocations() => Ok(await repo.GetLocationTypesAsync());

    [HttpGet("location-details")]
    public async Task<IActionResult> GetLocationDetails([FromQuery] short? locationId = null) =>
        Ok(await repo.GetLocationDetailsAsync(locationId));

    [HttpGet("statuses")]
    public async Task<IActionResult> GetStatuses() => Ok(await repo.GetStatusTypesAsync());

    [HttpGet("currencies")]
    public async Task<IActionResult> GetCurrencies() => Ok(await repo.GetCurrenciesAsync());

    [HttpGet("countries")]
    public async Task<IActionResult> GetCountries() => Ok(await repo.GetCountriesAsync());

    [HttpGet("contact-types")]
    public async Task<IActionResult> GetContactTypes() => Ok(await repo.GetContactTypesAsync());

    [HttpGet("banks")]
    public async Task<IActionResult> GetBanks() => Ok(await repo.GetBanksAsync());

    [HttpGet("settings/at")]
    public async Task<IActionResult> GetAtSettings() => Ok(await repo.GetAtSettingsAsync());

    [HttpGet("settings/gset")]
    public async Task<IActionResult> GetGSetSettings() => Ok(await repo.GetGSetSettingsAsync());

    [HttpGet("asset-code")]
    public async Task<IActionResult> GetAssetCode([FromQuery] bool generate = false) =>
        Ok(new { assetCode = await repo.GetAssetCodeAsync(generate) });

    // Group Types CRUD
    [HttpPost("groups")]
    public async Task<IActionResult> CreateGroup([FromBody] GroupTypeCreateRequest request)
    {
        var created = await repo.CreateGroupTypeAsync(request);
        return Ok(created);
    }

    [HttpPut("groups/{id:int}")]
    public async Task<IActionResult> UpdateGroup(short id, [FromBody] GroupTypeUpdateRequest request)
    {
        request.GroupID = id;
        await repo.UpdateGroupTypeAsync(request);
        return NoContent();
    }

    [HttpDelete("groups/{id:int}")]
    public async Task<IActionResult> DeleteGroup(short id)
    {
        await repo.DeleteGroupTypeAsync(id);
        return NoContent();
    }

    // Category Types CRUD
    [HttpPost("categories")]
    public async Task<IActionResult> CreateCategory([FromBody] CategoryTypeCreateRequest request)
    {
        var created = await repo.CreateCategoryTypeAsync(request);
        return Ok(created);
    }

    [HttpPut("categories/{id:int}")]
    public async Task<IActionResult> UpdateCategory(short id, [FromBody] CategoryTypeUpdateRequest request)
    {
        request.CategoryID = id;
        await repo.UpdateCategoryTypeAsync(request);
        return NoContent();
    }

    [HttpDelete("categories/{id:int}")]
    public async Task<IActionResult> DeleteCategory(short id)
    {
        await repo.DeleteCategoryTypeAsync(id);
        return NoContent();
    }

    // Location Types CRUD
    [HttpPost("locations")]
    public async Task<IActionResult> CreateLocation([FromBody] LocationTypeCreateRequest request)
    {
        await repo.CreateLocationTypeAsync(request);
        return Ok();
    }

    [HttpPut("locations/{id:int}")]
    public async Task<IActionResult> UpdateLocation(short id, [FromBody] LocationTypeCreateRequest request)
    {
        await repo.UpdateLocationTypeAsync(id, request.Location);
        return NoContent();
    }

    [HttpDelete("locations/{id:int}")]
    public async Task<IActionResult> DeleteLocation(short id)
    {
        await repo.DeleteLocationTypeAsync(id);
        return NoContent();
    }

    // Location Details CRUD
    [HttpPost("location-details")]
    public async Task<IActionResult> CreateLocationDetail([FromBody] LocationDetailCreateRequest request)
    {
        await repo.CreateLocationDetailAsync(request);
        return Ok();
    }

    [HttpPut("location-details/{id:int}")]
    public async Task<IActionResult> UpdateLocationDetail(short id, [FromBody] LocationDetailUpdateRequest request)
    {
        request.LocDetailID = id;
        await repo.UpdateLocationDetailAsync(request);
        return NoContent();
    }

    [HttpDelete("location-details/{id:int}")]
    public async Task<IActionResult> DeleteLocationDetail(short id)
    {
        await repo.DeleteLocationDetailAsync(id);
        return NoContent();
    }

    // Settings
    [HttpPut("settings/at/{id:int}")]
    public async Task<IActionResult> UpdateAtSetting(byte id, [FromBody] string value)
    {
        await repo.UpdateAtSettingAsync(new SettingUpdateRequest { SetID = id, SetValue = value });
        return NoContent();
    }

    [HttpPut("settings/gset/{id:int}")]
    public async Task<IActionResult> UpdateGSetSetting(byte id, [FromBody] string value)
    {
        await repo.UpdateGSetSettingAsync(new SettingUpdateRequest { SetID = id, SetValue = value });
        return NoContent();
    }
}
