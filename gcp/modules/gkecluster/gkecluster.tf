resource "random_pet" "prefix" {
}

resource "google_container_cluster" "primary" {
  name               = "${random_pet.prefix.id}-gke"
  location           = var.location
  min_master_version = var.kubernetes_version

  initial_node_count = 3
 
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      foo = "bar"
    }

    tags = ["foo", "bar"]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

