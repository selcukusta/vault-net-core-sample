#!/bin/sh
echo "Vault version: $1"
echo "running apt-get update and installing some packages"
sudo apt-get update && sudo apt-get install -yq unzip
echo "get Vault package"
cd /tmp
sudo wget https://releases.hashicorp.com/vault/$1/vault_$1_linux_amd64.zip
echo "validate Vault package"
sudo wget https://releases.hashicorp.com/vault/$1/vault_$1_SHA256SUMS
sudo grep linux_amd64 vault_$1_SHA256SUMS | sha256sum -c -
echo "unzip Vault"
sudo unzip vault_$1_linux_amd64.zip
echo "install Vault"
sudo cp vault /usr/local/bin/
sudo setcap cap_ipc_lock=+ep /usr/local/bin/vault
echo "create and configure Vault user"
sudo useradd -r -d /var/lib/vault -s /bin/nologin vault
sudo install -o vault -g vault -m 750 -d /var/lib/vault
sudo cp /vagrant/configurations/config.hcl /etc/vault.hcl
sudo chown vault:vault /etc/vault.hcl 
sudo chmod 640 /etc/vault.hcl 
echo "create Vault service on systemd"
sudo cat > /etc/systemd/system/vault.service  << EOF
[Unit]
Description=a tool for managing secrets
Documentation=https://vaultproject.io/docs/
After=network.target
ConditionFileNotEmpty=/etc/vault.hcl

[Service]
User=vault
Group=vault
ExecStart=/usr/local/bin/vault server -config=/etc/vault.hcl
ExecReload=/usr/local/bin/kill --signal HUP $MAINPID
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
# If you're using ubuntu/bionic64 (Ubuntu 18.04.1 LTS) and get "code=exited, status=213/SECUREBITS" error while trying to start Vault service; below line should be uncommented!
#AmbientCapabilities=CAP_IPC_LOCK
SecureBits=keep-caps
NoNewPrivileges=yes
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOF
echo "set sytemctl status"
sudo systemctl start vault
sudo systemctl enable vault