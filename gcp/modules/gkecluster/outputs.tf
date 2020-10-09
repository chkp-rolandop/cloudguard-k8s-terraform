output "kubernetes_cluster_id" {
  value = google_container_cluster.primary.id
}

output "kubernetes_cluster_self_link" {
  value = google_container_cluster.primary.self_link
}

output "kubernetes_cluster_name" {
  value = google_container_cluster.primary.name
}

output "kubernetes_cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "client_key" {
  value = google_container_cluster.primary.master_auth.0.client_key
}

output "client_certificate" {
  value = google_container_cluster.primary.master_auth.0.client_certificate
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

output "access_token" {
  value = data.google_client_config.gke_primary.access_token
}
