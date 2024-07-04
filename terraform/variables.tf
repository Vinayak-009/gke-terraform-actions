variable "project_id" {
  description = "kube-projects-427711"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-c"
}

variable "cluster_name" {
  description = "kube-cluster"
  type        = string
  default     = "gke-cluster"
}

variable "machine_type" {
  type        = string
  description = "Type of the node compute engines."
}

variable "min_count" {
  type        = number
  description = "Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count."
}

variable "max_count" {
  type        = number
  description = "Maximum number of nodes in the NodePool. Must be >= min_node_count."
}

variable "disk_size_gb" {
  type        = number
  description = "Size of the node's disk."
}

variable "initial_node_count" {
  type        = number
  description = "The number of nodes to create in this cluster's default node pool."
}

variable "service_account" {
  description = "The service account email for the nodes"
  type        = string
}
