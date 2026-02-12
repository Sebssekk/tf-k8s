variable "prefix_name" {
  type = string
  default = "k8s"
}

variable "project_id" {
  description = "GCP Project ID"
  type = string
}

variable "shared_sa_cp" {
  type = bool
  description = "If ServiceAccount for CP is provided"
  default = false
}

variable "shared_sa_cp_email" {
  type = string
  nullable = true
  default = null
  description = "Email of the CP provided SA (if shared)"
}

variable "shared_sa_wk" {
  type = bool
  description = "If ServiceAccount for WK is provided"
  default = false
}

variable "shared_sa_wk_email" {
  type = string
  nullable = true
  default = null
  description = "Email of the WK provided SA (if shared)"
}

variable "shared_node_role" {
  type = bool
  description = "If a Role has been provided for cluster nodes"
  default = false
}

variable "shared_node_role_id" {
  type = string
  description = "The ID of the provided Role for nodes"
  nullable = true
  default = null
}
