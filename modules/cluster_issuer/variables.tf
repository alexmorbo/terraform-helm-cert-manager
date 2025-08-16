variable "name" {
  description = "Cluster Issuer Name, used for annotations"
  type        = string
  default     = "cert-manager"
}

variable "namespace" {
  description = "Namespace for ClusterIssuer"
  type        = string
  default     = null
}

variable "type" {
  description = "Type of ClusterIssuer"
  type        = string
  default     = "self-signed"

  validation {
    condition     = contains(["self-signed", "cloudflare"], var.type)
    error_message = "Type must be one of self-signed or cloudflare."
  }
}

variable "cluster_issuer_server" {
  description = "The ACME server URL"
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "cluster_issuer_preferred_chain" {
  description = "Preferred chain for ClusterIssuer"
  type        = string
  default     = "ISRG Root X1"
}

variable "cluster_issuer_email" {
  description = "Email address used for ACME registration"
  type        = string
  default     = null
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  default     = null
}

variable "cname_strategy" {
  description = "CNAME strategy for ClusterIssuer"
  type        = string
  default     = null

  validation {
    condition     = var.cname_strategy == null || can(regex("^(None|Follow)$", var.cname_strategy))
    error_message = "CNAME strategy must be null, None or Follow."
  }
}
