using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using AssetManagement.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class LookupsController(ILookupRepository repo, IPermissionService permissionService) : ControllerBase
{
    private static int NormalizePageSize(int pageSize) => pageSize is 20 or 30 ? pageSize : 10;

    private bool IsAdmin() =>
        User.Claims.FirstOrDefault(c => c.Type == "roleId")?.Value == "1";

    private bool IsAuditor() =>
        User.Claims.FirstOrDefault(c => c.Type == "roleId")?.Value == "2";

    private short GetUserId() =>
        IsAdmin() ? (short)0
        : short.TryParse(User.Claims.FirstOrDefault(c => c.Type == "userId")?.Value, out var id)
            ? id : (short)0;

    // Country CRUD (admin only)
    [HttpPost("countries")]
    public async Task<IActionResult> CreateCountry([FromBody] CountryCreateRequest request)
    {
        if (!IsAdmin()) return Forbid();
        if (string.IsNullOrWhiteSpace(request.CountryID) || request.CountryID.Length != 2)
            return BadRequest("Country ID must be exactly 2 characters.");
        if (string.IsNullOrWhiteSpace(request.Country)) return BadRequest("Country name is required.");
        if (string.IsNullOrWhiteSpace(request.Nationality)) return BadRequest("Nationality is required.");
        if (request.HRConnect && string.IsNullOrWhiteSpace(request.HRDatabase))
            return BadRequest("HRDatabase is required when HRConnect is enabled.");
        request.HRDatabase = request.HRConnect ? request.HRDatabase?.Trim() : null;
        var created = await repo.CreateCountryAsync(request);
        return Ok(created);
    }

    [HttpPut("countries/{id}")]
    public async Task<IActionResult> UpdateCountry(string id, [FromBody] CountryUpdateRequest request)
    {
        if (!IsAdmin()) return Forbid();
        request.CountryID = id.ToUpper();
        if (request.HRConnect && string.IsNullOrWhiteSpace(request.HRDatabase))
            return BadRequest("HRDatabase is required when HRConnect is enabled.");
        request.HRDatabase = request.HRConnect ? request.HRDatabase?.Trim() : null;
        await repo.UpdateCountryAsync(request);
        return NoContent();
    }

    [HttpPatch("countries/{id}/active")]
    public async Task<IActionResult> ToggleCountryActive(string id, [FromBody] bool active)
    {
        if (!IsAdmin()) return Forbid();
        await repo.ToggleCountryActiveAsync(id.ToUpper(), active);
        return NoContent();
    }

    // Company CRUD (admin + full-access; auditor = view only)
    [HttpPost("companies")]
    public async Task<IActionResult> CreateCompany([FromBody] CompanyCreateRequest request)
    {
        if (IsAuditor()) return Forbid();
        if (string.IsNullOrWhiteSpace(request.CompanyName)) return BadRequest("Company name is required.");
        if (string.IsNullOrWhiteSpace(request.CompanyAbbreviation)) return BadRequest("Abbreviation is required.");
        if (string.IsNullOrWhiteSpace(request.CountryID)) return BadRequest("Country is required.");

        var country = (await repo.GetCountriesAsync()).FirstOrDefault(c => c.CountryID.Trim().Equals(request.CountryID.Trim(), StringComparison.OrdinalIgnoreCase));
        if (country is null) return BadRequest("Invalid country.");
        if (country.HRConnect && !request.HRCompanyProfileID.HasValue)
            return BadRequest("HR company is required for countries with HRConnect enabled.");
        if (!country.HRConnect)
            request.HRCompanyProfileID = null;

        var created = await repo.CreateCompanyAsync(request);
        return Ok(created);
    }

    [HttpPut("companies/{id:int}")]
    public async Task<IActionResult> UpdateCompany(short id, [FromBody] CompanyUpdateRequest request)
    {
        if (IsAuditor()) return Forbid();
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(GetUserId());
            if (!allowed.Contains(id)) return Forbid();
        }

        var country = (await repo.GetCountriesAsync()).FirstOrDefault(c => c.CountryID.Trim().Equals(request.CountryID.Trim(), StringComparison.OrdinalIgnoreCase));
        if (country is null) return BadRequest("Invalid country.");
        if (country.HRConnect && !request.HRCompanyProfileID.HasValue)
            return BadRequest("HR company is required for countries with HRConnect enabled.");
        if (!country.HRConnect)
            request.HRCompanyProfileID = null;

        request.CompanyID = id;
        await repo.UpdateCompanyAsync(request);
        return NoContent();
    }

    [HttpDelete("companies/{id:int}")]
    public async Task<IActionResult> DeleteCompany(short id)
    {
        if (IsAuditor()) return Forbid();
        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(GetUserId());
            if (!allowed.Contains(id)) return Forbid();
        }
        await repo.DeleteCompanyAsync(id);
        return NoContent();
    }

    [HttpGet("companies")]
    public async Task<IActionResult> GetCompanies() => Ok(await repo.GetCompaniesAsync(GetUserId()));

    [HttpGet("categories")]
    public async Task<IActionResult> GetCategories() => Ok(await repo.GetCategoryTypesAsync());

    [HttpGet("categories/paginated")]
    public async Task<IActionResult> GetCategoriesPaginated([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 10)
    {
        pageNumber = Math.Max(1, pageNumber);
        pageSize = NormalizePageSize(pageSize);

        var all = (await repo.GetCategoryTypesAsync()).ToList();
        var skip = (pageNumber - 1) * pageSize;
        var data = all.Skip(skip).Take(pageSize).ToList();

        return Ok(new PaginatedResponse<CategoryTypeDto>
        {
            Data = data,
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = all.Count
        });
    }

    [HttpGet("groups")]
    public async Task<IActionResult> GetGroups() => Ok(await repo.GetGroupTypesAsync(GetUserId()));

    [HttpGet("groups/full")]
    public async Task<IActionResult> GetGroupsFull() => Ok(await repo.GetGroupTypesFullAsync(GetUserId()));

    [HttpGet("locations")]
    public async Task<IActionResult> GetLocations([FromQuery] short? companyId = null) =>
        Ok(await repo.GetLocationTypesAsync(GetUserId(), companyId));

    [HttpGet("location-details")]
    public async Task<IActionResult> GetLocationDetails([FromQuery] short? locationId = null) =>
        Ok(await repo.GetLocationDetailsAsync(GetUserId(), locationId));

    [HttpGet("statuses")]
    public async Task<IActionResult> GetStatuses() => Ok(await repo.GetStatusTypesAsync());

    [HttpGet("brands")]
    public async Task<IActionResult> GetBrands() => Ok(await repo.GetBrandTypesAsync());

    [HttpGet("owners")]
    public async Task<IActionResult> GetOwners() => Ok(await repo.GetOwnerTypesAsync());

    [HttpGet("currencies")]
    public async Task<IActionResult> GetCurrencies() => Ok(await repo.GetCurrenciesAsync());

    [HttpPost("brands")]
    public async Task<IActionResult> CreateBrand([FromBody] BrandTypeCreateRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.BrandDesc)) return BadRequest("Brand name is required.");
        var created = await repo.CreateBrandTypeAsync(request);
        return Ok(created);
    }

    [HttpPost("currencies")]
    public async Task<IActionResult> CreateCurrency([FromBody] CurrencyCreateRequest request)
    {
        if (!IsAdmin()) return Forbid();
        if (string.IsNullOrWhiteSpace(request.CurCode) || request.CurCode.Length != 3)
            return BadRequest("Currency code must be exactly 3 characters.");
        if (string.IsNullOrWhiteSpace(request.CurName)) return BadRequest("Currency name is required.");
        request.CurCode = request.CurCode.ToUpper();
        var created = await repo.CreateCurrencyAsync(request);
        return Ok(created);
    }

    [HttpPut("currencies/{code}")]
    public async Task<IActionResult> UpdateCurrency(string code, [FromBody] CurrencyUpdateRequest request)
    {
        if (!IsAdmin()) return Forbid();
        if (string.IsNullOrWhiteSpace(request.CurName)) return BadRequest("Currency name is required.");
        request.CurCode = code.ToUpper();
        await repo.UpdateCurrencyAsync(request);
        return NoContent();
    }

    [HttpDelete("currencies/{code}")]
    public async Task<IActionResult> DeleteCurrency(string code)
    {
        if (!IsAdmin()) return Forbid();
        await repo.DeleteCurrencyAsync(code.ToUpper());
        return NoContent();
    }

    [HttpGet("countries")]
    public async Task<IActionResult> GetCountries() => Ok(await repo.GetCountriesAsync(GetUserId()));

    [HttpGet("hr-databases")]
    public async Task<IActionResult> GetHrDatabases()
    {
        if (!IsAdmin()) return Forbid();
        return Ok(await repo.GetAvailableHrDatabasesAsync());
    }

    [HttpGet("hr-companies")]
    public async Task<IActionResult> GetHrCompanies([FromQuery] string countryId)
    {
        if (IsAuditor()) return Forbid();
        if (string.IsNullOrWhiteSpace(countryId)) return BadRequest("countryId is required.");
        return Ok(await repo.GetHrCompaniesByCountryAsync(countryId.ToUpper()));
    }

    [HttpGet("hr-employees")]
    public async Task<IActionResult> GetHrEmployees([FromQuery] short companyId)
    {
        if (IsAuditor()) return Forbid();
        if (companyId <= 0) return BadRequest("companyId is required.");

        if (!IsAdmin())
        {
            var allowed = await permissionService.GetAllowedCompanyIdsAsync(GetUserId());
            if (!allowed.Contains(companyId)) return Forbid();
        }

        return Ok(await repo.GetHrEmployeesByCompanyAsync(companyId));
    }

    [HttpGet("countries/paginated")]
    public async Task<IActionResult> GetCountriesPaginated([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 10)
    {
        pageNumber = Math.Max(1, pageNumber);
        pageSize = NormalizePageSize(pageSize);

        var all = (await repo.GetCountriesAsync(GetUserId())).ToList();
        var skip = (pageNumber - 1) * pageSize;
        var data = all.Skip(skip).Take(pageSize).ToList();

        return Ok(new PaginatedResponse<CountryDto>
        {
            Data = data,
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = all.Count
        });
    }

    [HttpGet("contact-types")]
    public async Task<IActionResult> GetContactTypes() => Ok(await repo.GetContactTypesAsync());

    [HttpGet("banks")]
    public async Task<IActionResult> GetBanks() => Ok(await repo.GetBanksAsync());

    [HttpGet("settings/at")]
    public async Task<IActionResult> GetAtSettings() => Ok(await repo.GetAtSettingsAsync());

    [HttpGet("settings/gset")]
    public async Task<IActionResult> GetGSetSettings() => Ok(await repo.GetGSetSettingsAsync());

    [HttpGet("asset-code")]
    public async Task<IActionResult> GetAssetCode([FromQuery] bool generate = false, [FromQuery] string countryId = "") =>
        Ok(new { assetCode = await repo.GetAssetCodeAsync(generate, countryId) });

    // Group Types CRUD
    [HttpPost("groups")]
    public async Task<IActionResult> CreateGroup([FromBody] GroupTypeCreateRequest request)
    {
        if (!IsAdmin()) return Forbid();
        var created = await repo.CreateGroupTypeAsync(request);
        return Ok(created);
    }

    [HttpPut("groups/{id:int}")]
    public async Task<IActionResult> UpdateGroup(short id, [FromBody] GroupTypeUpdateRequest request)
    {
        if (!IsAdmin()) return Forbid();
        request.GroupID = id;
        await repo.UpdateGroupTypeAsync(request);
        return NoContent();
    }

    [HttpDelete("groups/{id:int}")]
    public async Task<IActionResult> DeleteGroup(short id)
    {
        if (!IsAdmin()) return Forbid();
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
        await repo.UpdateLocationTypeAsync(id, request.Location, request.CompanyID);
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
