variable "prefix_name" {
  type = string
  default = "k8s"
}
variable "host_os" {
  description = "The OS where Terraform is running (linux or windows)"
  type        = string
  default     = "linux" # Set to "windows" if running on native Windows cmd/powershell
  
  validation {
    condition     = contains(["linux", "windows"], var.host_os)
    error_message = "The host_os must be either 'linux' or 'windows'."
  }
}

variable "project_id" {
  description = "GCP Project ID"
  type = string
}

variable "gcp_region" {
  description = "GCP Region"
  type = string
  default = "us-central1"
}

locals {
  zones = ["a", "b", "c"]
}