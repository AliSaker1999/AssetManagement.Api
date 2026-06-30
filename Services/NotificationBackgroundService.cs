using AssetManagement.Api.Hubs;
using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.SignalR;

namespace AssetManagement.Api.Services;

public class NotificationBackgroundService(
    IServiceProvider services,
    IHubContext<NotificationHub> hub,
    IConfiguration config,
    ILogger<NotificationBackgroundService> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken ct)
    {
        var intervalHours = config.GetValue<double>("Notification:BackgroundIntervalHours", 24);

        while (!ct.IsCancellationRequested)
        {
            try
            {
                await RunAsync(ct);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Notification background job failed");
            }

            await Task.Delay(TimeSpan.FromHours(intervalHours), ct);
        }
    }

    private async Task RunAsync(CancellationToken ct)
    {
        using var scope = services.CreateScope();
        var notifRepo = scope.ServiceProvider.GetRequiredService<INotificationRepository>();
        var emailSvc = scope.ServiceProvider.GetRequiredService<IEmailService>();

        var warrantyIntervals = await ParseIntervalsAsync(notifRepo, setId: 4);
        var maintenanceIntervals = await ParseIntervalsAsync(notifRepo, setId: 5);

        await ProcessWarrantiesAsync(notifRepo, emailSvc, warrantyIntervals, ct);
        await ProcessMaintenancesAsync(notifRepo, emailSvc, maintenanceIntervals, ct);
    }

    // ── Warranty ────────────────────────────────────────────────────────────

    private async Task ProcessWarrantiesAsync(
        INotificationRepository notifRepo,
        IEmailService emailSvc,
        int[] intervals,
        CancellationToken ct)
    {
        var pending = await notifRepo.GetPendingWarrantiesAsync();
        var grouped = pending.GroupBy(w => w.WarntID);

        foreach (var group in grouped)
        {
            if (ct.IsCancellationRequested) return;

            var w = group.First();
            var recipients = group
                .Select(x => new NotificationRecipient(x.RecipientUserID, x.RecipientEmailAddress))
                .DistinctBy(x => x.UserId)
                .ToList();

            if (recipients.Count == 0) continue;

            foreach (var days in intervals)
            {
                if (w.DaysLeft != days) continue;

                var label = days.ToString();
                if (await notifRepo.IsLoggedAsync("Warranty", w.WarntID, label)) continue;

                var subject = days == 0
                    ? $"Warranty Expires Today — {w.AssetCode}"
                    : $"Warranty Expiring in {days} Day(s) — {w.AssetCode}";

                var body = BuildWarrantyEmail(w, days);

                await SendAndPersistAsync(notifRepo, emailSvc,
                    "Warranty", w.WarntID, w.AssetID, w.CompanyID,
                    recipients,
                    subject, body, label);
            }
        }
    }

    // ── Maintenance ──────────────────────────────────────────────────────────

    private async Task ProcessMaintenancesAsync(
        INotificationRepository notifRepo,
        IEmailService emailSvc,
        int[] intervals,
        CancellationToken ct)
    {
        var pending = await notifRepo.GetPendingMaintenancesAsync();
        var grouped = pending.GroupBy(m => m.MaintID);

        foreach (var group in grouped)
        {
            if (ct.IsCancellationRequested) return;

            var m = group.First();
            var recipients = group
                .Select(x => new NotificationRecipient(x.RecipientUserID, x.RecipientEmailAddress))
                .DistinctBy(x => x.UserId)
                .ToList();

            if (recipients.Count == 0) continue;

            // Pre-end interval notifications
            foreach (var days in intervals)
            {
                if (m.DaysLeft != days) continue;

                var label = days.ToString();
                if (await notifRepo.IsLoggedAsync("Maintenance", m.MaintID, label)) continue;

                var subject = $"Maintenance Ending in {days} Day(s) — {m.AssetCode}";
                var body = BuildMaintenanceEmail(m, days);

                await SendAndPersistAsync(notifRepo, emailSvc,
                    "Maintenance", m.MaintID, m.AssetID, m.CompanyID,
                    recipients,
                    subject, body, label);
            }

            // Daily reminder once overdue (ToDate passed, still Under Maintenance)
            if (m.DaysLeft <= 0)
            {
                var dailyLabel = $"Daily-{DateOnly.FromDateTime(DateTime.Today):yyyy-MM-dd}";
                if (await notifRepo.IsLoggedAsync("Maintenance", m.MaintID, dailyLabel)) continue;

                var subject = $"Maintenance Overdue — Daily Reminder — {m.AssetCode}";
                var body = BuildMaintenanceOverdueEmail(m);

                await SendAndPersistAsync(notifRepo, emailSvc,
                    "Maintenance", m.MaintID, m.AssetID, m.CompanyID,
                    recipients,
                    subject, body, dailyLabel);
            }
        }
    }

    // ── Shared send + persist ────────────────────────────────────────────────

    private async Task SendAndPersistAsync(
        INotificationRepository notifRepo,
        IEmailService emailSvc,
        string type, int entityId, int assetId, short companyId,
        IReadOnlyCollection<NotificationRecipient> recipients,
        string subject, string htmlBody, string intervalLabel)
    {
        foreach (var recipient in recipients)
        {
            if (!string.IsNullOrWhiteSpace(recipient.EmailAddress))
            {
                try
                {
                    await emailSvc.SendAsync(recipient.EmailAddress, recipient.EmailAddress, subject, htmlBody);
                }
                catch (Exception ex)
                {
                    logger.LogWarning(ex, "Email send failed to {Email}", recipient.EmailAddress);
                }
            }

            var message = StripHtml(htmlBody);
            var notifId = await notifRepo.CreateAsync(recipient.UserId, companyId, type, entityId, assetId, message);

            var dto = new NotificationDto
            {
                NotifID = notifId,
                UserID = recipient.UserId,
                CompanyID = companyId,
                Type = type,
                EntityID = entityId,
                AssetID = assetId,
                Message = message,
                IsRead = false,
                CreatedAt = DateTime.Now
            };

            await hub.Clients.Group($"user-{recipient.UserId}")
                .SendAsync("ReceiveNotification", dto);
        }

        await notifRepo.LogNotificationAsync(type, entityId, intervalLabel);
    }

    private sealed record NotificationRecipient(short UserId, string? EmailAddress);

    // ── Email templates ──────────────────────────────────────────────────────

    private static string BuildWarrantyEmail(PendingWarrantyNotif w, int days)
    {
        var when = days == 0 ? "today" : $"in <strong>{days} day(s)</strong>";
        return $"""
            <p>The warranty <strong>"{w.WarrantyDesc}"</strong> for asset
            <strong>{w.AssetCode}</strong> ({w.AssetDesc}) expires {when}.</p>
            <p>Expiry date: <strong>{w.ToDate:dd MMM yyyy}</strong></p>
            <p>Please take the necessary action.</p>
            """;
    }

    private static string BuildMaintenanceEmail(PendingMaintenanceNotif m, int days) =>
        $"""
        <p>The scheduled maintenance for asset <strong>{m.AssetCode}</strong> ({m.AssetDesc})
        is ending in <strong>{days} day(s)</strong>.</p>
        <p>Maintenance end date: <strong>{m.ToDate:dd MMM yyyy}</strong></p>
        <p>Please ensure the return procedure is completed on time.</p>
        """;

    private static string BuildMaintenanceOverdueEmail(PendingMaintenanceNotif m) =>
        $"""
        <p><strong>Overdue maintenance reminder:</strong> Asset <strong>{m.AssetCode}</strong> ({m.AssetDesc})
        has been under maintenance since <strong>{m.FromDate:dd MMM yyyy}</strong>.</p>
        <p>The expected end date was <strong>{m.ToDate:dd MMM yyyy}</strong> but the asset has not been
        returned yet.</p>
        <p>Please update the maintenance status to <em>Return From Maintenance</em>.</p>
        """;

    // ── Helpers ──────────────────────────────────────────────────────────────

    private static async Task<int[]> ParseIntervalsAsync(INotificationRepository repo, byte setId)
    {
        var value = await repo.GetSettingValueAsync(setId) ?? string.Empty;
        return value.Split(',')
            .Select(s => s.Trim().ToLower())
            .Select(s => s switch
            {
                var v when v.Contains("week") => int.Parse(v.Split(' ')[0]) * 7,
                var v when v.StartsWith("same") => 0,
                var v => int.TryParse(v.Split(' ')[0], out var n) ? n : -1
            })
            .Where(n => n >= 0)
            .ToArray();
    }

    private static string StripHtml(string html) =>
        System.Text.RegularExpressions.Regex.Replace(html, "<.*?>", string.Empty).Trim();
}
