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
  default     = "Basic"
  
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
