terraform {
  required_version = ">= 1.14.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.60.0"
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "acr" {
  name                = "id-${var.acr_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.acr.id]
  }

  network_rule_set {
    default_action = var.default_network_action
    ip_rule        = [for ip in var.allowed_ip_ranges : { action = "Allow", ip_range = ip }]
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "current_user_acr_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = data.azurerm_client_config.current.object_id
}

