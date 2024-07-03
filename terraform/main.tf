provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  initial_node_count = 3

  node_config {
    machine_type = "e2-medium"
  }
}

output "kubeconfig" {
  value     = google_container_cluster.primary.kubeconfig_raw
  sensitive = true
}
