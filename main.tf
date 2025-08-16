locals {
  name = "cert-manager"
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = local.name
  }
}

locals {
  namespace = kubernetes_namespace.namespace.metadata[0].name
  cloudflare_cluster_issuers = {
    for account, data in var.cloudflare_accounts : account => data
  }

  node_selector_paths = [
    "nodeSelector", "webhook.nodeSelector", "cainjector.nodeSelector", "startupapicheck.nodeSelector"
  ]
  tolerations_paths = ["tolerations", "webhook.tolerations", "cainjector.tolerations", "startupapicheck.tolerations"]

  additional_set = var.dedicated_nodes ? flatten([
    [
      for path in local.node_selector_paths : {
        name  = "${path}.${replace(var.node_group_label, ".", "\\.")}"
        value = var.dedicated_node_group
      }
    ],

    [
      for path in local.tolerations_paths : [
        {
          name  = "${path}[0].key"
          value = var.dedicated_label
        },
        {
          name  = "${path}[0].value"
          value = var.dedicated_node_group
        },
        {
          name  = "${path}[0].effect"
          value = "NoExecute"
        }
      ]
    ]
  ]) : []
}


module "cert_manager" {
  source = "github.com/terraform-iaac/terraform-kubernetes-cert-manager?ref=v2.6.4"

  namespace_name        = local.namespace
  chart_version         = var.chart_version
  create_namespace      = false
  cluster_issuer_create = false
  cluster_issuer_email  = ""

  additional_set = local.additional_set
}

module "cloudflare_cluster_issuer" {
  for_each = local.cloudflare_cluster_issuers

  source = "./modules/cluster_issuer"

  type                 = "cloudflare"
  name                 = each.key
  namespace            = local.namespace
  cluster_issuer_email = each.value.email
  cloudflare_api_token = each.value.token
  cname_strategy       = var.cloudflare_cname_strategy

  depends_on = [kubernetes_namespace.namespace, module.cert_manager]
}

module "self_signed_issuer" {
  count = var.self_signed_issuer ? 1 : 0

  source = "./modules/cluster_issuer"
  type   = "self-signed"
  name   = "self-signed"
}
