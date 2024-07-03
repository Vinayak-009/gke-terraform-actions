provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

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

  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  enable_shielded_nodes = true



  # Optional: Network configuration
  network    = "projects/${var.project_id}/global/networks/default"
  subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/default"

  # Optional: Kubernetes Alpha features
  enable_kubernetes_alpha = false

  # Optional: Security posture
  security_posture {
    mode = "STANDARD"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
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

resource "local_file" "kubeconfig" {
  content  = google_container_cluster.primary.kubeconfig_raw
  filename = "./kubeconfig"
}

output "kubeconfig_file_path" {
  value = local_file.kubeconfig.filename
}
