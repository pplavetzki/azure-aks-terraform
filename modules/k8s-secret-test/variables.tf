variable "cluster_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "namespace" {
  type    = string
  default = "demo"
}

variable "keyvault_name" {
  type = string
}

variable "kv_secrets_provider_client_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "acr_login_server" {
  type = string
}
