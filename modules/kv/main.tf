data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "kv" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_key_vault" "kv" {
  name                       = var.keyvault_name
  location                   = azurerm_resource_group.kv.location
  resource_group_name        = azurerm_resource_group.kv.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  network_acls {
    bypass         = "AzureServices"
    default_action = var.default_network_action
  }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]

  certificate_permissions = [
    "Get", "List", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]
}
