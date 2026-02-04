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

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.acr.name
}
