using ClosedXML.Excel;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

namespace AssetManagement.Api.Services;

public static class ReportGeneratorService
{
    static ReportGeneratorService()
    {
        QuestPDF.Settings.License = LicenseType.Community;
    }

    // ── PDF ───────────────────────────────────────────────────────────────────

    public static byte[] GeneratePdf(
        string title,
        string subtitle,
        IReadOnlyList<string> headers,
        IReadOnlyList<IReadOnlyList<string?>> rows,
        bool landscape = true)
    {
        var doc = Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Size(landscape ? PageSizes.A4.Landscape() : PageSizes.A4);
                page.Margin(25);
                page.DefaultTextStyle(x => x.FontSize(8).FontFamily("Arial"));

                page.Header().Column(col =>
                {
                    col.Item().Row(row =>
                    {
                        row.RelativeItem().Column(inner =>
                        {
                            inner.Item().Text(title)
                                .FontSize(15).Bold().FontColor("#1f2b7b");
                            if (!string.IsNullOrEmpty(subtitle))
                                inner.Item().PaddingTop(2).Text(subtitle)
                                    .FontSize(8).FontColor("#6b7280");
                        });
                        row.ConstantItem(120).AlignRight().AlignBottom()
                            .Text($"Generated: {DateTime.Now:dd/MM/yyyy HH:mm}")
                            .FontSize(7).FontColor("#9ca3af");
                    });
                    col.Item().PaddingTop(6).LineHorizontal(1.5f).LineColor("#1f2b7b");
                });

                page.Content().PaddingTop(10).Table(table =>
                {
                    table.ColumnsDefinition(columns =>
                    {
                        foreach (var _ in headers)
                            columns.RelativeColumn();
                    });

                    table.Header(header =>
                    {
                        foreach (var h in headers)
                        {
                            header.Cell()
                                .Background("#1f2b7b")
                                .PaddingVertical(5).PaddingHorizontal(6)
                                .Text(h)
                                .FontColor(Colors.White)
                                .FontSize(7).Bold();
                        }
                    });

                    for (int i = 0; i < rows.Count; i++)
                    {
                        var row = rows[i];
                        string bg = i % 2 == 0 ? Colors.White : "#f9fafb";
                        foreach (var cell in row)
                        {
                            table.Cell()
                                .Background(bg)
                                .BorderBottom(0.4f).BorderColor("#e5e7eb")
                                .PaddingVertical(4).PaddingHorizontal(6)
                                .Text(cell ?? "—")
                                .FontSize(7.5f);
                        }
                    }
                });

                page.Footer().AlignCenter().Text(text =>
                {
                    text.Span("Page ").FontSize(7).FontColor("#9ca3af");
                    text.CurrentPageNumber().FontSize(7).FontColor("#9ca3af");
                    text.Span(" of ").FontSize(7).FontColor("#9ca3af");
                    text.TotalPages().FontSize(7).FontColor("#9ca3af");
                });
            });
        });

        return doc.GeneratePdf();
    }

    // ── Excel ─────────────────────────────────────────────────────────────────

    public static byte[] GenerateExcel(
        string sheetName,
        IReadOnlyList<string> headers,
        IReadOnlyList<IReadOnlyList<string?>> rows)
    {
        using var wb = new XLWorkbook();
        var ws = wb.Worksheets.Add(sheetName.Length > 31 ? sheetName[..31] : sheetName);

        var navyBlue = XLColor.FromHtml("#1f2b7b");
        var altRow   = XLColor.FromHtml("#f3f4f6");

        // Header row
        for (int c = 0; c < headers.Count; c++)
        {
            var cell = ws.Cell(1, c + 1);
            cell.Value = headers[c];
            cell.Style.Font.Bold = true;
            cell.Style.Font.FontColor = XLColor.White;
            cell.Style.Fill.BackgroundColor = navyBlue;
            cell.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            cell.Style.Alignment.Vertical   = XLAlignmentVerticalValues.Center;
            cell.Style.Border.BottomBorder  = XLBorderStyleValues.Medium;
            cell.Style.Border.BottomBorderColor = XLColor.White;
        }

        // Data rows
        for (int r = 0; r < rows.Count; r++)
        {
            for (int c = 0; c < rows[r].Count; c++)
            {
                var cell = ws.Cell(r + 2, c + 1);
                cell.Value = rows[r][c] ?? "—";
                if (r % 2 != 0)
                    cell.Style.Fill.BackgroundColor = altRow;
                cell.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                cell.Style.Border.BottomBorderColor = XLColor.FromHtml("#e5e7eb");
            }
        }

        ws.Row(1).Height = 22;
        ws.Columns().AdjustToContents(minWidth: 8, maxWidth: 50);

        if (rows.Count > 0)
            ws.Range(1, 1, rows.Count + 1, headers.Count).SetAutoFilter();

        using var ms = new MemoryStream();
        wb.SaveAs(ms);
        return ms.ToArray();
    }
}
