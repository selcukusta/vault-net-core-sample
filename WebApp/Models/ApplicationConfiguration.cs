
using System;
using System.Threading.Tasks;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using VaultSharp;
using VaultSharp.V1.AuthMethods;
using VaultSharp.V1.AuthMethods.Token;

namespace WebApp.Models
{
    public class ApplicationConfiguration
    {
        public string Bar { get; set; }
        public string Baz { get; set; }
        public string Foo { get; set; }
        public ApplicationConfiguration(Vault vaultConfiguration) => Init(vaultConfiguration);

        private async void Init(Vault vaultConfiguration)
        {
            IAuthMethodInfo authMethod = new TokenAuthMethodInfo(vaultConfiguration.Token);
            var vaultClientSettings = new VaultClientSettings(vaultConfiguration.Url, authMethod);

            IVaultClient vaultClient = new VaultClient(vaultClientSettings);
            var kv2Secret = await vaultClient.V1.Secrets.KeyValue.V2.ReadSecretAsync(vaultConfiguration.Path, mountPoint: vaultConfiguration.MountPoint);
            var data = kv2Secret.Data;
            this.Bar = data.Data["Bar"].ToString();
            this.Baz = data.Data["Baz"].ToString();
            this.Foo = data.Data["Foo"].ToString();
        }
    }
}