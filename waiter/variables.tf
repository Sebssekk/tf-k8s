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
  description = "The GCP Project ID where the instance resides."
  type        = string
}

variable "zone" {
  description = "The zone of the instance."
  type        = string
}

variable "instance_name" {
  description = "The name of the instance to monitor."
  type        = string
}

variable "instance_id" {
  description = "The unique ID of the instance (used to trigger re-runs if the instance is recreated)."
  type        = string
}

variable "attribute_namespace" {
  description = "The namespace of the guest attribute (e.g., 'startup-status')."
  type        = string
  default     = "status"
}

variable "attribute_key" {
  description = "The key of the guest attribute (e.g., 'status')."
  type        = string
  default     = "startup"
}

variable "expected_value" {
  description = "The value to wait for (e.g., 'completed')."
  type        = string
  default     = "completed"
}

variable "timeout_seconds" {
  description = "Maximum time to wait in seconds."
  type        = number
  default     = 3600 # 1h
}