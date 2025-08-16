locals {
  name   = var.name
  issuer = "${local.name}-cluster-issuer"

  cname_strategy = var.cname_strategy != null ? {
    cnameStrategy = var.cname_strategy
  } : {}
}

resource "kubernetes_secret" "cloudflare_token" {
  count = var.type == "cloudflare" ? 1 : 0

  metadata {
    name      = "cluster-issuer-${local.name}-secret"
    namespace = var.namespace
  }

  data = {
    "api-token" = var.cloudflare_api_token
  }
}

resource "kubectl_manifest" "self_signed_issuer" {
  count = var.type == "self-signed" ? 1 : 0

  validate_schema = false

  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = local.issuer
    }
    spec = {
      selfSigned = {}
    }
  })
}

resource "kubectl_manifest" "cloudflare_issuer" {
  count = var.type == "cloudflare" ? 1 : 0

  validate_schema = false

  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = local.issuer
    }
    spec = {
      acme = {
        server         = var.cluster_issuer_server
        preferredChain = var.cluster_issuer_preferred_chain
        email          = var.cluster_issuer_email
        privateKeySecretRef = {
          name = "cluster-issuer-${local.name}-private-key"
        }
        solvers = [
          {
            dns01 = merge({
              cloudflare = {
                email = var.cluster_issuer_email
                apiTokenSecretRef = {
                  name = kubernetes_secret.cloudflare_token[0].metadata[0].name
                  key  = "api-token"
                }
              },
            }, local.cname_strategy)
          }
        ]
      }
    }
  })
}
