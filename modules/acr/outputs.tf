output "acr_id" {
  description = "ID of the Azure Container Registry"
  value       = azurerm_container_registry.acr.id
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "Login server URL for ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "identity_principal_id" {
  description = "Principal ID of the ACR managed identity"
  value       = azurerm_user_assigned_identity.acr.principal_id
}

output "identity_id" {
  description = "ID of the ACR managed identity"
  value       = azurerm_user_assigned_identity.acr.id
}
