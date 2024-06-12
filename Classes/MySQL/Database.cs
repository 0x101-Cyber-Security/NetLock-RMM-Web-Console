using MySqlConnector;

namespace NetLock_Web_Console.Classes.MySQL
{
    public class Database
    {
        public static async Task<bool> Reset_Device_Sync(bool global, string tenant_name, string location_name, string device_name)
        {
            MySqlConnection conn = new MySqlConnection(Application_Settings.connectionString);

            try
            {
                await conn.OpenAsync();

                string query = "UPDATE devices SET synced = 0 WHERE device_name = @device_name AND location_name = @location_name AND tenant_name = @tenant_name;";

                if (global)
                    query = "UPDATE devices SET synced = 0;";

                MySqlCommand cmd = new MySqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@tenant_name", tenant_name);
                cmd.Parameters.AddWithValue("@location_name", location_name);
                cmd.Parameters.AddWithValue("@device_name", device_name);

                cmd.ExecuteNonQuery();

                return true;
            }
            catch (Exception ex)
            {
                Logging.Handler.Error("Add_Policy_Dialog", "Result", ex.Message);
                return false;
            }
            finally
            {
                await conn.CloseAsync();
            }
        }
    }
}
