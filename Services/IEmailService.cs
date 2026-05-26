namespace AssetManagement.Api.Services;

public interface IEmailService
{
    Task SendAsync(string toEmail, string toName, string subject, string htmlContent);
}
