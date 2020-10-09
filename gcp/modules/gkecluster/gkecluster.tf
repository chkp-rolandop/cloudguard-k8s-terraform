resource "random_pet" "prefix" {
}

resource "google_container_cluster" "primary" {
  name     = "${random_pet.prefix.id}-gke"
  location = var.location

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = true
    }
  }

}
resource "google_container_node_pool" "primary_preemtible_nodes" {
  name       = "${random_pet.prefix.id}-node-pool"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]


  }
}
data "google_client_config" "gke_primary" {
}
