variable "chart_version" {
  type = string

  default = "1.17.2"
}

variable "cloudflare_accounts" {
  type = map(object({
    email = string
    token = string
  }))

  default = {}
}

variable "cloudflare_cname_strategy" {
  type = string

  default = null
}

variable "self_signed_issuer" {
  type = bool

  default = false
}

variable "dedicated_nodes" {
  type = bool

  default = false
}

variable "dedicated_node_group" {
  type = string

  default = "default"
}

variable "node_group_label" {
  type        = string
  description = "The label key for node group selection"
  default     = "company.com/node-group"
}

variable "dedicated_label" {
  type        = string
  description = "The label key for dedicated node selection"
  default     = "company.com/dedicated"
}
