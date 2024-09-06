using System.Text.Json;

namespace Helper
{
    public class NetLock_Remote_Server
    {
        public string Server { get; set; }
        public int Port { get; set; }
        public bool UseSSL{ get; set; }

    }

    public class RootData
    {
        public NetLock_Remote_Server NetLock_Remote_Server { get; set; }
    }

    public class Config
    {
        // Read appssettings.json file and load NetLock_Remote_Server -> Server & Port & UseSSL configuration
        public static async Task<string> Get_Connection_String()
        {
            try
            {
                // Read appssettings.json file
                string json = await File.ReadAllTextAsync("appsettings.json");

                //Logging.Handler.Debug("Classes.MySQL.Config.Get_Connection_String", "json", json);

                // Deserialize JSON string
                RootData rootData = JsonSerializer.Deserialize<RootData>(json);

                // Get NetLock_Remote_Server configuration
                string server = rootData.NetLock_Remote_Server.Server;
                int port = rootData.NetLock_Remote_Server.Port;
                bool useSSL = rootData.NetLock_Remote_Server.UseSSL;

                string connectionString = String.Empty;

                // Return NetLock_Remote_Server configuration
                if (useSSL)
                {
                    connectionString = $"https://{server}:{port}";
                }
                else
                {
                    connectionString = $"http://{server}:{port}";
                }

                return connectionString;
            }
            catch (Exception ex)
            {
                Logging.Handler.Error("Classes.MySQL.Config.Get_Connection_String", "General error", ex.ToString());
                return String.Empty;
            }
        }
    }
}
