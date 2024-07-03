provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

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

  ip_allocation_policy {
    use_ip_aliases = true
  }

  master_authorized_networks_config {
    cidr_blocks = []
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }


    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  release_channel {
    channel = "REGULAR"
  }

  node_pool {
    name       = "default-pool"
    node_count = 2
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
  }

  network    = "projects/${var.project_id}/global/networks/default"
  subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/default"

  shielded_nodes {
    enabled = true
  }
}

output "kubeconfig_file_path" {
  value = local_file.kubeconfig.filename
}
