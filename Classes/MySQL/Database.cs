using MySqlConnector;
using System.Data.Common;

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

        // Use MySQL Reader. Get the guid from table tenants and the guid from table locations
        public static async Task<(string, string)> Get_Tenant_Location_Guid(string tenant_name, string location_name)
        {
            MySqlConnection conn = new MySqlConnection(Application_Settings.connectionString);

            string tenant_guid = String.Empty;
            string location_guid = String.Empty;

            try
            {
                await conn.OpenAsync();

                // Abfrage für tenant_guid
                string tenantGuidQuery = "SELECT guid FROM tenants WHERE name = @tenant_name;";
                MySqlCommand tenantCmd = new MySqlCommand(tenantGuidQuery, conn);
                tenantCmd.Parameters.AddWithValue("@tenant_name", tenant_name);

                using (DbDataReader tenantReader = await tenantCmd.ExecuteReaderAsync())
                {
                    if (tenantReader.HasRows && await tenantReader.ReadAsync())
                    {
                        tenant_guid = tenantReader["guid"].ToString();
                    }
                }

                // Abfrage für location_guid
                string locationGuidQuery = "SELECT guid FROM locations WHERE name = @location_name;";
                MySqlCommand locationCmd = new MySqlCommand(locationGuidQuery, conn);
                locationCmd.Parameters.AddWithValue("@location_name", location_name);

                using (DbDataReader locationReader = await locationCmd.ExecuteReaderAsync())
                {
                    if (locationReader.HasRows && await locationReader.ReadAsync())
                    {
                        location_guid = locationReader["guid"].ToString();
                    }
                }

                return (tenant_guid, location_guid);
            }
            catch (Exception ex)
            {
                Logging.Handler.Error("/devices -> Get_Tenant_Location_Guid", "MySQL_Query", ex.Message);
                return (String.Empty, String.Empty);
            }
            finally
            {
                await conn.CloseAsync();
            }
        }
    }
}
