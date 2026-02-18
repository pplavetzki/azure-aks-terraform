variable "resource_group_name" {
  description = "Name of the resource group for ACR"
  type        = string
}

variable "location" {
  description = "Azure region for ACR"
  type        = string
}

variable "acr_name" {
  description = "Name of the Azure Container Registry (lowercase, alphanumeric only)"
  type        = string
}

variable "sku" {
  description = "SKU tier for ACR"
  type        = string
  default     = "Premium"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
  default     = false
}

variable "default_network_action" {
  description = "Default network action for ACR (Allow or Deny)"
  type        = string
  default     = "Deny"

  validation {
    condition     = contains(["Allow", "Deny"], var.default_network_action)
    error_message = "Must be Allow or Deny."
  }
}

variable "allowed_ip_ranges" {
  description = "List of allowed IP addresses/CIDR ranges for ACR access"
  type        = list(string)
  default     = []
}

variable "allowed_subnet_ids" {
  type    = list(string)
  default = []
}

variable "public_network_access_enabled" {
  description = "Enable public network access for ACR"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
