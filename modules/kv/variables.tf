variable "resource_group_name" {
  description = "Name of the resource group for Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region for Key Vault"
  type        = string
}

variable "keyvault_name" {
  description = "Name of the Key Vault (3-24 chars, alphanumeric and hyphens)"
  type        = string
}

variable "sku_name" {
  description = "SKU for Key Vault"
  type        = string
  default     = "standard"
  
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "SKU must be standard or premium."
  }
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention in days"
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Enable purge protection"
  type        = bool
  default     = false
}

variable "default_network_action" {
  description = "Default network action for Key Vault"
  type        = string
  default     = "Allow"
  
  validation {
    condition     = contains(["Allow", "Deny"], var.default_network_action)
    error_message = "Must be Allow or Deny."
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
