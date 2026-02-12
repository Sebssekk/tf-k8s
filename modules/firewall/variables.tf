variable "prefix_name" {
  type = string
  default = "k8s"
}

variable "vpc_id" {
  type = string
  description = "Cluster VPC ID"
}

variable "cp_sa_email" {
  type = string
  description = "CP service account email"
}

variable "wk_sa_email" {
  type = string
  description = "WK service account email"
}