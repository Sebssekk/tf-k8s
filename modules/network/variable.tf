variable "prefix_name" {
  type = string
  default = "k8s"
}

variable "shared_vpc" {
  type = bool
  description = "If the VPC already exists (its id must be passed as an input)"
  default = false
}

variable "shared_vpc_id" {
  type = string
  nullable = true
  description = "If shared VPC is set to true, this is the id of the shared vpc"
  default = null
}

variable "shared_subnet" {
  type = bool
  description = "If the Subnet already exists (its id must be passed as an input)"
  default = false
}

variable "shared_subnet_id" {
  type = string
  nullable = true
  description = "If shared Subnet is set to true, this is the id of the shared subnet"
  default = null
}

variable "gcp_region" {
  type = string
  description = "GCP Region for subnet"
}

variable "subnet_cidr" {
  type = string
  description = "CIDR of the subnet"
}

variable "create_router_nat" {
  type = bool
  default = true
  description = "If create a Cloud Router and a Cloud Router NAT in the VPC"
}