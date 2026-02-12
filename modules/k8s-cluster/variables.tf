variable "prefix_name" {
  type = string
  default = "k8s"
}

variable "project_id" {
  description = "GCP Project ID"
  type = string
}

variable "terraform_running_OS" {
  default = "linux"
  description = "OS running Terraform (linux or windows)"
  type = string
}

variable "gcp_region" {
  type = string
  description = "GCP Region"
}

variable "cp_machine_type" {
  type = string
  default = "e2-medium"
  description = "Machine type for CP nodes"
}

variable "wk_machine_type" {
  type = string
  default = "e2-medium"
  description = "Machine type for WK nodes"
}

variable "cp_num" {
  type = number
  description = "Number of Control Plane nodes"
  default = 1
}

variable "wk_num" {
  type = number
  description = "Number of Worker nodes"
  default = 1
}

variable "subnet_id" {
  type = string
  description = "Subnet ID for cluster"
}

variable "cp_sa_email" {
  type = string
  default = "Service Account email of Control Plane Nodes"
}

variable "wk_sa_email" {
  type = string
  default = "Service Account email of Worker Nodes"
}

variable "node_image" {
  type = string
  description = "OS image for Cluster ndoes"
  default = "ubuntu-2204-lts"
}

variable "node_disk_size" {
  type = number
  description = "Size of node disk in GB"
  default = 20
}

variable "node_ssh_user" {
  type = string
  description = "SSH user for cluster nodes"
  default = "ubuntu"
}

variable "shared_ssh_keypair" {
  type = bool
  description = "If an ssh key pair is provided"
  default = false
}

variable "shared_ssh_privatekey_material" {
  type = string
  description = "The provided ssh private key material"
  nullable = true
  default = null
}
variable "shared_ssh_publickey_material" {
  type = string
  description = "The provided ssh public key material"
  nullable = true
  default = null
}

variable "K8S_VERSION" {
  type = string
  description = "Kubernetes Version"
  default = "1.35"
}
variable "ETCD_VERSION" {
  type = string
  description = "ETCD cli version"
  default = "3.6.7"
}
variable "CILIUM_VERSION" {
  type = string
  description = "Version of CILIUM CNI"
  default = "1.19.0"
}

variable "POD_NETWORK_CIDR" {
  type = string
  description = "POD network cidr"
  default = "172.16.0.0/16"
}

variable "CLUSTER_READY" {
  type = bool
  description = "If automatically join clusters"
  default = true
}