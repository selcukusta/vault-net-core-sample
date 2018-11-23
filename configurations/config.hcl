ui = true

backend "file" {
  path = "/var/lib/vault"
}

listener "tcp" {
  tls_disable = 1
  address = "172.81.81.2:8200"
}
