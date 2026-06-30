using System.Text;
using AssetManagement.Api.Hubs;
using Microsoft.AspNetCore.SignalR;
using AssetManagement.Api.Infrastructure;
using AssetManagement.Api.Repositories;
using AssetManagement.Api.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Data.SqlClient;
using Microsoft.IdentityModel.Tokens;
using Scalar.AspNetCore;
using System.Data;
using Dapper;

var builder = WebApplication.CreateBuilder(args);

SqlMapper.AddTypeHandler(new DateOnlyHandler());
SqlMapper.AddTypeHandler(new NullableDateOnlyHandler());

builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddSignalR();
builder.Services.AddSingleton<IUserIdProvider, UserIdProvider>();

// CORS — AllowCredentials required for SignalR
var allowedOrigins = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? [];
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
        policy.WithOrigins(allowedOrigins)
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials());
});

// Dapper / SQL connection (transient per request)
builder.Services.AddTransient<IDbConnection>(_ =>
    new SqlConnection(builder.Configuration.GetConnectionString("DefaultConnection")));

// JWT
var jwtKey = builder.Configuration["Jwt:Key"]!;
var jwtIssuer = builder.Configuration["Jwt:Issuer"]!;
var jwtAudience = builder.Configuration["Jwt:Audience"]!;

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtIssuer,
            ValidAudience = jwtAudience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };

        // Allow SignalR to receive the JWT from the query string
        options.Events = new JwtBearerEvents
        {
            OnMessageReceived = ctx =>
            {
                var token = ctx.Request.Query["access_token"];
                if (!string.IsNullOrEmpty(token) && ctx.Request.Path.StartsWithSegments("/hubs"))
                    ctx.Token = token;
                return Task.CompletedTask;
            }
        };
    });

builder.Services.AddAuthorization();

// Services
builder.Services.AddSingleton<JwtService>();
builder.Services.AddScoped<IPermissionService, PermissionService>();
builder.Services.AddHttpClient<IEmailService, BrevoEmailService>();
builder.Services.AddHostedService<NotificationBackgroundService>();

// Repositories
builder.Services.AddScoped<IAuthRepository, AuthRepository>();
builder.Services.AddScoped<IAssetRepository, AssetRepository>();
builder.Services.AddScoped<IInventoryRepository, InventoryRepository>();
builder.Services.AddScoped<IDepreciationRepository, DepreciationRepository>();
builder.Services.AddScoped<IMaintenanceRepository, MaintenanceRepository>();
builder.Services.AddScoped<IWarrantyRepository, WarrantyRepository>();
builder.Services.AddScoped<IAttachmentRepository, AttachmentRepository>();
builder.Services.AddScoped<ISettingsRepository, SettingsRepository>();
builder.Services.AddScoped<IContactRepository, ContactRepository>();
builder.Services.AddScoped<ILookupRepository, LookupRepository>();
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<INotificationRepository, NotificationRepository>();
builder.Services.AddScoped<IReportRepository, ReportRepository>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

app.UseCors();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.MapHub<NotificationHub>("/hubs/notifications");

// // Startup email test — remove once API key is confirmed
// {
//     using var scope = app.Services.CreateScope();
//     var emailSvc = scope.ServiceProvider.GetRequiredService<IEmailService>();
//     try
//     {
//         await emailSvc.SendAsync(
//             "alisaker1999@hotmail.com", "Ali Saker",
//             "Asset Management — Brevo API Key Test",
//             "<p>If you received this, the Brevo API key is working correctly.</p>");
//         app.Logger.LogInformation("Startup test email sent successfully.");
//     }
//     catch (Exception ex)
//     {
//         app.Logger.LogWarning(ex, "Startup test email failed — check Brevo:ApiKey in appsettings.json.");
//     }
// }

app.Run();
