terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.16.0, < 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.30.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.1.3"
    }
  }
  required_version = ">= 1.11.4"
}
