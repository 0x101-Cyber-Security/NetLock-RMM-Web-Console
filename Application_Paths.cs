using System.Runtime.InteropServices;

namespace NetLock_RMM_Web_Console
{
    public class Application_Paths
    {
        //public static string logs_dir = @"C:\ProgramData\0x101 Cyber Security\NetLock RMM\Web Console\Logs";
        public static string logs_dir = Path.Combine(GetBasePath(), "0x101 Cyber Security", "NetLock RMM", "Web Console", "Logs");
        public static string debug_txt_path = Path.Combine(GetBasePath(), "0x101 Cyber Security", "NetLock RMM", "Web Console", "Logs", "debug.txt");

        private static string GetBasePath()
        {
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                return Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData);
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                return "/var";
            }
            else
            {
                throw new NotSupportedException("Unsupported OS");
            }
        }

        //public static string debug_txt_path = @"C:\ProgramData\0x101 Cyber Security\NetLock RMM\Web Console\debug.txt";

        //URLs
        public static string redirect_path = "/redirect";
    }
}
