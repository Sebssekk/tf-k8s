variable "host_os" {
  description = "The OS where Terraform is running (linux or windows)"
  type        = string
  default     = "linux" # Set to "windows" if running on native Windows cmd/powershell
  
  validation {
    condition     = contains(["linux", "windows"], var.host_os)
    error_message = "The host_os must be either 'linux' or 'windows'."
  }
}

variable "cluster_num" {
  type = number
  description = "Number of Kubernetes cluster to create"
  default = 1
}

variable "cp_num" {
  type = number
  description = "Number of Control Plane nodes per cluster"
  default = 1
}

variable "worker_num" {
  type = number
  description = "Number of Worker nodes per cluster"
  default = 1
}

variable "cluster_node_subnet_mask" {
  type = number
  description = "Subnet size for each cluster"
  default = 24
}

variable "cluster_node_cidr" {
  type = string
  description = "CIDR for cluster node networks"
  default = "192.168.0.0/16"
}

variable "node_ssh_user" {
  type = string
  default = "ubuntu"
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