output "cluster_issuers" {
  value = merge(
    { for k, v in module.cloudflare_cluster_issuer : v.name => v.issuer },
    { for k, v in module.self_signed_issuer : v.name => v.issuer },
  )
}

output "namespace" {
  value = local.namespace
}
