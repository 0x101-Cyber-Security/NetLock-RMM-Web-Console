using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using NetLock_Web_Console.Classes.Authentication;
using System.Security.Claims;

namespace NetLock_Web_Console.Classes.Authentication
{
    public class CustomAuthenticationStateProvider : AuthenticationStateProvider
    {
        private readonly ProtectedSessionStorage _sessionStorage;
        private static readonly ClaimsIdentity identity = new ClaimsIdentity();
        private ClaimsPrincipal _anonymous = new ClaimsPrincipal(identity);

        public CustomAuthenticationStateProvider(ProtectedSessionStorage sessionStorage)
        {
            _sessionStorage = sessionStorage;
        }

        public override async Task<AuthenticationState> GetAuthenticationStateAsync()
        {
            try
            {
                var userSessionStorageResult = await _sessionStorage.GetAsync<UserSession>("UserSession");
                var userSession = userSessionStorageResult.Success ? userSessionStorageResult.Value : null;

                if (userSession == null)
                    return await Task.FromResult(new AuthenticationState(_anonymous));

                var claimsPrincipal = new ClaimsPrincipal(new ClaimsIdentity(new List<Claim>
                {
                    new Claim(ClaimTypes.Name, userSession.UserName),
                    new Claim(ClaimTypes.Role, userSession.Role)
                }, "CustomAuth"));

                return await Task.FromResult(new AuthenticationState(claimsPrincipal));
            }
            catch (Exception ex)
            {
                return await Task.FromResult(new AuthenticationState(_anonymous));
            }
        }

        public async Task UpdateAuthentificationState(UserSession userSession, bool delete)
        {
            try
            {
                ClaimsPrincipal claimsPrincipal;

                if (userSession != null && delete == false)
                {
                    await _sessionStorage.SetAsync("UserSession", userSession);

                    claimsPrincipal = new ClaimsPrincipal(new ClaimsIdentity(new List<Claim>
                    {
                        new Claim(ClaimTypes.Name, userSession.UserName),
                        new Claim(ClaimTypes.Role, userSession.Role)
                    }));
                }
                else if (userSession != null && delete)
                {
                    await _sessionStorage.DeleteAsync("UserSession");
                    claimsPrincipal = _anonymous;
                }
                else
                {
                    await _sessionStorage.DeleteAsync("UserSession");
                    claimsPrincipal = _anonymous;
                }

                NotifyAuthenticationStateChanged(Task.FromResult(new AuthenticationState(claimsPrincipal)));
            }
            catch (Exception ex)
            {
                await _sessionStorage.DeleteAsync("UserSession");
                NotifyAuthenticationStateChanged(Task.FromResult(new AuthenticationState(_anonymous)));
            }
        }
    }
}
