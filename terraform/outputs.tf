output "kubeconfig" {
  value     = google_container_cluster.primary.kubeconfig_raw
  sensitive = true
}
