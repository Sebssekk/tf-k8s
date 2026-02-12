variable "project_id" {
  description = "GCP Project ID"
  type = string
}

variable "regions" {
  description = "GCP Region"
  type = list
  default = ["us-central1"]
}

locals {
  zones = ["a", "b", "c"]
}