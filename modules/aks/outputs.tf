output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "kube_config" {
  description = "Kubeconfig for the cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "kubelet_identity" {
  description = "Kubelet managed identity"
  value = {
    client_id   = azurerm_kubernetes_cluster.this.kubelet_identity[0].client_id
    object_id   = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
    user_assigned_identity_id = azurerm_kubernetes_cluster.this.kubelet_identity[0].user_assigned_identity_id
  }
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity"
  value       = var.oidc_issuer_enabled ? azurerm_kubernetes_cluster.this.oidc_issuer_url : null
}

output "key_vault_secrets_provider" {
  description = "Key Vault secrets provider identity"
  value = var.enable_key_vault_secrets_provider ? {
    client_id = azurerm_kubernetes_cluster.this.key_vault_secrets_provider[0].secret_identity[0].client_id
    object_id = azurerm_kubernetes_cluster.this.key_vault_secrets_provider[0].secret_identity[0].object_id
  } : null
}

output "user_node_pool_ids" {
  description = "Map of user node pool IDs"
  value       = { for k, v in azurerm_kubernetes_cluster_node_pool.user_pools : k => v.id }
}
