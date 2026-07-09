using AssetManagement.Api.Hubs;
using AssetManagement.Api.Models;
using AssetManagement.Api.Repositories;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Data.SqlClient;

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
                await RunWithRetryAsync(ct);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Notification background job failed");
            }

            await Task.Delay(TimeSpan.FromHours(intervalHours), ct);
        }
    }

    private async Task RunWithRetryAsync(CancellationToken ct)
    {
        var maxAttempts = Math.Max(1, config.GetValue<int>("Notification:SqlRetryCount", 3));
        var baseDelaySeconds = Math.Max(1, config.GetValue<int>("Notification:SqlRetryDelaySeconds", 5));

        for (var attempt = 1; attempt <= maxAttempts; attempt++)
        {
            ct.ThrowIfCancellationRequested();

            try
            {
                await RunOnceAsync(ct);
                return;
            }
            catch (Exception ex) when (IsTransientSqlException(ex) && attempt < maxAttempts)
            {
                var delay = TimeSpan.FromSeconds(baseDelaySeconds * attempt);
                logger.LogWarning(
                    ex,
                    "Transient SQL failure in notification job (attempt {Attempt}/{MaxAttempts}). Retrying in {DelaySeconds}s.",
                    attempt,
                    maxAttempts,
                    (int)delay.TotalSeconds);

                await Task.Delay(delay, ct);
            }
        }
    }

    private async Task RunOnceAsync(CancellationToken ct)
    {
        using var scope = services.CreateScope();
        var notifRepo = scope.ServiceProvider.GetRequiredService<INotificationRepository>();
        var emailSvc = scope.ServiceProvider.GetRequiredService<IEmailService>();

        var warrantyThresholdDays = await ParseSelectedIntervalDaysAsync(notifRepo, setId: 4, defaultLabel: "1 Week");
        var maintenanceThresholdDays = await ParseSelectedIntervalDaysAsync(notifRepo, setId: 5, defaultLabel: "1 Week");

        await ProcessWarrantiesAsync(notifRepo, emailSvc, warrantyThresholdDays, ct);
        await ProcessMaintenancesAsync(notifRepo, emailSvc, maintenanceThresholdDays, ct);
    }

    private static bool IsTransientSqlException(Exception ex)
    {
        if (ex is SqlException sqlEx)
        {
            return sqlEx.Number is -2 or 53 or 64 or 233 or 10053 or 10054 or 10060 or 40197 or 40501 or 40613 or 49918 or 49919 or 49920;
        }

        if (ex.InnerException is not null)
        {
            return IsTransientSqlException(ex.InnerException);
        }

        return false;
    }

    // ── Warranty ────────────────────────────────────────────────────────────

    private async Task ProcessWarrantiesAsync(
        INotificationRepository notifRepo,
        IEmailService emailSvc,
        int thresholdDays,
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

            // Send once every day starting from the selected threshold until expiry day.
            if (w.DaysLeft >= 0 && w.DaysLeft <= thresholdDays)
            {
                var label = BuildDailyLabel(thresholdDays);
                if (await notifRepo.IsLoggedAsync("Warranty", w.WarntID, label)) continue;

                var subject = w.DaysLeft == 0
                    ? $"Warranty Expires Today — {w.AssetCode}"
                    : $"Warranty Expiring in {w.DaysLeft} Day(s) — {w.AssetCode}";

                var body = BuildWarrantyEmail(w, w.DaysLeft);

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
        int thresholdDays,
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

            // Send once every day from selected threshold until returned from maintenance.
            if (m.DaysLeft <= thresholdDays)
            {
                var label = BuildDailyLabel(thresholdDays);
                if (await notifRepo.IsLoggedAsync("Maintenance", m.MaintID, label)) continue;

                var subject = m.DaysLeft <= 0
                    ? $"Maintenance Overdue — Daily Reminder — {m.AssetCode}"
                    : $"Maintenance Ending in {m.DaysLeft} Day(s) — {m.AssetCode}";
                var body = m.DaysLeft <= 0
                    ? BuildMaintenanceOverdueEmail(m)
                    : BuildMaintenanceEmail(m, m.DaysLeft);

                await SendAndPersistAsync(notifRepo, emailSvc,
                    "Maintenance", m.MaintID, m.AssetID, m.CompanyID,
                    recipients,
                    subject, body, label);
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

    private static async Task<int> ParseSelectedIntervalDaysAsync(INotificationRepository repo, byte setId, string defaultLabel)
    {
        var rawValue = await repo.GetSettingValueAsync(setId);
        var selected = string.IsNullOrWhiteSpace(rawValue) ? defaultLabel : rawValue.Trim();
        return ParseIntervalDays(selected) ?? ParseIntervalDays(defaultLabel) ?? 7;
    }

    private static int? ParseIntervalDays(string value)
    {
        var normalized = value.Trim().ToLowerInvariant();
        if (normalized.StartsWith("same")) return 0;

        var firstToken = normalized.Split(' ', StringSplitOptions.RemoveEmptyEntries).FirstOrDefault();
        if (!int.TryParse(firstToken, out var number)) return null;

        if (normalized.Contains("week")) return number * 7;
        if (normalized.Contains("day")) return number;
        return null;
    }

    private static string BuildDailyLabel(int thresholdDays) =>
        $"T{thresholdDays}-Daily-{DateOnly.FromDateTime(DateTime.Today):yyyy-MM-dd}";

    private static string StripHtml(string html) =>
        System.Text.RegularExpressions.Regex.Replace(html, "<.*?>", string.Empty).Trim();
}
