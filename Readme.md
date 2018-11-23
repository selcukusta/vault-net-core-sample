# Create On-Prem Vault (Single Instance and File Backend) with Vagrant

Run it;

```bash
vagrant up
```

To create read-only policy;
```bash
vagrant ssh node01
vault policy write readonly_policy /vagrant/configurations/policy.hcl
```

To create read-only token and use for applications;
```bash
vagrant ssh node01
vault token create -display-name=readonly_token -policy=readonly_policy
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