terraform {
  required_version = ">= 1.14.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.61.0"
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "kv" {
  name                = "id-${var.keyvault_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_key_vault" "kv" {
  name                       = var.keyvault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled
  rbac_authorization_enabled = var.rbac_authorization_enabled

  network_acls {
    bypass         = "AzureServices"
    default_action = var.default_network_action
    ip_rules       = var.allowed_ip_ranges  # <-- ADDED THIS LINE
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "current_user_secrets" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"  # Changed from "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "kv_identity_secrets" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.kv.principal_id
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each = var.secrets

  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_role_assignment.current_user_secrets
  ]
}
