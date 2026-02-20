terraform {
  required_version = ">= 1.14.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.61.0"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
