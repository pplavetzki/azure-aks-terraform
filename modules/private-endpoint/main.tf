terraform {
  required_version = ">= 1.14.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.61.0"
    }
  }
}

resource "azurerm_private_dns_zone" "this" {
  count               = var.create_dns_zone ? 1 : 0
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  count                 = var.create_dns_zone ? 1 : 0
  name                  = "vnet-link-${var.private_endpoint_name}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[0].name
  virtual_network_id    = var.virtual_network_id
  tags                  = var.tags
}

resource "azurerm_private_endpoint" "this" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.private_endpoint_name}-connection"
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = var.subresource_names
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.create_dns_zone ? [1] : []
    content {
      name                 = "dns-zone-group"
      private_dns_zone_ids = [azurerm_private_dns_zone.this[0].id]
    }
  }

  tags = var.tags
}