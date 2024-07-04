variable "project_id" {
  description = "The project ID of your Google Cloud project"
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "kube-cluster"
}

variable "region" {
  description = "The region to deploy the GKE cluster in"
  default     = "us-central1"
}

variable "zone" {
  description = "The zone within the region to deploy the GKE cluster in"
  default     = "us-central1-c"
}

variable "service_account" {
  description = "The service account to associate with GKE nodes"
  default     = "gke-terraform-actions@kube-projects-427711.iam.gserviceaccount.com"
}
