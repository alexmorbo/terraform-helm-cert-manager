# terraform-helm-cert-manager

Terraform module for deploying cert-manager using Helm with configurable node selection and cluster issuer support.

## Features

- Deploys cert-manager using Helm
- Configurable node selection for dedicated nodes
- Support for Cloudflare cluster issuers
- Optional self-signed issuer
- Configurable label keys for node selection

## External Module

This module uses the `terraform-kubernetes-cert-manager` Terraform module:

- **Module Source**: `github.com/terraform-iaac/terraform-kubernetes-cert-manager`
- **Module Version**: `v2.6.4` (hardcoded in the module)
- **Chart Version**: Configurable via `chart_version` variable (default: `1.16.1`)
- **Repository**: [terraform-kubernetes-cert-manager](https://github.com/terraform-iaac/terraform-kubernetes-cert-manager)

The Terraform module internally deploys the official cert-manager Helm chart, allowing you to configure the chart version while the module version remains fixed.

## Variables

### Core Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `chart_version` | cert-manager Helm chart version | `string` | `"1.16.1"` | no |
| `dedicated_nodes` | Whether to use dedicated nodes for cert-manager components | `bool` | `false` | no |
| `dedicated_node_group` | Node group value for dedicated node selection | `string` | `"default"` | no |

### Label Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `node_group_label` | Label key for node group selection (e.g., "company.com/node-group") | `string` | `"company.com/node-group"` | no |
| `dedicated_label` | Label key for dedicated node selection (e.g., "company.com/dedicated") | `string` | `"company.com/dedicated"` | no |

### Cluster Issuer Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cloudflare_accounts` | Map of Cloudflare accounts with email and API token | `map(object({email = string, token = string}))` | `{}` | no |
| `cloudflare_cname_strategy` | CNAME strategy for Cloudflare DNS challenges | `string` | `null` | no |
| `self_signed_issuer` | Whether to create a self-signed cluster issuer | `bool` | `false` | no |

## Usage

### Basic Usage

```hcl
module "cert_manager" {
  source = "github.com/alexmorbo/terraform-helm-cert-manager"

  chart_version = "1.16.1"
}
```

### With Dedicated Nodes

```hcl
module "cert_manager" {
  source = "github.com/alexmorbo/terraform-helm-cert-manager"

  dedicated_nodes = true
  dedicated_node_group = "cert-manager"

  # Custom label keys
  node_group_label = "company.com/node-group"
  dedicated_label = "company.com/dedicated"
}
```

### With Cloudflare Cluster Issuer

```hcl
module "cert_manager" {
  source = "github.com/alexmorbo/terraform-helm-cert-manager"

  cloudflare_accounts = {
    production = {
      email = "admin@example.com"
      token = "your-cloudflare-api-token"
    }
  }

  cloudflare_cname_strategy = "Follow"
}
```

## Outputs

| Name | Description |
|------|-------------|
| `cluster_issuers` | Map of created cluster issuers |

## Requirements

- Terraform >= 1.0

## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 2.0 |
| helm | >= 2.0 |

## License

This project is licensed under the terms specified in the LICENSE file.
