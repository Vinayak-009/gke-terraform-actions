provider "google" {
  project = var.project_id
  region  = var.region
}

# Data source to check if the cluster already exists
data "google_container_cluster" "existing_cluster" {
  name     = "kube-cluster"
  location = "us-central1-c"

  depends_on = [google_container_cluster.primary]  # Ensure primary cluster is created first
}

# Conditionally create the cluster based on its existence
resource "google_container_cluster" "primary" {
  count = length(data.google_container_cluster.existing_cluster.locations) > 0 ? 0 : 1

  name     = "kube-cluster"
  location = "us-central1-c"

  remove_default_node_pool = true
  initial_node_count       = 1

  node_config {
    machine_type = "e2-medium"
    disk_type    = "pd-balanced"
    disk_size_gb = 10
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    service_account = var.service_account
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  release_channel {
    channel = "REGULAR"
  }

  network    = "projects/${var.project_id}/global/networks/default"
  subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/default"
}

# Node pool configuration (if needed)
resource "google_container_node_pool" "primary_nodes" {
  count = length(data.google_container_cluster.existing_cluster.locations) > 0 ? 0 : 1

  cluster    = google_container_cluster.primary[count.index].name
  location   = google_container_cluster.primary[count.index].location
  name       = "primary-node-pool"
  node_count = 2

  node_config {
    machine_type = "e2-medium"
    disk_type    = "pd-balanced"
    disk_size_gb = 10
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    service_account = var.service_account
  }
}

# Output for kubeconfig file path (if needed)
output "kubeconfig_file_path" {
  value = google_container_cluster.primary[count.index].kubeconfig.0.output_content
}
