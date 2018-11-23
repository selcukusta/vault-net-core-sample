# Create On-Prem Vault (Single Instance and File Backend) with Vagrant

Run it;

```bash
vagrant up
```

Use configuration parameters in .NET Core project, you need to change `WebApp\appsettings.json` file:

```json
{
  "Vault": {
    "Url": "http://172.81.81.2:8200",
    "Token": "[YOUR TOKEN]",
    "MountPoint": "[KV STORE]",
    "Path": "[PATH]"
  }
}
```