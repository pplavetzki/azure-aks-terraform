output "keyvault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "keyvault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.kv.name
}

output "keyvault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.kv.vault_uri
}

output "identity_principal_id" {
  description = "Principal ID of the Key Vault managed identity"
  value       = azurerm_user_assigned_identity.kv.principal_id
}

output "identity_id" {
  description = "ID of the Key Vault managed identity"
  value       = azurerm_user_assigned_identity.kv.id
}

output "identity_client_id" {
  description = "Client ID of the Key Vault managed identity for workload identity"
  value       = azurerm_user_assigned_identity.kv.client_id
}
