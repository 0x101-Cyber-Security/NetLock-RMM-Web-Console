using MySqlConnector;

namespace NetLock_Web_Console.Classes.Authentication
{
    public class User
    {
        public static async Task<bool> Verify_User(string username, string password)
        {
            bool isPasswordCorrect = false;

            MySqlConnection conn = new MySqlConnection(Application_Settings.connectionString);

            try
            {
                conn.Open();

                MySqlCommand cmd = new MySqlCommand("SELECT * FROM accounts WHERE username = @username;", conn);
                cmd.Parameters.AddWithValue("@username", username);

                MySqlDataReader reader = cmd.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                        isPasswordCorrect = BCrypt.Net.BCrypt.Verify(password, reader["password"].ToString());
                }
                reader.Close();

                return isPasswordCorrect;
            }
            catch (Exception ex)
            {
                return false;
            }
            finally
            { 
                conn.Close();
            }
        }
    }
}
