provider "google" {
  project = var.project_id
  region  = var.region
}

module "gke" {
  source      = "terraform-google-modules/kubernetes-engine/google"
  # Update the version based on the latest stable version
  version     = ">= 4.1.0" 
  project_id  = var.project_id
  region      = var.region
  zones       = var.zones
  name        = var.name
  network     = "default"
  subnetwork  = "default"
  # http_load_balancing = false (deprecated in newer modules)
  horizontal_pod_autoscaling = true
  # kubernetes_dashboard = true (consider separate deployment)
  node_pools = [
    {
      name        = "default-node-pool"
      machine_type    = var.machine_type
      min_count     = var.min_count
      max_count     = var.max_count
      disk_size_gb    = var.disk_size_gb
      disk_type     = "pd-balanced"
      image_type     = "COS"
      auto_repair    = true
      auto_upgrade    = true
      service_account  = var.service_account
      preemptible    = false
      initial_node_count = var.initial_node_count
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    "default-node-pool" = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    "default-node-pool" = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    "default-node-pool" = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    "default-node-pool" = [
      {
        key   = "default-node-pool"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    "default-node-pool" = [
      "default-node-pool",
    ]
  }
}
