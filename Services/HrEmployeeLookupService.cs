using System.Data;
using System.Text.RegularExpressions;
using AssetManagement.Api.Models;
using Dapper;
using Microsoft.Data.SqlClient;

namespace AssetManagement.Api.Services;

public interface IHrEmployeeLookupService
{
    Task<IEnumerable<HrEmployeeDto>> GetEmployeesByCompanyAsync(short companyId);
    Task<IEnumerable<HrEmployeeDto>> GetEmployeesByCompanyProfileAsync(string countryId, int companyProfileId);
}

public class HrEmployeeLookupService(IDbConnection db) : IHrEmployeeLookupService
{
    public async Task<IEnumerable<HrEmployeeDto>> GetEmployeesByCompanyAsync(short companyId)
    {
        var cfg = await db.QueryFirstOrDefaultAsync<(bool HRConnect, string? HRDatabase, int? HRCompanyProfileID)>(
            @"SELECT ctry.HRConnect, ctry.HRDatabase, cmp.HRCompanyProfileID
              FROM GSET.Companies cmp
              INNER JOIN GSET.Countries ctry ON ctry.CountryID = cmp.CountryID
              WHERE cmp.CompanyID = @CompanyID",
            new { CompanyID = companyId });

        if (!cfg.HRConnect || string.IsNullOrWhiteSpace(cfg.HRDatabase) || !cfg.HRCompanyProfileID.HasValue)
            return [];

        return await QueryEmployeesAsync(cfg.HRDatabase, cfg.HRCompanyProfileID.Value);
    }

    public async Task<IEnumerable<HrEmployeeDto>> GetEmployeesByCompanyProfileAsync(string countryId, int companyProfileId)
    {
        var dbName = await db.QueryFirstOrDefaultAsync<string?>(
            @"SELECT HRDatabase
              FROM GSET.Countries
              WHERE CountryID = @CountryID",
            new { CountryID = countryId });

        if (string.IsNullOrWhiteSpace(dbName))
            return [];

        return await QueryEmployeesAsync(dbName, companyProfileId);
    }

    private async Task<IEnumerable<HrEmployeeDto>> QueryEmployeesAsync(string? dbName, int companyProfileId)
    {
        if (string.IsNullOrWhiteSpace(dbName))
            return [];

        var normalizedDbName = dbName.Trim();
        if (!Regex.IsMatch(normalizedDbName, "^[A-Za-z0-9_]+$"))
            throw new InvalidOperationException("Country HRDatabase contains unsupported characters.");

        var sql = $@"SELECT
                        CAST(EmpId AS nvarchar(10)) AS EmpID,
                        FullName,
                        CompanyProfileId AS CompanyProfileID,
                        PrmName
                     FROM [{normalizedDbName}].[dbo].[vw_AssetsEmpList]
                     WHERE CompanyProfileId = @CompanyProfileID
                       AND LeaveDate IS NULL
                     ORDER BY FullName";

        try
        {
            return await db.QueryAsync<HrEmployeeDto>(sql, new { CompanyProfileID = companyProfileId });
        }
        catch (SqlException ex)
        {
            throw new InvalidOperationException(
                $"Could not read HR employees from database '{normalizedDbName}'. Verify country HRDatabase and SQL permissions.",
                ex);
        }
    }
}