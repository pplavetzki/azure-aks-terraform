terraform {
  required_version = ">= 1.14.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.61.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0.1"
    }
  }
}

data "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.this.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
}

resource "kubernetes_namespace_v1" "demo" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_manifest" "secret_provider_class" {
  depends_on = [kubernetes_namespace_v1.demo]

  manifest = {
    apiVersion = "secrets-store.csi.x-k8s.io/v1"
    kind       = "SecretProviderClass"
    metadata = {
      name      = "kv-secret-test"
      namespace = var.namespace
    }
    spec = {
      provider = "azure"
      parameters = {
        usePodIdentity = "false"
        useVMManagedIdentity    = "true"                          # <-- ADD
        userAssignedIdentityID  = var.kv_secrets_provider_client_id  # <-- ADD
        clientID       = var.kv_secrets_provider_client_id
        keyvaultName   = var.keyvault_name
        tenantId       = var.tenant_id
        objects        = <<-EOT
          array:
            - |
              objectName: db-connection-string
              objectType: secret
            - |
              objectName: api-key
              objectType: secret
            - |
              objectName: app-secret
              objectType: secret
        EOT
      }
    }
  }
}

resource "kubernetes_pod_v1" "test_pod" {
  depends_on = [kubernetes_namespace_v1.demo, kubernetes_manifest.secret_provider_class]

  metadata {
    name      = "kv-secret-test"
    namespace = var.namespace
  }

  spec {
    container {
      name  = "kv-secret-test"
      image = "${var.acr_login_server}/kv-secret-test:latest"

      volume_mount {
        name       = "secrets"
        mount_path = "/mnt/secrets"
        read_only  = true
      }
    }

    volume {
      name = "secrets"
      csi {
        driver    = "secrets-store.csi.k8s.io"
        read_only = true
        volume_attributes = {
          secretProviderClass = "kv-secret-test"
        }
      }
    }
  }
}