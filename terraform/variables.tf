variable "project_id" {
  description = "kube-projects-427711"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "kube-cluster"
  type        = string
  default     = "gke-cluster"
}

variable "service_account" {
  description = "The service account email for the nodes"
  type        = string
}
