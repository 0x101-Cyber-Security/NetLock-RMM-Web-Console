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

var builder = WebApplication.CreateBuilder(args);

// Load configuration from appsettings.json
builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);

// Get UseHttps from config
var useHttps = builder.Configuration.GetValue<bool>("Kestrel:Endpoint:Https:Enabled");
var useLetsEncrypt = builder.Configuration.GetValue<bool>("LettuceEncrypt:Enabled");
var certPath = builder.Configuration["Kestrel:Endpoints:Https:Certificate:Path"];
var certPassword = builder.Configuration["Kestrel:Endpoints:Https:Certificate:Password"];

Console.WriteLine($"UseHttps: {useHttps}");
Console.WriteLine($"UseLetsEncrypt: {useLetsEncrypt}");
Console.WriteLine($"Certificate Path: {certPath}");
Console.WriteLine($"Certificate Password: {certPassword}");

if (useHttps)
    builder.Services.AddLettuceEncrypt();

// Configure Kestrel server options
builder.WebHost.UseKestrel(k =>
{
    IServiceProvider appServices = k.ApplicationServices;

    if (useHttps)
    {
        k.Listen(IPAddress.Any, 443, o =>
        {
            if (useLetsEncrypt)
            {
                o.UseHttps(h =>
                {
                    h.UseLettuceEncrypt(appServices);
                });
            }
            else
            {
                if (!string.IsNullOrEmpty(certPath) && File.Exists(certPath))
                {
                    o.UseHttps(certPath, certPassword);
                }
                else
                {
                    Console.WriteLine("Default certificate file not found and Let's Encrypt certificate is not enabled.");
                }
            }
        });
    }

    k.Listen(IPAddress.Any, 80);
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
var localizationOptions = new RequestLocalizationOptions()
    .SetDefaultCulture(supportedCultures[1])
    .AddSupportedCultures(supportedCultures)
    .AddSupportedUICultures(supportedCultures);

app.UseRequestLocalization(localizationOptions);

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

//app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();
