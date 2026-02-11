variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = null # Uses latest stable if not specified
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster"
  type        = string
}

variable "identity_ids" {
  description = "List of user-assigned managed identity IDs"
  type        = list(string)
}

variable "default_node_pool" {
  description = "Default/system node pool configuration"
  type = object({
    name                  = string
    vm_size               = string
    node_count            = number
    min_count             = number
    max_count             = number
    subnet_id             = string
    max_pods              = number
    os_disk_size_gb       = number
    auto_scaling_enabled  = bool
  })
}

variable "user_node_pools" {
  description = "Map of user node pool configurations"
  type = map(object({
    vm_size               = string
    node_count            = number
    min_count             = number
    max_count             = number
    subnet_id             = string
    max_pods              = number
    os_disk_size_gb       = number
    auto_scaling_enabled  = bool
    mode                  = optional(string, "User")
    os_type               = optional(string, "Linux")
    priority              = optional(string, "Regular")
  }))
  default = {}
}

variable "network_plugin" {
  description = "Network plugin (azure or kubenet)"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Network policy (azure, calico, or null)"
  type        = string
  default     = null
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services (must not overlap with VNet)"
  type        = string
  default     = "172.16.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address within service_cidr for cluster DNS"
  type        = string
  default     = "172.16.0.10"
}

variable "enable_key_vault_secrets_provider" {
  description = "Enable Azure Key Vault Secrets Provider"
  type        = bool
  default     = true
}

variable "enable_workload_identity" {
  description = "Enable workload identity"
  type        = bool
  default     = true
}

variable "oidc_issuer_enabled" {
  description = "Enable OIDC issuer for workload identity"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
