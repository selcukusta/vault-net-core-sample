using System;

namespace WebApp.Models
{
    public class Vault
    {
        public string Url { get; set; }
        public string Token { get; set; }
        public string MountPoint { get; set; }
        public string Path { get; set; }
    }
}