using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using AssetManagement.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AssetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ReportsController(IReportRepository repo) : ControllerBase
{
    // ── Helpers ───────────────────────────────────────────────────────────────

    private static string Loc(string location, string? floor, string? room, string? zone)
    {
        var parts = new[] { location, floor, room, zone }.Where(s => !string.IsNullOrWhiteSpace(s));
        return string.Join(" · ", parts);
    }

    private static string Fmt(DateOnly? d) => d.HasValue ? d.Value.ToString("dd/MM/yyyy") : "—";
    private static string Fmt(DateOnly d) => d.ToString("dd/MM/yyyy");
    private static string Fmt(DateTime d) => d.ToString("dd/MM/yyyy HH:mm");
    private static string Bool(bool v) => v ? "Yes" : "No";

    private FileContentResult MakeFile(byte[] data, string format, string name)
    {
        var date = DateTime.Now.ToString("yyyyMMdd");
        return format == "excel"
            ? File(data,
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                $"{name}_{date}.xlsx")
            : File(data, "application/pdf", $"{name}_{date}.pdf");
    }

    // ── Assets List ───────────────────────────────────────────────────────────

    [HttpPost("assets-list")]
    public async Task<IActionResult> AssetsListReport([FromBody] AssetsListReportRequest req)
    {
        var rows = (await repo.GetAssetsListAsync(req)).ToList();

        string[] headers = req.AdditionalDetail
            ? ["Company", "Code", "Description", "Category", "Group", "Location", "In Service", "Status", "Barcode", "Serial No.", "Last Inventory"]
            : ["Company", "Code", "Description", "Category", "Location", "In Service", "Status"];

        List<IReadOnlyList<string?>> data;

        if (req.TotalOnly)
        {
            data = [["Total assets", rows.Count.ToString(), "", "", "", "", ""]];
        }
        else
        {
            data = rows.Select(r =>
            {
                return (IReadOnlyList<string?>)(req.AdditionalDetail
                    ? [r.CompanyAbbreviation, r.AssetCode, r.AssetDesc, r.Category, r.GroupName,
                       Loc(r.Location, r.Floor, r.Room, r.Zone),
                       Fmt(r.InServiceDate), r.Status ?? "—", r.BarcodeNumber ?? "—",
                       r.SerialNumber ?? "—", Fmt(r.LastInventoryDateByItem)]
                    : [r.CompanyAbbreviation, r.AssetCode, r.AssetDesc, r.Category,
                       Loc(r.Location, r.Floor, r.Room, r.Zone),
                       Fmt(r.InServiceDate), r.Status ?? "—"]);
            }).ToList();
        }

        var subtitle = $"Total: {rows.Count} asset(s)";
        var bytes = req.Format == "excel"
            ? ReportGeneratorService.GenerateExcel("Assets List", headers, data)
            : ReportGeneratorService.GeneratePdf("Assets List Report", subtitle, headers, data);

        return MakeFile(bytes, req.Format, "AssetsListReport");
    }

    // ── Assets List Inventory ─────────────────────────────────────────────────

    [HttpPost("assets-list-inventory")]
    public async Task<IActionResult> AssetsListInventoryReport([FromBody] AssetsListInventoryReportRequest req)
    {
        var rows = (await repo.GetAssetsListInventoryAsync(req)).ToList();

        // Apply ListType filter
        IEnumerable<AssetsListInventoryReportRowDto> filtered = req.ListType switch
        {
            "NotAvailable" => rows.Where(r => !r.IsAvailable),
            "Relocated"    => rows.Where(r => r.Relocated),
            _              => rows
        };
        var list = filtered.ToList();

        string[] headers = ["Code", "Description", "Group", "Location",
                            "Available", "Relocated", "Relocated To", "Remark"];

        List<IReadOnlyList<string?>> data;

        if (req.TotalOnly)
        {
            var available   = list.Count(r => r.IsAvailable);
            var unavailable = list.Count(r => !r.IsAvailable);
            var relocated   = list.Count(r => r.Relocated);
            data = [
                ["Total assets", list.Count.ToString(), "", "", "", "", "", ""],
                ["Available",    available.ToString(),   "", "", "", "", "", ""],
                ["Not Available", unavailable.ToString(),"", "", "", "", "", ""],
                ["Relocated",    relocated.ToString(),   "", "", "", "", "", ""]
            ];
        }
        else
        {
            data = list.Select(r => (IReadOnlyList<string?>)[
                r.AssetCode, r.AssetDesc, r.GroupName,
                Loc(r.Location, r.Floor, r.Room, r.Zone),
                Bool(r.IsAvailable),
                Bool(r.Relocated),
                r.Relocated ? Loc(r.RelocatedLocation ?? "", r.RelocatedFloor, r.RelocatedRoom, r.RelocatedZone) : "—",
                r.Remark ?? "—"
            ]).ToList();
        }

        var subtitle = $"Total: {list.Count} asset(s)  |  Available: {list.Count(r => r.IsAvailable)}  |  Not Available: {list.Count(r => !r.IsAvailable)}";
        var bytes = req.Format == "excel"
            ? ReportGeneratorService.GenerateExcel("Assets List Inventory", headers, data)
            : ReportGeneratorService.GeneratePdf("Assets List Inventory Report", subtitle, headers, data);

        return MakeFile(bytes, req.Format, "AssetsListInventoryReport");
    }

    // ── Depreciation ──────────────────────────────────────────────────────────

    [HttpPost("depreciation")]
    public async Task<IActionResult> DepreciationReport([FromBody] DepreciationReportGenerateRequest req)
    {
        var rows = (await repo.GetDepreciationAsync(req.DepID)).ToList();

        string[] headers = ["Code", "Description", "Rate %", "Depreciation Value", "Net Book Value", "Acct. Entry Date", "JV No.", "Run Date"];

        var data = rows.Select(r => (IReadOnlyList<string?>)[
            r.AssetCode, r.AssetDesc,
            $"{r.DepreciationRate}%",
            r.DepreciationValue.ToString("N2"),
            r.NetBookValue.ToString("N2"),
            Fmt(r.AccountingEntryDate),
            r.AccountingEntryJVNo ?? "—",
            Fmt(r.DepreciationDate)
        ]).ToList();

        var first = rows.FirstOrDefault();
        var subtitle = first is not null
            ? $"Depreciation run on {Fmt(first.DepreciationDate)}  |  By: {first.CreatedByFullName}  |  Assets: {rows.Count}"
            : $"Assets: {rows.Count}";

        var bytes = req.Format == "excel"
            ? ReportGeneratorService.GenerateExcel("Depreciation", headers, data)
            : ReportGeneratorService.GeneratePdf("Depreciation Report", subtitle, headers, data);

        return MakeFile(bytes, req.Format, "DepreciationReport");
    }

    // ── Assets Not Depreciated ─────────────────────────────────────────────────

    [HttpPost("assets-not-depreciated")]
    public async Task<IActionResult> AssetsNotDepreciatedReport([FromBody] AssetsNotDepreciatedReportRequest req)
    {
        var rows = (await repo.GetAssetsNotDepreciatedAsync()).ToList();

        string[] headers = ["Code", "Description", "Category", "Group", "Location", "Donation", "Has Price", "Has Acct. Date"];

        var data = rows.Select(r => (IReadOnlyList<string?>)[
            r.AssetCode, r.AssetDesc, r.Category, r.GroupName,
            Loc(r.Location, r.Floor, r.Room, r.Zone),
            Bool(r.Donation), r.PriceExist, r.AcctEntryDateExist
        ]).ToList();

        var subtitle = $"Total: {rows.Count} asset(s) pending depreciation setup";

        var bytes = req.Format == "excel"
            ? ReportGeneratorService.GenerateExcel("Assets Not Depreciated", headers, data)
            : ReportGeneratorService.GeneratePdf("Assets Not Depreciated Report", subtitle, headers, data);

        return MakeFile(bytes, req.Format, "AssetsNotDepreciatedReport");
    }

    // ── Preview Endpoints (return JSON for in-page viewing) ───────────────────

    [HttpPost("assets-list/preview")]
    public async Task<IActionResult> AssetsListPreview([FromBody] AssetsListReportRequest req)
    {
        var rows = (await repo.GetAssetsListAsync(req)).ToList();

        string[] headers = req.AdditionalDetail
            ? ["Company", "Code", "Description", "Category", "Group", "Location", "In Service", "Status", "Barcode", "Serial No.", "Last Inventory"]
            : ["Company", "Code", "Description", "Category", "Location", "In Service", "Status"];

        List<string?[]> data;
        if (req.TotalOnly)
        {
            data = [["Total assets", rows.Count.ToString(), "", "", "", "", ""]];
        }
        else
        {
            data = rows.Select(r => req.AdditionalDetail
                ? (string?[])[r.CompanyAbbreviation, r.AssetCode, r.AssetDesc, r.Category, r.GroupName,
                   Loc(r.Location, r.Floor, r.Room, r.Zone),
                   Fmt(r.InServiceDate), r.Status ?? "—", r.BarcodeNumber ?? "—",
                   r.SerialNumber ?? "—", Fmt(r.LastInventoryDateByItem)]
                : (string?[])[r.CompanyAbbreviation, r.AssetCode, r.AssetDesc, r.Category,
                   Loc(r.Location, r.Floor, r.Room, r.Zone),
                   Fmt(r.InServiceDate), r.Status ?? "—"]
            ).ToList();
        }

        return Ok(new ReportPreviewDto
        {
            Title    = "Assets List Report",
            Subtitle = $"Total: {rows.Count} asset(s)",
            Headers  = headers,
            Rows     = data,
            TotalCount = rows.Count
        });
    }

    [HttpPost("assets-list-inventory/preview")]
    public async Task<IActionResult> AssetsListInventoryPreview([FromBody] AssetsListInventoryReportRequest req)
    {
        var rows = (await repo.GetAssetsListInventoryAsync(req)).ToList();
        IEnumerable<AssetsListInventoryReportRowDto> filtered = req.ListType switch
        {
            "NotAvailable" => rows.Where(r => !r.IsAvailable),
            "Relocated"    => rows.Where(r => r.Relocated),
            _              => rows
        };
        var list = filtered.ToList();

        string[] headers = ["Code", "Description", "Group", "Location", "Available", "Relocated", "Relocated To", "Remark"];

        List<string?[]> data;
        if (req.TotalOnly)
        {
            data = [
                ["Total assets",  list.Count.ToString(),                      "", "", "", "", "", ""],
                ["Available",     list.Count(r => r.IsAvailable).ToString(),  "", "", "", "", "", ""],
                ["Not Available", list.Count(r => !r.IsAvailable).ToString(), "", "", "", "", "", ""],
                ["Relocated",     list.Count(r => r.Relocated).ToString(),    "", "", "", "", "", ""]
            ];
        }
        else
        {
            data = list.Select(r => (string?[])[
                r.AssetCode, r.AssetDesc, r.GroupName,
                Loc(r.Location, r.Floor, r.Room, r.Zone),
                Bool(r.IsAvailable), Bool(r.Relocated),
                r.Relocated ? Loc(r.RelocatedLocation ?? "", r.RelocatedFloor, r.RelocatedRoom, r.RelocatedZone) : "—",
                r.Remark ?? "—"
            ]).ToList();
        }

        return Ok(new ReportPreviewDto
        {
            Title    = "Assets List Inventory Report",
            Subtitle = $"Total: {list.Count}  |  Available: {list.Count(r => r.IsAvailable)}  |  Not Available: {list.Count(r => !r.IsAvailable)}",
            Headers  = headers,
            Rows     = data,
            TotalCount = list.Count
        });
    }

    [HttpPost("depreciation/preview")]
    public async Task<IActionResult> DepreciationPreview([FromBody] DepreciationReportGenerateRequest req)
    {
        var rows = (await repo.GetDepreciationAsync(req.DepID)).ToList();

        string[] headers = ["Code", "Description", "Rate %", "Depreciation Value", "Net Book Value", "Acct. Entry Date", "JV No.", "Run Date"];

        var data = rows.Select(r => (string?[])[
            r.AssetCode, r.AssetDesc,
            $"{r.DepreciationRate}%",
            r.DepreciationValue.ToString("N2"),
            r.NetBookValue.ToString("N2"),
            Fmt(r.AccountingEntryDate),
            r.AccountingEntryJVNo ?? "—",
            Fmt(r.DepreciationDate)
        ]).ToList();

        var first = rows.FirstOrDefault();
        return Ok(new ReportPreviewDto
        {
            Title    = "Depreciation Report",
            Subtitle = first is not null
                ? $"Run on {Fmt(first.DepreciationDate)}  |  By: {first.CreatedByFullName}  |  Assets: {rows.Count}"
                : $"Assets: {rows.Count}",
            Headers    = headers,
            Rows       = data,
            TotalCount = rows.Count
        });
    }

    [HttpPost("assets-not-depreciated/preview")]
    public async Task<IActionResult> AssetsNotDepreciatedPreview([FromBody] AssetsNotDepreciatedReportRequest req)
    {
        var rows = (await repo.GetAssetsNotDepreciatedAsync()).ToList();

        string[] headers = ["Code", "Description", "Category", "Group", "Location", "Donation", "Has Price", "Has Acct. Date"];

        var data = rows.Select(r => (string?[])[
            r.AssetCode, r.AssetDesc, r.Category, r.GroupName,
            Loc(r.Location, r.Floor, r.Room, r.Zone),
            Bool(r.Donation), r.PriceExist, r.AcctEntryDateExist
        ]).ToList();

        return Ok(new ReportPreviewDto
        {
            Title      = "Assets Not Depreciated Report",
            Subtitle   = $"Total: {rows.Count} asset(s) pending depreciation setup",
            Headers    = headers,
            Rows       = data,
            TotalCount = rows.Count
        });
    }
}
