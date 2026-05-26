using System.Text;
using System.Text.Json;

namespace AssetManagement.Api.Services;

public class BrevoEmailService(HttpClient http, IConfiguration config) : IEmailService
{
    public async Task SendAsync(string toEmail, string toName, string subject, string htmlContent)
    {
        var apiKey = config["Brevo:ApiKey"]!;
        var senderEmail = config["Brevo:SenderEmail"]!;
        var senderName = config["Brevo:SenderName"]!;

        var payload = new
        {
            sender = new { name = senderName, email = senderEmail },
            to = new[] { new { email = toEmail, name = toName } },
            subject,
            htmlContent
        };

        using var req = new HttpRequestMessage(HttpMethod.Post, "https://api.brevo.com/v3/smtp/email");
        req.Headers.Add("api-key", apiKey);
        req.Content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

        var resp = await http.SendAsync(req);
        resp.EnsureSuccessStatusCode();
    }
}
