terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.19.0"
    }
  }
}

provider "google" {
  # Configuration options
  #region  = var.region
  project = var.project_id
}

provider "tls" {
  # Configuration options
}

provider "local" {
  # Configuration options
}