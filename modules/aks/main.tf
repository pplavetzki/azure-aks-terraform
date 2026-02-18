terraform {
  required_version = ">= 1.14.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.60.0"
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                      = var.cluster_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = var.dns_prefix
  kubernetes_version        = var.kubernetes_version
  oidc_issuer_enabled       = var.oidc_issuer_enabled
  workload_identity_enabled = var.enable_workload_identity

  default_node_pool {
    name                  = var.default_node_pool.name
    vm_size               = var.default_node_pool.vm_size
    vnet_subnet_id        = var.default_node_pool.subnet_id
    auto_scaling_enabled  = var.default_node_pool.auto_scaling_enabled
    node_count            = var.default_node_pool.node_count
    min_count             = var.default_node_pool.min_count
    max_count             = var.default_node_pool.max_count
    max_pods              = var.default_node_pool.max_pods
    os_disk_size_gb       = var.default_node_pool.os_disk_size_gb
    
    only_critical_addons_enabled = true
  }

  identity {
    type         = "UserAssigned"
    identity_ids = var.identity_ids
  }

  network_profile {
    network_plugin = var.network_plugin
    network_policy = var.network_policy
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.enable_key_vault_secrets_provider ? [1] : []
    content {
      secret_rotation_enabled = true
    }
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "user_pools" {
  for_each = var.user_node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = each.value.vm_size
  vnet_subnet_id        = each.value.subnet_id
  auto_scaling_enabled  = each.value.auto_scaling_enabled
  node_count            = each.value.node_count
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  max_pods              = each.value.max_pods
  os_disk_size_gb       = each.value.os_disk_size_gb
  mode                  = each.value.mode
  os_type               = each.value.os_type
  priority              = each.value.priority

  tags = var.tags
}
