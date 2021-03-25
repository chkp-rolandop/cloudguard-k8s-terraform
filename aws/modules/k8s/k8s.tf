provider "kubernetes" {
	host                   = var.host
	token                  = var.access_token
	cluster_ca_certificate = var.cluster_ca_certificate
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "MyExampleApp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "nginx:stable"
          name  = "example"

          resources {
            limits   =  {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests =  {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          }
        }
      }
    }
}

resource "kubernetes_service" "example" {
  metadata {
    name = "terraform-example"
  }
  spec {
    selector = {
      test = "MyExampleApp"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
