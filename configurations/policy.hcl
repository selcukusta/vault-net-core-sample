# Allow a token to read and list webapp kv store
path "webapp/*" {
    capabilities = ["read", "list"]
}