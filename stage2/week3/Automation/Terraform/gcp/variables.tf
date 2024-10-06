variable "gcp_svc_key" {
  type        = string
  description = "Path to the GCP service account key file"
}

variable "gcp_project" {
  type        = string
  description = "GCP project ID"
}

variable "gcp_region" {
  type        = string
  description = "GCP region"
}

variable "gcp_zone" {
  type        = string
  description = "GCP zone"
}

variable "gcp_images" {
  type = map(string)
  description = "Map of OS images to use for instances"
}