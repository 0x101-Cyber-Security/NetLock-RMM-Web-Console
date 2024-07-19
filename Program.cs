using Blazored.LocalStorage;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Hosting.StaticWebAssets;
using Microsoft.AspNetCore.Localization;
using MudBlazor;
using MudBlazor.Extensions;
using MudBlazor.Services;
using MySqlConnector;
using NetLock_Web_Console.Classes.Authentication;
using NetLock_Web_Console.Pages.Device_Management;
using Microsoft.Extensions.DependencyInjection;
using System.Reflection;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.Extensions.Configuration;
using LettuceEncrypt;
using System.Net;
using Org.BouncyCastle.Asn1.IsisMtt.Ocsp;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Builder;
using NetLock_Web_Console.Classes.MySQL;
using Microsoft.Extensions.Options;

var builder = WebApplication.CreateBuilder(args);

// Load configuration from appsettings.json
builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);

// Get UseHttps from config
var https = builder.Configuration.GetValue<bool>("Kestrel:Endpoint:Https:Enabled");
var https_force = builder.Configuration.GetValue<bool>("Kestrel:Endpoint:Https:Force");

var hsts = builder.Configuration.GetValue<bool>("Kestrel:Endpoint:Https:Hsts:Enabled");
var hsts_max_age = builder.Configuration.GetValue<int>("Kestrel:Endpoint:Https:Hsts:MaxAge");
var letsencrypt = builder.Configuration.GetValue<bool>("LettuceEncrypt:Enabled");
var cert_path = builder.Configuration["Kestrel:Endpoints:Https:Certificate:Path"];
var cert_password = builder.Configuration["Kestrel:Endpoints:Https:Certificate:Password"];

Console.WriteLine("Configuration loaded from appsettings.json");

// Output http port
Console.WriteLine($"Http Port: {builder.Configuration.GetValue<int>("Kestrel:Endpoint:Http:Port")}");
Console.WriteLine($"Https: {https}");
Console.WriteLine($"Https Port: {builder.Configuration.GetValue<int>("Kestrel:Endpoint:Https:Port")}");
Console.WriteLine($"Https (force): {https_force}");
Console.WriteLine($"Hsts: {hsts}");
Console.WriteLine($"Hsts Max Age: {hsts_max_age}");
Console.WriteLine($"LetsEncrypt: {letsencrypt}");

Console.WriteLine($"Custom Certificate Path: {cert_path}");
Console.WriteLine($"Custom Certificate Password: {cert_password}");

// Output mysql configuration
var mysqlConfig = builder.Configuration.GetSection("MySQL").Get<NetLock_Web_Console.Classes.MySQL.Config>();
Console.WriteLine($"MySQL Server: {mysqlConfig.Server}");
Console.WriteLine($"MySQL Port: {mysqlConfig.Port}");
Console.WriteLine($"MySQL Database: {mysqlConfig.Database}");
Console.WriteLine($"MySQL User: {mysqlConfig.User}");
Console.WriteLine($"MySQL Password: {mysqlConfig.Password}");
Console.WriteLine($"MySQL SSL Mode: {mysqlConfig.SslMode}");

// Output firewall status
bool microsoft_defender_firewall_status = NetLock_Web_Console.Classes.Microsoft_Defender_Firewall.Handler.Status();

if (microsoft_defender_firewall_status)
{
    Console.ForegroundColor = ConsoleColor.Green;
    Console.WriteLine("Microsoft Defender Firewall is enabled.");
}
else
{
    Console.ForegroundColor = ConsoleColor.Red;
    Console.WriteLine("Microsoft Defender Firewall is disabled. You should enable it for your own safety. NetLock adds firewall rules automatically according to your configuration.");
}

Console.ResetColor();

// Add firewall rule for HTTP
NetLock_Web_Console.Classes.Microsoft_Defender_Firewall.Handler.Rule_Inbound(builder.Configuration.GetValue<int>("Kestrel:Endpoint:Http:Port").ToString());
NetLock_Web_Console.Classes.Microsoft_Defender_Firewall.Handler.Rule_Outbound(builder.Configuration.GetValue<int>("Kestrel:Endpoint:Http:Port").ToString());

if (https)
{
    // Add firewall rule for HTTPS
    NetLock_Web_Console.Classes.Microsoft_Defender_Firewall.Handler.Rule_Inbound(builder.Configuration.GetValue<int>("Kestrel:Endpoint:Https:Port").ToString());
    NetLock_Web_Console.Classes.Microsoft_Defender_Firewall.Handler.Rule_Outbound(builder.Configuration.GetValue<int>("Kestrel:Endpoint:Https:Port").ToString());
    builder.Services.AddLettuceEncrypt();
}

builder.WebHost.UseKestrel(k =>
{
    IServiceProvider appServices = k.ApplicationServices;

    if (https)
    {
        k.Listen(IPAddress.Any, builder.Configuration.GetValue<int>("Kestrel:Endpoint:Https:Port"), o =>
        {
            if (letsencrypt)
            {
                o.UseHttps(h =>
                {
                    h.UseLettuceEncrypt(appServices);
                });
            }
            else
            {
                if (!string.IsNullOrEmpty(cert_password) && File.Exists(cert_path))
                {
                    o.UseHttps(cert_path, cert_password);
                }
                else
                {
                    Console.WriteLine("Default certificate file not found and Let's Encrypt certificate is not enabled.");
                }
            }
        });
    }

    k.Listen(IPAddress.Any, builder.Configuration.GetValue<int>("Kestrel:Endpoint:Http:Port"));
});

// Add services to the container.
/*if (useHttps)
    builder.Services.AddLettuceEncrypt();

builder.WebHost.UseKestrel(k =>
{
    IServiceProvider appServices = k.ApplicationServices;
    k.Listen(
        IPAddress.Any, 443,
        o => o.UseHttps(h =>
        {
            h.UseLettuceEncrypt(appServices);
        }));

    k.Listen(IPAddress.Any, 80);
});*/

// Check if database exists
if (!await Database.Check_Table_Existing())
{
    Console.WriteLine("Database tables do not exist. Creating database...");
    await Database.Execute_Installation_Script();
    Console.WriteLine("Database tables created.");
}
else
{
    Console.WriteLine("Database tables exist.");
}

builder.Services.AddAuthenticationCore();
builder.Services.AddBlazoredLocalStorage();
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddScoped<ProtectedSessionStorage>();
builder.Services.AddScoped<AuthenticationStateProvider, CustomAuthenticationStateProvider>();
builder.Services.AddMudServices();
builder.Services.AddOptions();
builder.Services.AddLocalization();
builder.Services.AddLocalization(options => { options.ResourcesPath = "Resources"; });
///increase size of textarea accepted value value
builder.Services.AddServerSideBlazor().AddHubOptions(x => x.MaximumReceiveMessageSize = 102400000);

var app = builder.Build();

var supportedCultures = new[] { "en-US", "de-DE" };
var localizationOptions = new RequestLocalizationOptions().SetDefaultCulture(supportedCultures[1]).AddSupportedCultures(supportedCultures).AddSupportedUICultures(supportedCultures);
app.UseRequestLocalization(localizationOptions);

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");

    if (hsts)
    {
        // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
        app.UseHsts();
    }
}

if (https_force)
{
    app.UseHttpsRedirection();
}

app.UseStaticFiles();
app.UseRouting();
app.MapBlazorHub();
app.MapFallbackToPage("/_Host");
app.Run();

Console.WriteLine("Server running!");